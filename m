Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab1BFN4O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 08:56:14 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47794 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452Ab1BFN4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 08:56:12 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Marc Koschewski <marc@osknowledge.org>
Subject: Re: Commit 500f7147cf5bafd139056d521536b10c2bc2e154 breaks _resume_
Date: Sun, 6 Feb 2011 14:55:37 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc3+; KDE/4.4.4; x86_64; ; )
Cc: Dave Airlie <airlied@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        Jeff Chua <jeff.chua.linux@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Wilson <chris@chris-wilson.co.uk>, Len Brown <lenb@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <AANLkTi=h+H+N=f4m4pE+RZ4n5h7oxQuwzmK-qmmWAGtL@mail.gmail.com> <201102061404.24146.rjw@sisk.pl> <20110206134410.GF22960@marc.osknowledge.org>
In-Reply-To: <20110206134410.GF22960@marc.osknowledge.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102061455.38186.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, February 06, 2011, Marc Koschewski wrote:
> * Rafael J. Wysocki <rjw@sisk.pl> [2011-02-06 14:04:23 +0100]:
> 
> > On Sunday, February 06, 2011, Marc Koschewski wrote:
> > > I've the NX stuff disabled, so to say DEBUG_RODATA=n and it doesn't resume... so
> > > what's next?
> > 
> > Did you actually try to revert the NX commits or go back to the version of the
> > kernel where they aren't present?
> > 
> > Also, what's the last known working kernel?
> 
> 2.6.37 works perfectly. After the first chunk of code after the release of
> 2.6.37 (so to say 2.6.37 + some stuff, but not 2.6.38-rc1) is broke.
> 
> I did not bisect it down to something. But it seems many people have trapped
> into it and have pointed at some things that probably broke it - see the
> SandyBridge thread.

I saw it, but it's not conclusive.  You're the last person reporting a suspend
problem which doesn't seem to be related to the NX patches and no one else
seems to be able to reproduce it (obviously including me).

If you suspend what might broke it, why don't you just try to confirm your
suspicions?

> > > I use an i7 with 32bit code as I think 64bit is a) useless for me
> > 
> > You're most probably wrong, because memory management is mush simpler in the
> > 64-bit mode.  Basically, if your machine supports 64-bitness, you should use
> > it.
> 
> I didn't see any advantage in 64 bit from what I've read.

Well, with all due respect to what you have read ...

> And I ignore the ~1% overhead of PAE. The hardware is fat enough...

... what about the kernel memory being confined to the first 1/4 of virtual
address space?  The fact that we have to use highmem on 32 bits is a good
enough reason to switch to 64 bits IMnsHO.

Thanks,
Rafael
