Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab2E3UfQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 16:35:16 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37803 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750Ab2E3UfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 16:35:13 -0400
Subject: Re: [GIT PULL] Block driver bits for 3.5
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Alan Cox <alan@linux.intel.com>
In-Reply-To: <1338404902.2760.451.camel@edumazet-glaptop>
References: <4FC6189B.9080909@fusionio.com>
	 <1338402812.2760.413.camel@edumazet-glaptop>
	 <4FC66D3D.6080509@fusionio.com>
	 <1338404902.2760.451.camel@edumazet-glaptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 May 2012 22:35:07 +0200
Message-ID: <1338410107.2760.544.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-30 at 21:08 +0200, Eric Dumazet wrote:
> On Wed, 2012-05-30 at 20:55 +0200, Jens Axboe wrote:
> > On 05/30/2012 08:33 PM, Eric Dumazet wrote:
> > > On Wed, 2012-05-30 at 14:54 +0200, Jens Axboe wrote:
> > >> Hi Linus,
> > >>
> > >> On top of the for-3.5/core pull request, here are the driver related
> > >> changes for 3.5. It contains:
> > > 
> > > Hi Jens
> > > 
> > > Not sure if this is related, but latest Linus tree cannot boot anymore
> > > here...
> > > 
> > > BUG: soft lockup - CPU#3 stuck for 22s ! [mountall.1603]
> > 
> > Hrmpf, can you attach your .config?
> > 
> 
> I can do a bisection pretty fast I think

Not sure if bisection was good, but result is :

# git bisect log 
git bisect start
# bad: [cce527e20116868dcd71cc98b8210a9697b93a97] Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6
git bisect bad cce527e20116868dcd71cc98b8210a9697b93a97
# good: [76e10d158efb6d4516018846f60c2ab5501900bc] Linux 3.4
git bisect good 76e10d158efb6d4516018846f60c2ab5501900bc
# good: [9b170dbd82448826ca3b8b6ee47daf36c4f438f3] Documentation/kernel-parameters: remove autotest and mcatest
git bisect good 9b170dbd82448826ca3b8b6ee47daf36c4f438f3
# good: [f2fde3a65e88330017b816faf2ef75f141d21375] Merge branch 'drm-core-next' of git://people.freedesktop.org/~airlied/linux
git bisect good f2fde3a65e88330017b816faf2ef75f141d21375
# bad: [4b781474682434e7881f20e9dfbe6687ea619795] Merge tag 'mfd-3.5-1' of git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6
git bisect bad 4b781474682434e7881f20e9dfbe6687ea619795
# good: [2c757fd5d1a92086f225a75a8fac7cab242d11b0] Merge tag 'cleanup2' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc
git bisect good 2c757fd5d1a92086f225a75a8fac7cab242d11b0
# good: [1629372caaaf7ef744d3b983be56b99468a68ff8] powerpc: Use the new generic strncpy_from_user() and strnlen_user()
git bisect good 1629372caaaf7ef744d3b983be56b99468a68ff8
# good: [cc0a98436820b161b595b8cc1d2329bcf7328107] NFSv4: Add debugging printks to state manager
git bisect good cc0a98436820b161b595b8cc1d2329bcf7328107
# good: [cd99758ba3bde64347a8ece381cbae2fb5c745b2] mfd: Convert wm831x to irq_domain
git bisect good cd99758ba3bde64347a8ece381cbae2fb5c745b2
# good: [d766023eea566bb3c2a57a0567af5b271908fdc2] Merge branch 'doc' of git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial
git bisect good d766023eea566bb3c2a57a0567af5b271908fdc2
# good: [3770c75a6852a87afc66cd514c13899f8a288cef] mfd: Enable Device Tree support in the ab8500-pwm driver
git bisect good 3770c75a6852a87afc66cd514c13899f8a288cef
# good: [21f082a66177852365df0c955ecaef50fba9a691] mfd: ab8500-core should depend on MFD_DB8500_PRCMU
git bisect good 21f082a66177852365df0c955ecaef50fba9a691
# bad: [8f6576ad476b2a22d05ddafd2ddaee102577a4ed] tty: fix ldisc lock inversion trace
git bisect bad 8f6576ad476b2a22d05ddafd2ddaee102577a4ed
# good: [8b56a30caaf9bc1850784f196636c5f550cc7577] exofs:  Add SYSFS info for autologin/pNFS export
git bisect good 8b56a30caaf9bc1850784f196636c5f550cc7577
# bad: [d3ca8b64b97ef4dc54d7bb0b88bbc01a1fca8cb9] pty: Fix lock inversion
git bisect bad d3ca8b64b97ef4dc54d7bb0b88bbc01a1fca8cb9
# good: [a01ee165a132fadb57659d26246e340d6ac53265] Merge branch 'for-linus' of git://git.open-osd.org/linux-open-osd
git bisect good a01ee165a132fadb57659d26246e340d6ac53265

# git bisect visualize
commit d3ca8b64b97ef4dc54d7bb0b88bbc01a1fca8cb9
Author: Alan Cox <alan@linux.intel.com>
Date:   Tue May 29 13:45:01 2012 +0100

    pty: Fix lock inversion
    
    The ptmx_open path takes the tty and devpts locks in the wrong order
    because tty_init_dev locks and returns a locked tty.  As far as I can
    tell this is actually safe anyway because the tty being returned is new
    so nobody can get a reference to lock it at this point.
    
    However we don't even need the devpts lock at this point, it's only held
    as a byproduct of the way the locks were pushe down.
    
    Signed-off-by: Alan Cox <alan@linux.intel.com>
    Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
 


