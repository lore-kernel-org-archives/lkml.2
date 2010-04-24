Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141Ab0DXWRp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 18:17:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39747 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751306Ab0DXWRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 18:17:44 -0400
Date: Sat, 24 Apr 2010 15:15:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Arnd Bergmann <arnd@arndb.de>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@zeniv.linux.org.uk>,
       Jan Blunck <jblunck@suse.de>, Ingo Molnar <mingo@elte.hu>,
       John Kacur <jkacur@redhat.com>
Subject: Re: [GIT PULL v2] Preparation for BKL'ed ioctl removal
In-Reply-To: <201004242240.51176.arnd@arndb.de>
Message-ID: <alpine.LFD.2.00.1004241510530.3739@i5.linux-foundation.org>
References: <1271390201-20431-1-git-send-regression-fweisbec@gmail.com> <201004242154.02421.arnd@arndb.de> <alpine.LFD.2.00.1004241258140.3739@i5.linux-foundation.org> <201004242240.51176.arnd@arndb.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 24 Apr 2010, Arnd Bergmann wrote:
> 
> With CONFIG_BKL disabled, we gain a few cyles in the scheduler,

That has _nothing_ to do with the ioctl's though.

Stop mixing things up.

There are two totally independent issues:

 - making the BKL ioctl's be explicit and findable

 - eventually getting rid of the BKL entirely

and I think you guys are totally mixing things up, and making things WORSE 
in the process.

The notion of having _three_ different "ioctl()" function pointers just 
makes me want to gag. And there is absolutely _zero_ reason for it. Tjhere 
is no way in hell that we want to have every subsystem maintainer try to 
independently do their own ioctl's. Most of the drivers that have those 
things are basically unmaintained or on the back burner anyway.

So don't make the current ugly ioctl situation worse. Not even as a 
stop-gap, because there is absolutely _zero_ upside to making yet another 
new crazy temporary ioctl interface.

And don't try to conflate the issue of ioctl and BKL. There are still 
code-paths that do lock_kernel() without the ioctl's, so the whole ioctl 
renaming has _zero_ to do with CONFIG_BKL.

		Linus
