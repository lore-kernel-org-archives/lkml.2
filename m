Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757759Ab0EEURK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 16:17:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47428 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755812Ab0EEURE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 16:17:04 -0400
Date: Wed, 5 May 2010 22:16:35 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
cc: lkml <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 3/6] fat: BKL ioctl pushdown
In-Reply-To: <87wrvitd5c.fsf@devron.myhome.or.jp>
Message-ID: <alpine.LFD.2.00.1005052139010.6285@localhost.localdomain>
References: <1273065339-21669-1-git-send-email-jkacur@redhat.com> <1273065339-21669-4-git-send-email-jkacur@redhat.com> <8739y6xrl6.fsf@devron.myhome.or.jp> <alpine.LFD.2.00.1005051927210.6285@localhost.localdomain> <87wrvitd5c.fsf@devron.myhome.or.jp>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 6 May 2010, OGAWA Hirofumi wrote:

> John Kacur <jkacur@redhat.com> writes:
> 
> > On Thu, 6 May 2010, OGAWA Hirofumi wrote:
> >
> >> John Kacur <jkacur@redhat.com> writes:
> >> 
> >> > Convert fat_generic_ioctl and fat_dir_ioctl to unlocked_ioctls
> >> > and push down the bkl into those functions.
> >> 
> >> I guess this is the part of batch ioctl conversion stuff though, those
> >> ioctl of FAT don't need BKL at all. Because all of those should already
> >> be protected by inode->i_mutex.
> >> 
> >> Removing BKL and then cleanup after this patch would be almost same with
> >> reverting this patch. So, could you just convert to unlocked_ioctl
> >> instead?
> >
> > That's probably not a good idea, without a little bit more analysis, 
> > otherwise it's quite easy to introduce subtle bugs.
> 
> What analysis? Who do it? I thought about removing BKL of FAT from
> several years ago. I was reviewing FAT multiple times, and I'm always
> testing FAT without BKL.

This patch just makes explicit the hidden BKLs that FAT is already using 
related to ioctl. We would like to get this step done in time for the next
merge window, because then we can remove that hidden source.

This step is preparation for removing the BKL from the individual 
functions we've pushed it down into. In other words, we'll do the analysis 
to remove it later if you don't want to.

Thanks.

> 
> If you are going to do, could you do it instead of this patch?
> 
