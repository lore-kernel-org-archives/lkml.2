Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab0DXUEG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 16:04:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58142 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752795Ab0DXUEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 16:04:04 -0400
Date: Sat, 24 Apr 2010 13:01:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Arnd Bergmann <arnd@arndb.de>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@zeniv.linux.org.uk>,
       Jan Blunck <jblunck@suse.de>, Ingo Molnar <mingo@elte.hu>,
       John Kacur <jkacur@redhat.com>
Subject: Re: [GIT PULL v2] Preparation for BKL'ed ioctl removal
In-Reply-To: <201004242154.02421.arnd@arndb.de>
Message-ID: <alpine.LFD.2.00.1004241258140.3739@i5.linux-foundation.org>
References: <1271390201-20431-1-git-send-regression-fweisbec@gmail.com> <alpine.LFD.2.00.1004241135460.3739@i5.linux-foundation.org> <alpine.LFD.2.00.1004241146520.3739@i5.linux-foundation.org> <201004242154.02421.arnd@arndb.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 24 Apr 2010, Arnd Bergmann wrote:
> 
> The CONFIG_BKL stuff is not a requirement for doing this, but something
> we /also/ want to do in the next merge window, i.e. mark all BKL users
> as CONFIG_BKL, not just the ones that use the locked_ioctl (or bkl_ioctl).

.. and I think that's simply fundamentally wrong. What does it buy us, 
except for another really annoying config option? It sure as hell doesn't 
buy us any code-size (what, a couple of bytes).

Quite frankly, if you want to just prepare to rename things one by one, 
then you might as well just have a single line

	#define bkl_ioctl ioctl

and then you can do

	.bkl_ioctl = driver_ioctl

but the thing is - what does that _buy_ us without the ability to grep for 
and cause compile errors for drivers that haven't done this? Nothing.

So seriously - I'd _much_ rather just get one single large patch that just 
renames everything. None of this crap that makes no sense.

			Linus
