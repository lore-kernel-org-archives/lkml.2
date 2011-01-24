Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412Ab1AXLnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 06:43:19 -0500
Received: from fanny.its.uu.se ([130.238.4.241]:49185 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698Ab1AXLnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 06:43:17 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19773.26066.137666.718852@pilspetsen.it.uu.se>
Date: Mon, 24 Jan 2011 12:43:14 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Harald Dunkel <harri@afaics.de>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kenrel.org
Subject: Re: [Patch] make installkernel configurable from command line (was Re:
 how to avoid that install.sh goes mad, if I am not root?)
In-Reply-To: <20110124102159.GD5510@cr0.nay.redhat.com>
References: <4D388A08.1010004@afaics.de>
	<19768.44428.482148.361069@pilspetsen.it.uu.se>
	<ihbvd1$jbj$3@dough.gmane.org>
	<4D3A03CA.2060507@afaics.de>
	<20110124102159.GD5510@cr0.nay.redhat.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

=?utf-8?Q?Am=C3=A9rico?= Wang writes:
 > On Fri, Jan 21, 2011 at 11:08:10PM +0100, Harald Dunkel wrote:
 > >-----BEGIN PGP SIGNED MESSAGE-----
 > >Hash: SHA1
 > >
 > >On 01/21/11 13:49, WANG Cong wrote:
 > >> On Thu, 20 Jan 2011 22:47:56 +0100, Mikael Pettersson wrote:
 > >>>
 > >>> First, at least on x86, the kernel will look for the 'installkernel'
 > >>> executable first in your own ~/bin/, so if you have that then it will
 > >>> override /sbin/installkernel.
 > >>>
 > >> 
 > >> That still doesn't look like a good solution.
 > >> 
 > >
 > >Same for me.
 > >
 > >Obviously running /sbin/installkernel is not reasonable for
 > >UID != 0 (or if $FAKEROOTKEY is set), so I would suggest to
 > >skip /sbin/installkernel and the default Lilo setup in
 > >install.sh for this case.
 > >
 > 
 > Will the patch below work for you?
 > 
 > With this patch, you should be able to specify your own installkernel
 > by "make INSTALLKERNEL=/your/installkernel install".
 > 
 > Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
 > 
 > ---
 > diff --git a/Makefile b/Makefile
 > index 1f47495..44abded 100644
 > --- a/Makefile
 > +++ b/Makefile
 > @@ -327,7 +327,7 @@ OBJCOPY		= $(CROSS_COMPILE)objcopy
 >  OBJDUMP		= $(CROSS_COMPILE)objdump
 >  AWK		= awk
 >  GENKSYMS	= scripts/genksyms/genksyms
 > -INSTALLKERNEL  := installkernel
 > +INSTALLKERNEL  ?= /sbin/installkernel
 >  DEPMOD		= /sbin/depmod
 >  KALLSYMS	= scripts/kallsyms
 >  PERL		= perl
 > diff --git a/arch/x86/boot/install.sh b/arch/x86/boot/install.sh
 > index d13ec1c..c41f2b8 100644
 > --- a/arch/x86/boot/install.sh
 > +++ b/arch/x86/boot/install.sh
 > @@ -33,8 +33,7 @@ verify "$3"
 >  
 >  # User may have a custom install script
 >  
 > -if [ -x ~/bin/${INSTALLKERNEL} ]; then exec ~/bin/${INSTALLKERNEL} "$@"; fi
 > -if [ -x /sbin/${INSTALLKERNEL} ]; then exec /sbin/${INSTALLKERNEL} "$@"; fi
 > +if [ -x "${INSTALLKERNEL}" ]; then exec "${INSTALLKERNEL}" "$@"; fi

NAK -- this breaks existing setups which rely on /root/bin/installkernel
being picked up automatically.

Can you handle 'make INSTALLKERNEL=...' without breaking that please?
