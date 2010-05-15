Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab0EOMOS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 08:14:18 -0400
Received: from vs81.sauer-cs.de ([80.244.252.81]:40433 "EHLO kbdbabel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752295Ab0EOMOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 08:14:17 -0400
Date: Sat, 15 May 2010 16:09:01 +0400 (MSD)
From: Alexander Kurz <linux@blala.de>
X-X-Sender: linux@blala.de
To: Greg KH <greg@kroah.com>
cc: Alexander Kurz <linux@blala.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Frank Mori Hess <fmhess@users.sourceforge.net>,
       Ian Abbott <abbotti@mev.co.uk>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging/comedi: Kconfig dependancy fixes
In-Reply-To: <20100514190142.GA2505@kroah.com>
Message-ID: <alpine.DEB.1.10.1005151604320.26254@blala.de>
References: <alpine.DEB.1.10.1005081218220.5727@blala.de> <20100514190142.GA2505@kroah.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are tree minor changes I would like to do on my last patch:
> Subject: [PATCH] staging/comedi: new Kconfig and Makefiles, drivers grouped by bustype.

* Comedi is formally not dependant on any hardware, e.g. it is possible
 to use comedi_test without (PCI || PCMCIA || PCCARD || USB || ISA)
* comedi_parport is not dependant on PARPORT_PC.
* indirect ni_mio_cs (16-bit PCMCIA) dependancy on mite PCI-chip may 
 confuse users, thus changing COMEDI_NI_TIO depends on COMEDI_MITE
 to select COMEDI_MITE.

thanks, Alexander

>From 14bdde13616e734fbd66c1d0cb826ab6456afa44 Mon Sep 17 00:00:00 2001
From: Alexander Kurz <linux@kbdbabel.org>
Date: Sat, 15 May 2010 13:49:52 +0200
Subject: [PATCH] staging/comedi: Kconfig dependancy fixes

Signed-off-by: Alexander Kurz <linux@kbdbabel.org>
---
 drivers/staging/comedi/Kconfig |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/Kconfig b/drivers/staging/comedi/Kconfig
index e9ce9c8..75e060f 100644
--- a/drivers/staging/comedi/Kconfig
+++ b/drivers/staging/comedi/Kconfig
@@ -1,7 +1,7 @@
 config COMEDI
 	tristate "Data acquisition support (comedi)"
 	default N
-	depends on m && (PCI || PCMCIA || PCCARD || USB)
+	depends on m
 	---help---
 	  Enable support a wide range of data acquisition devices
 	  for Linux.
@@ -57,7 +57,6 @@ config COMEDI_TEST
 
 config COMEDI_PARPORT
 	tristate "Parallel port support"
-	depends on PARPORT_PC
 	default N
 	---help---
 	  Enable support for the standard parallel port.
@@ -1257,7 +1256,7 @@ config COMEDI_MITE
 
 config COMEDI_NI_TIO
 	tristate "NI general purpose counter support"
-	depends on COMEDI_MITE
+	select COMEDI_MITE
 	default N
 	---help---
 	  Enable support for National Instruments general purpose counters.
-- 
1.7.1

> 
