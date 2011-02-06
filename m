Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643Ab1BFNoP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 08:44:15 -0500
Received: from webbox4.loswebos.de ([213.187.93.205]:40368 "EHLO
	webbox4.loswebos.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452Ab1BFNoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 08:44:14 -0500
Date: Sun, 6 Feb 2011 14:44:11 +0100
From: Marc Koschewski <marc@osknowledge.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Dave Airlie <airlied@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        Jeff Chua <jeff.chua.linux@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Wilson <chris@chris-wilson.co.uk>, Len Brown <lenb@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Commit 500f7147cf5bafd139056d521536b10c2bc2e154 breaks _resume_
Message-ID: <20110206134410.GF22960@marc.osknowledge.org>
References: <AANLkTi=h+H+N=f4m4pE+RZ4n5h7oxQuwzmK-qmmWAGtL@mail.gmail.com>
 <AANLkTimURab9M5-LQxU0wjo=gEVBjHyv6osudadq4nNO@mail.gmail.com>
 <20110206122101.GC22960@marc.osknowledge.org>
 <201102061404.24146.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102061404.24146.rjw@sisk.pl>
X-PGP-Fingerprint: D514 7DC1 B5F5 8989 083E 38C9 5ECF E5BD 3430 ABF5
X-PGP-Key: http://www.kosik.org/pubkey.asc
X-Blog: http://www.kosik.org/blog/
X-Operating-System: Linux marc 2.6.37-ck1-dezzy
User-Agent: Mutt/1.5.21hg (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rafael J. Wysocki <rjw@sisk.pl> [2011-02-06 14:04:23 +0100]:

> On Sunday, February 06, 2011, Marc Koschewski wrote:
> > I've the NX stuff disabled, so to say DEBUG_RODATA=n and it doesn't resume... so
> > what's next?
> 
> Did you actually try to revert the NX commits or go back to the version of the
> kernel where they aren't present?
> 
> Also, what's the last known working kernel?

2.6.37 works perfectly. After the first chunk of code after the release of
2.6.37 (so to say 2.6.37 + some stuff, but not 2.6.38-rc1) is broke.

I did not bisect it down to something. But it seems many people have trapped
into it and have pointed at some things that probably broke it - see the
SandyBridge thread.

> 
> > I use an i7 with 32bit code as I think 64bit is a) useless for me
> 
> You're most probably wrong, because memory management is mush simpler in the
> 64-bit mode.  Basically, if your machine supports 64-bitness, you should use
> it.

I didn't see any advantage in 64 bit from what I've read. And I ignore the ~1% overhead
of PAE. The hardware is fat enough...

> 
> > and b) I just plugged my old HDD into my new machine.
> 
> Well, that's a good reason to stay backwards-compatible.
> 
> Thanks,
> Rafael
> 
> 
> > > >> I reverted the specified commit and my box still suffers the
> > > >> resume-turns-into-cold-boot behavior. Retried two times with the commit reverted
> > > >> on top of HEAD...
> > > >
> > > > The cold-boot problem is very likely irrelevant with i915 patches.
> > > > I've got the same issue with and without the i915 fix patches on test
> > > > machines here.
> > > >
> > > Yeah its the 32-bit NX stuff most likely if you are using 32-bit kernels.
> 
> 

-- 
Marc Koschewski
