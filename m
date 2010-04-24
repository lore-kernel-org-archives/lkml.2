Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab0DXTyX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 15:54:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:54678 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab0DXTyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 15:54:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL v2] Preparation for BKL'ed ioctl removal
Date: Sat, 24 Apr 2010 21:54:02 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.31-19-generic; KDE/4.4.2; x86_64; ; )
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@zeniv.linux.org.uk>,
       Jan Blunck <jblunck@suse.de>, Ingo Molnar <mingo@elte.hu>,
       John Kacur <jkacur@redhat.com>
References: <1271390201-20431-1-git-send-regression-fweisbec@gmail.com> <alpine.LFD.2.00.1004241135460.3739@i5.linux-foundation.org> <alpine.LFD.2.00.1004241146520.3739@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1004241146520.3739@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004242154.02421.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18hPENqAsEPvnj+mWFXSH5jVElIdgmw7jJ9aih
 0j8iEqbuiQ3KbThVDorzyR0aaVLuPXDewltHaaTJ5QfUBSB6pz
 Wt+C7yB8s/1E1ee39k0JQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 24 April 2010 20:47:17 Linus Torvalds wrote:
> On Sat, 24 Apr 2010, Linus Torvalds wrote:
> >
> > I don't see the point, frankly. Especially not outside the merge window, 
> > but quite frankly, I don't see it in general. The whole thing seems to be 
> > designed to be inconvenient, and to have a config option that I 
> > fundamentally don't believe in (CONFIG_BKL).
> 
> More detail: it still leaves that old "ioctl" function pointer that needs 
> the BKL and is ungreppable. So the whole and only point of the patch is to 
> make our current mess even more complex, with three different cases. No, 
> thank you.
> 
> Quite frankly, if you want to get rid of the BKL in ioctl's and make them 
> easily greppable, then I would suggest a simple renaming: rename the 
> current '->ioctl()' thing to '->bkl_ioctl()', and mark it deprecated. No 
> new config options, no new games. Just rename it. No need to mark things 
> with CONFIG_BKL, when you can just see it by virtue of them using 
> 'bkl_ioctl'.

We want to do the rename in the next merge window and remove the old
->ioctl(), this patch is just a preparation for this so we can start
queuing the patches for the rename in maintainer trees.
The addition of the deprecated_ioctl() helper is not essential but
let's us move all BKL users into loadable modules next.

The CONFIG_BKL stuff is not a requirement for doing this, but something
we /also/ want to do in the next merge window, i.e. mark all BKL users
as CONFIG_BKL, not just the ones that use the locked_ioctl (or bkl_ioctl).

I agree that it's now a bit late for this, but when I initially suggested
this (before -rc3, IIRC), that would have given us the chance to queue up
all the patches with a dependency on this for the next merge window.
Now the current outlook is probably that we do a lot of the preparation
work like this patch in 2.6.35-rc1, which moves the merge of the interesting
parts out to the 2.6.36 timeframe.

	Arnd
