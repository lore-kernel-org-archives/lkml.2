Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759803Ab2JLQ35 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 12:29:57 -0400
Received: from mail.avalus.com ([89.16.176.221]:33751 "EHLO mail.avalus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758140Ab2JLQ3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 12:29:55 -0400
Date: Fri, 12 Oct 2012 17:29:50 +0100
From: Alex Bligh <alex@alex.org.uk>
Reply-To: Alex Bligh <alex@alex.org.uk>
To: Michal Hocko <mhocko@suse.cz>
cc: linux-kernel@vger.kernel.org, Alex Bligh <alex@alex.org.uk>
Subject: Re: Local DoS through write heavy I/O on CFQ & Deadline
Message-ID: <3D1C85A52BB960B79E37AC30@nimrod.local>
In-Reply-To: <20121012145838.GD22083@dhcp22.suse.cz>
References: <0B138F62-16BF-4295-9AD9-64C0BB39FCE2@alex.org.uk>
 <20121012133044.GA10115@dhcp22.suse.cz>
 <E6EF14955C67D6CA58918872@nimrod.local>
 <20121012145838.GD22083@dhcp22.suse.cz>
X-Mailer: Mulberry/4.0.8 (Mac OS X)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael,

--On 12 October 2012 16:58:39 +0200 Michal Hocko <mhocko@suse.cz> wrote:

> Once dirty_ratio (resp. dirty_bytes) limit is hit then the process which
> writes gets throttled. If this is not the case then there is a bug in
> the throttling code.

I believe that is the problem.

>> Isn't the only thing that is going to change that it ends up
>> triggering the writeback earlier?
>
> Set the limit lowe?

I think you mean 'lower'. If I do that, what I think will happen
is that it will start the write-back earlier, but the writeback
once started will not keep up with the generation of data, possibly
because the throttling isn't going to work. Note that for
instance using ionice to set priority or class to 'idle'
has no effect. So, to test my hypothesis ...

>> Happy to test etc - what would you suggest, dirty_ratio=5,
>> dirty_background_ratio=2 ?
>
> These are measured in percentage. On the other hand if you use
> dirty_bytes resp. dirty_background_bytes then you get absolute numbers
> independent on the amount of memory.

... what would you suggest I set any of these to in order to test
(assuming the same box) so that it's 'low enough' that if it still
hangs, it's a bug, rather than it's simply 'not low enough'. It's
an 8G box and clearly I'm happy to set either the _ratio or _bytes
entries.

-- 
Alex Bligh
