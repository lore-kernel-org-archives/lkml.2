Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403Ab0G2MjF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 08:39:05 -0400
Received: from tichy.grunau.be ([85.131.189.73]:47875 "EHLO tichy.grunau.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754186Ab0G2MjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 08:39:01 -0400
Date: Thu, 29 Jul 2010 14:39:41 +0200
From: Janne Grunau <j@jannau.net>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        lirc-list@lists.sourceforge.net, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: linux-next: Tree for July 28 (lirc #2)
Message-ID: <20100729123941.GL8564@aniel.lan>
References: <20100728162855.4968e561.sfr@canb.auug.org.au>
 <20100728102417.be60049a.randy.dunlap@oracle.com>
 <20100728220454.GK8564@aniel.lan>
 <4C50AC26.1080100@oracle.com>
 <AANLkTi=DLHOnzgXmpzNE3PQXp-xSkm8vLdxBBf1mcFuO@mail.gmail.com>
 <AANLkTimTbZ6Vjqe5rqNVtNwPV=qoo=BOsOwG_6fS1SZU@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimTbZ6Vjqe5rqNVtNwPV=qoo=BOsOwG_6fS1SZU@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 29, 2010 at 12:27:01AM -0400, Jarod Wilson wrote:
> On Wed, Jul 28, 2010 at 6:27 PM, Jarod Wilson <jarod@wilsonet.com> wrote:
> > On Wed, Jul 28, 2010 at 6:16 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> >> On 07/28/10 15:04, Janne Grunau wrote:
> >>> On Wed, Jul 28, 2010 at 10:24:17AM -0700, Randy Dunlap wrote:
> >>>> On Wed, 28 Jul 2010 16:28:55 +1000 Stephen Rothwell wrote:
> >>>>
> >>>>> Hi all,
> >>>>>
> >>>>> Changes since 20100727:
> >>>>
> >>>>
> >>>> When USB_SUPPORT is not enabled and MEDIA_SUPPORT is not enabled:
> >>>>
> >>>
> >>> following patch should fix it
> >>>
> >>> Janne
> >>
> >> Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
> >>
> >> Thanks.
> >
> > Acked-by: Jarod Wilson <jarod@redhat.com>
> >
> > Indeed, thanks much, Janne!
> 
> D'oh, I should have looked a bit closer... What if instead of making
> all the drivers depend on both LIRC && LIRC_STAGING, LIRC_STAGING just
> depends on LIRC?

I started adding LIRC to each driver by one. Adding LIRC as LIRC_STAGING
dependency is simpler. See updated patch.

> And there are a few depends lines with duplicate
> USB's in them and LIRC_IMON should have USB added to it (technically,

D'oh, I've must have stopped reading after LIRC_STAG...

fixed and added additional dependencies

Janne


>From 45d384de90e3709a986700db14888eff77bb7e1f Mon Sep 17 00:00:00 2001
From: Janne Grunau <j@jannau.net>
Date: Wed, 28 Jul 2010 23:53:35 +0200
Subject: [PATCH 1/2] V4L/DVB: staging/lirc: fix Kconfig dependencies

Signed-off-by: Janne Grunau <j@jannau.net>
---
 drivers/staging/lirc/Kconfig |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/lirc/Kconfig b/drivers/staging/lirc/Kconfig
index 968c2ade..ab30a09 100644
--- a/drivers/staging/lirc/Kconfig
+++ b/drivers/staging/lirc/Kconfig
@@ -3,6 +3,7 @@
 #
 menuconfig LIRC_STAGING
 	bool "Linux Infrared Remote Control IR receiver/transmitter drivers"
+	depends on LIRC
 	help
 	  Say Y here, and all supported Linux Infrared Remote Control IR and
 	  RF receiver and transmitter drivers will be displayed. When paired
@@ -13,13 +14,13 @@ if LIRC_STAGING
 
 config LIRC_BT829
         tristate "BT829 based hardware"
-	depends on LIRC_STAGING
+	depends on LIRC_STAGING && PCI
 	help
 	  Driver for the IR interface on BT829-based hardware
 
 config LIRC_ENE0100
 	tristate "ENE KB3924/ENE0100 CIR Port Reciever"
-	depends on LIRC_STAGING
+	depends on LIRC_STAGING && PNP
 	help
 	  This is a driver for CIR port handled by ENE KB3924 embedded
 	  controller found on some notebooks.
@@ -27,7 +28,7 @@ config LIRC_ENE0100
 
 config LIRC_I2C
 	tristate "I2C Based IR Receivers"
-	depends on LIRC_STAGING
+	depends on LIRC_STAGING && I2C
 	help
 	  Driver for I2C-based IR receivers, such as those commonly
 	  found onboard Hauppauge PVR-150/250/350 video capture cards
@@ -40,7 +41,7 @@ config LIRC_IGORPLUGUSB
 
 config LIRC_IMON
 	tristate "Legacy SoundGraph iMON Receiver and Display"
-	depends on LIRC_STAGING
+	depends on LIRC_STAGING && USB
 	help
 	  Driver for the original SoundGraph iMON IR Receiver and Display
 
@@ -48,7 +49,7 @@ config LIRC_IMON
 
 config LIRC_IT87
 	tristate "ITE IT87XX CIR Port Receiver"
-	depends on LIRC_STAGING
+	depends on LIRC_STAGING && PNP
 	help
 	  Driver for the ITE IT87xx IR Receiver
 
@@ -60,13 +61,13 @@ config LIRC_ITE8709
 
 config LIRC_PARALLEL
 	tristate "Homebrew Parallel Port Receiver"
-	depends on LIRC_STAGING && !SMP
+	depends on LIRC_STAGING && PARPORT && !SMP
 	help
 	  Driver for Homebrew Parallel Port Receivers
 
 config LIRC_SASEM
 	tristate "Sasem USB IR Remote"
-	depends on LIRC_STAGING
+	depends on LIRC_STAGING && USB
 	help
 	  Driver for the Sasem OnAir Remocon-V or Dign HV5 HTPC IR/VFD Module
 
@@ -91,7 +92,7 @@ config LIRC_SIR
 
 config LIRC_STREAMZAP
 	tristate "Streamzap PC Receiver"
-	depends on LIRC_STAGING
+	depends on LIRC_STAGING && USB
 	help
 	  Driver for the Streamzap PC Receiver
 
@@ -103,7 +104,7 @@ config LIRC_TTUSBIR
 
 config LIRC_ZILOG
 	tristate "Zilog/Hauppauge IR Transmitter"
-	depends on LIRC_STAGING
+	depends on LIRC_STAGING && I2C
 	help
 	  Driver for the Zilog/Hauppauge IR Transmitter, found on
 	  PVR-150/500, HVR-1200/1250/1700/1800, HD-PVR and other cards
-- 
1.7.2

