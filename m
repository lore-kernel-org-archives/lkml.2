Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab1F3WG3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 18:06:29 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:40580 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753204Ab1F3WES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 18:04:18 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: "Greg Kroah-Hartman" <greg@kroah.com>
Cc: Marek Belisko <marek.belisko@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH 04/28] staging: ft1000-pcmcia: get rid of ft1000_dev.h
Date: Fri,  1 Jul 2011 00:03:33 +0200
Message-Id: <1309471437-12633-5-git-send-email-linux@rainbow-software.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1309471437-12633-1-git-send-email-linux@rainbow-software.org>
References: <1309471437-12633-1-git-send-email-linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shorten ft1000_read_reg() to single line and move it to ft1000.h along with
ft1000_write_reg() and delete ft1000_dev.h

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/staging/ft1000/ft1000-pcmcia/ft1000.h      |   10 +++
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_dev.h  |   66 --------------------
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c |    1 -
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c   |    1 -
 4 files changed, 10 insertions(+), 68 deletions(-)
 delete mode 100644 drivers/staging/ft1000/ft1000-pcmcia/ft1000_dev.h

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h b/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h
index 61e1cfc..fab92ad 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h
@@ -406,4 +406,14 @@ extern u16 ft1000_read_dpram_mag_16 (struct net_device *dev, int offset, int Ind
 extern u32 ft1000_read_dpram_mag_32 (struct net_device *dev, int offset);
 void ft1000_write_dpram_mag_32 (struct net_device *dev, int offset, u32 value);
 
+/* Read the value of a given ASIC register. */
+static inline u16 ft1000_read_reg (struct net_device *dev, u16 offset) {
+    return inw(dev->base_addr + offset);
+}
+
+/* Set the value of a given ASIC register. */
+static inline void ft1000_write_reg (struct net_device *dev, u16 offset, u16 value) {
+    outw(value, dev->base_addr + offset);
+}
+
 #endif // _FT1000H_
diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dev.h b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dev.h
deleted file mode 100644
index 0b63f05..0000000
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dev.h
+++ /dev/null
@@ -1,66 +0,0 @@
-//---------------------------------------------------------------------------
-// FT1000 driver for Flarion Flash OFDM NIC Device
-//
-// Copyright (C) 2002 Flarion Technologies, All rights reserved.
-//
-// This program is free software; you can redistribute it and/or modify it
-// under the terms of the GNU General Public License as published by the Free
-// Software Foundation; either version 2 of the License, or (at your option) any
-// later version. This program is distributed in the hope that it will be useful,
-// but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
-// or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
-// more details. You should have received a copy of the GNU General Public
-// License along with this program; if not, write to the
-// Free Software Foundation, Inc., 59 Temple Place -
-// Suite 330, Boston, MA 02111-1307, USA.
-//---------------------------------------------------------------------------
-//
-// File:         ft1000_dev.h
-//
-// Description:    Register definitions and bit masks for the FT1000 NIC
-//
-// History:
-// 2/5/02     Ivan Bohannon      Written.
-// 8/29/02    Whc                Ported to Linux.
-//
-//---------------------------------------------------------------------------
-#ifndef _FT1000_DEVH_
-#define _FT1000_DEVH_
-
-//---------------------------------------------------------------------------
-//
-// Function:   ft1000_read_reg
-// Description: This function will read the value of a given ASIC register.
-// Input:
-//     dev    - device structure
-//     offset - ASIC register offset
-// Output:
-//     data   - ASIC register value
-//
-//---------------------------------------------------------------------------
-static inline u16 ft1000_read_reg (struct net_device *dev, u16 offset) {
-    u16 data = 0;
-
-    data = inw(dev->base_addr + offset);
-
-    return (data);
-}
-
-//---------------------------------------------------------------------------
-//
-// Function:   ft1000_write_reg
-// Description: This function will set the value for a given ASIC register.
-// Input:
-//     dev    - device structure
-//     offset - ASIC register offset
-//     value  - value to write
-// Output:
-//     None.
-//
-//---------------------------------------------------------------------------
-static inline void ft1000_write_reg (struct net_device *dev, u16 offset, u16 value) {
-    outw (value, dev->base_addr + offset);
-}
-
-#endif // _FT1000_DEVH_
-
diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
index fb375ea..c49180a 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
@@ -34,7 +34,6 @@
 #include <asm/uaccess.h>
 #include <linux/vmalloc.h>
 
-#include "ft1000_dev.h"
 #include "ft1000.h"
 #include "boot.h"
 
diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
index 830822f..d60ec7c 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
@@ -54,7 +54,6 @@
 #endif
 
 #include <linux/delay.h>
-#include "ft1000_dev.h"
 #include "ft1000.h"
 
 int card_download(struct net_device *dev, const u8 *pFileStart, UINT FileLength);
-- 
Ondrej Zary

