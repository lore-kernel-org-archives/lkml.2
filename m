Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096Ab0ESUdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 16:33:12 -0400
Received: from vs81.sauer-cs.de ([80.244.252.81]:38063 "EHLO kbdbabel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733Ab0ESUdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 16:33:10 -0400
Date: Thu, 20 May 2010 00:32:42 +0400 (MSD)
From: Alexander Kurz <linux@blala.de>
X-X-Sender: linux@blala.de
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Greg KH <gregkh@suse.de>, linux-next@vger.kernel.org,
       fmhess@users.sourceforge.net, Greg KH <greg@kroah.com>,
       Alexander Kurz <linux@blala.de>, Ian Abbott <abbotti@mev.co.uk>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] staging/comedi: fixing ni_tio to mite PCI dependancy
In-Reply-To: <20100519103203.155c9527.randy.dunlap@oracle.com>
Message-ID: <alpine.DEB.1.10.1005200028420.20214@blala.de>
References: <alpine.DEB.1.10.1005081218220.5727@blala.de> <20100514190142.GA2505@kroah.com> <201005142029.37408.fmhess@speakeasy.net> <20100515034423.GA3811@suse.de> <20100519103203.155c9527.randy.dunlap@oracle.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 May 2010, Randy Dunlap wrote:
> linux-next of 2010-0519:
> when CONFIG_PCI is not enabled:
> 
> drivers/staging/comedi/drivers/mite.c: In function 'mite_init':
> drivers/staging/comedi/drivers/mite.c:89: error: implicit declaration of function 'pci_dev_get'
> drivers/staging/comedi/drivers/mite.c:89: warning: assignment makes pointer from integer without a cast
> make[5]: *** [drivers/staging/comedi/drivers/mite.o] Error 1

thanks, this patch is a follow-up to
> [PATCH] staging/comedi: fixing 8255 and DAS08 Kconfig dependancies.

>From 9804b6bc8c997433411b24f477417f8e7cc9a19d Mon Sep 17 00:00:00 2001
From: Alexander Kurz <linux@kbdbabel.org>
Date: Wed, 19 May 2010 22:23:00 +0200
Subject: [PATCH 2/2] staging/comedi: fixing ni_tio to mite PCI dependancy

Signed-off-by: Alexander Kurz <linux@kbdbabel.org>
---
 drivers/staging/comedi/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/comedi/Kconfig b/drivers/staging/comedi/Kconfig
index ebc68ee..0aa2b0d 100644
--- a/drivers/staging/comedi/Kconfig
+++ b/drivers/staging/comedi/Kconfig
@@ -1258,8 +1258,8 @@ config COMEDI_MITE
 
 config COMEDI_NI_TIO
 	tristate "NI general purpose counter support"
+	depends on COMEDI_MITE
 	select COMEDI_8255
-	select COMEDI_MITE
 	default N
 	---help---
 	  Enable support for National Instruments general purpose counters.
-- 
1.7.1
