Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109Ab1DZHXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 03:23:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45769 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757755Ab1DZHXS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 03:23:18 -0400
Subject: Re: [PATCH 0/4] munmap: Flexible mem unmap operation interface for
 scheduling latency
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Geunsik Lim <leemgs1@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Hugh Dickins <hughd@google.com>, Steven Rostedt <rostedt@goodmis.org>,
        Darren Hart <dvhart@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
In-Reply-To: <BANLkTimoG7muVanF6P8YYvfZA7WUT+9XKg@mail.gmail.com>
References: <1303728272-11408-1-git-send-email-leemgs1@gmail.com>
	 <1303760837.4865.22.camel@laptop>
	 <BANLkTimoG7muVanF6P8YYvfZA7WUT+9XKg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 26 Apr 2011 09:22:52 +0200
Message-ID: <1303802572.20212.4.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-26 at 10:20 +0900, Geunsik Lim wrote:
> Yes. I also checked the patch that you stated at LKML mailing list previously.
> In my thinking. I want to keep ZAP_BLOCK_SIZE related contents
> that adjusted by Ingo, Robert, Andrew, and so on a long time ago
> because I believe that we can overcome below problems sufficiently
> in real world.
> . LKML archive - http://lkml.org/lkml/2002/7/24/273
> . LKML archive - http://lkml.org/lkml/2004/9/14/101

Real ancient world, that was 2004, well before we grew preemptible
mmu_gather.

> In my experience, I did overcome below problems with this patch
> based on ZAP_BLOCK_SIZE.
> 
> 1) To solve temporal CPU contention
>     (e.g: case that cpu contention is 93% ~ 96% according to mmap/munmap
>             to access mass files )
> 2) To get real-time or real-fast selectively on specified linux system 

I still don't get it, what kernel are you targeting here and why?

-RT doesn't care, and clearly PREEMPT=n doesn't care because its not
about latency at all, the only half-way point is PREEMPT=y and for that
you could simply reduce ZAP_BLOCK_SIZE.

Then again, what's the point, simply remove the whole thing (like I did)
and your problem is solved too.


