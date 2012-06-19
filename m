Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab2FSXVn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 19:21:43 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:49103 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909Ab2FSXUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 19:20:47 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-160.messagelabs.com!1340148028!7218327!10
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 5/5] staging: comedi: Kconfig: remove redundant depends on tests
Date: Tue, 19 Jun 2012 16:20:31 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206191620.31551.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'depends on COMEDI_ISA_DRIVERS' for COMEDI_AMPLC_DIO200_ISA is
not needed. This option is alread in an if/endif block that will
satisy the check.

The 'depends on COMEDI' for COMEDI_NI_COMMON was missed when all
the comedi options were wrapped in an if/endif block.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/Kconfig | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/comedi/Kconfig b/drivers/staging/comedi/Kconfig
index 974c668..0415520 100644
--- a/drivers/staging/comedi/Kconfig
+++ b/drivers/staging/comedi/Kconfig
@@ -213,7 +213,6 @@ config COMEDI_PCM3730
 config COMEDI_AMPLC_DIO200_ISA
 	tristate "Amplicon PC212E/PC214E/PC215E/PC218E/PC272E"
 	select COMEDI_AMPLC_DIO200
-	depends on COMEDI_ISA_DRIVERS
 	---help---
 	  Enable support for Amplicon PC212E, PC214E, PC215E, PC218E and
 	  PC272E ISA DIO boards
@@ -1236,7 +1235,6 @@ endif # COMEDI_USB_DRIVERS
 
 menuconfig COMEDI_NI_COMMON
 	tristate "Comedi National Instruments card support"
-	depends on COMEDI
 	---help---
 	  Enable comedi support for National Instruments cards.
 	  Modules in this section are used by many comedi NI drivers.
-- 
1.7.11

