Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386Ab2BAVRk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:17:40 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:38254 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757371Ab2BAVRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:17:36 -0500
X-Sasl-enc: q5oPL18eXoPWu9A1GbtDdAFlmdY3ykaMOsXtzq+y/8sT 1328131056
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:49 2012
Message-Id: <20120201210049.359303084@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 13:00:26 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sekhar Nori <nsekhar@ti.com>,
        Felipe Balbi <balbi@ti.com>
Subject: [62/89] usb: musb: davinci: fix build breakage
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sekhar Nori <nsekhar@ti.com>

commit 006896fc612f11bf0624db7814a75d0d5410855f upstream.

Commit 0020afb369859472a461ef4af6410732e929d402 (ARM: mach-davinci:
remove mach/memory.h) removed mach/memory.h for DaVinci which broke
DaVinci MUSB build.

mach/memory.h is not actually needed in davinci.c, so remove it.
While at it, also remove some more machine specific inclulde
files which are not needed for build.

Tested on DM644x EVM using USB card reader.

Signed-off-by: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/musb/davinci.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/usb/musb/davinci.c
+++ b/drivers/usb/musb/davinci.c
@@ -33,9 +33,6 @@
 #include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
 
-#include <mach/hardware.h>
-#include <mach/memory.h>
-#include <asm/gpio.h>
 #include <mach/cputype.h>
 
 #include <asm/mach-types.h>


