Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759537Ab2JLNas (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 09:30:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45395 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757330Ab2JLNaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 09:30:46 -0400
Date: Fri, 12 Oct 2012 15:30:45 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Alex Bligh <alex@alex.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Local DoS through write heavy I/O on CFQ & Deadline
Message-ID: <20121012133044.GA10115@dhcp22.suse.cz>
References: <0B138F62-16BF-4295-9AD9-64C0BB39FCE2@alex.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0B138F62-16BF-4295-9AD9-64C0BB39FCE2@alex.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 11-10-12 13:23:32, Alex Bligh wrote:
> We have noticed significant I/O scheduling issues on both the CFQ and the
> deadline scheduler where a non-root user can starve any other process of
> any I/O for minutes at a time. The problem is more serious using CFQ but is
> still an effective local DoS vector using Deadline.
> 
> A simple way to generate the problem is:
> 
>   dd if=/dev/zero of=- bs=1M count=50000 | dd if=- of=myfile bs=1M count=50000
> 
[...]
> 
> Full info, including logs and scripts can be found at:
>   https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1064521

You seem to have 8G of RAM and dirty_ratio=20 resp.
dirty_background_ratio=10 which means that 1.5G worth of dirty data
until writer gets throttled which is a lot. Background writeback starts
at 800M which is probably not sufficient as well. Have you tried to set
dirty_bytes at a reasonable value (wrt. to your storage)?
-- 
Michal Hocko
SUSE Labs
