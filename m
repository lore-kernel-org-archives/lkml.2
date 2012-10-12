Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759004Ab2JLOsj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 10:48:39 -0400
Received: from mail.avalus.com ([89.16.176.221]:59269 "EHLO mail.avalus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758745Ab2JLOsi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 10:48:38 -0400
Date: Fri, 12 Oct 2012 15:48:34 +0100
From: Alex Bligh <alex@alex.org.uk>
Reply-To: Alex Bligh <alex@alex.org.uk>
To: Michal Hocko <mhocko@suse.cz>
cc: linux-kernel@vger.kernel.org, Alex Bligh <alex@alex.org.uk>
Subject: Re: Local DoS through write heavy I/O on CFQ & Deadline
Message-ID: <E6EF14955C67D6CA58918872@nimrod.local>
In-Reply-To: <20121012133044.GA10115@dhcp22.suse.cz>
References: <0B138F62-16BF-4295-9AD9-64C0BB39FCE2@alex.org.uk>
 <20121012133044.GA10115@dhcp22.suse.cz>
X-Mailer: Mulberry/4.0.8 (Mac OS X)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--On 12 October 2012 15:30:45 +0200 Michal Hocko <mhocko@suse.cz> wrote:

>> Full info, including logs and scripts can be found at:
>>   https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1064521
>
> You seem to have 8G of RAM and dirty_ratio=20 resp.
> dirty_background_ratio=10 which means that 1.5G worth of dirty data
> until writer gets throttled which is a lot. Background writeback starts
> at 800M which is probably not sufficient as well. Have you tried to set
> dirty_bytes at a reasonable value (wrt. to your storage)?

This is for an appliance install where we have no idea how much
memory the box has in advance other than 'at least 4G' so it
is difficult to tune by default.

However, I don't think that would solve the problem as the zcat/dd
can always generate data faster than it can be written to disk unless
or until it is throttled, which it never is. Isn't the only thing that
is going to change that it ends up triggering the writeback earlier?

Happy to test etc - what would you suggest, dirty_ratio=5,
dirty_background_ratio=2 ?

-- 
Alex Bligh
