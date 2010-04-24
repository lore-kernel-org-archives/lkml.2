Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab0DXStd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 14:49:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42007 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751179Ab0DXStc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 14:49:32 -0400
Date: Sat, 24 Apr 2010 11:47:17 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@ZenIV.linux.org.uk>,
       Jan Blunck <jblunck@suse.de>, Ingo Molnar <mingo@elte.hu>,
       John Kacur <jkacur@redhat.com>
Subject: Re: [GIT PULL v2] Preparation for BKL'ed ioctl removal
In-Reply-To: <alpine.LFD.2.00.1004241135460.3739@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1004241146520.3739@i5.linux-foundation.org>
References: <1271390201-20431-1-git-send-regression-fweisbec@gmail.com> <1271897282-11207-1-git-send-regression-fweisbec@gmail.com> <20100424152542.GD5545@nowhere> <alpine.LFD.2.00.1004241135460.3739@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 24 Apr 2010, Linus Torvalds wrote:
>
> I don't see the point, frankly. Especially not outside the merge window, 
> but quite frankly, I don't see it in general. The whole thing seems to be 
> designed to be inconvenient, and to have a config option that I 
> fundamentally don't believe in (CONFIG_BKL).

More detail: it still leaves that old "ioctl" function pointer that needs 
the BKL and is ungreppable. So the whole and only point of the patch is to 
make our current mess even _more_ complex, with three different cases. No, 
thank you.

Quite frankly, if you want to get rid of the BKL in ioctl's and make them 
easily greppable, then I would suggest a simple renaming: rename the 
current '->ioctl()' thing to '->bkl_ioctl()', and mark it deprecated. No 
new config options, no new games. Just rename it. No need to mark things 
with CONFIG_BKL, when you can just see it by virtue of them using 
'bkl_ioctl'.

			Linus
