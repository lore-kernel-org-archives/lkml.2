Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828Ab1IUWWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 18:22:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:50015 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab1IUWWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 18:22:16 -0400
X-Authority-Analysis: v=1.1 cv=XWD5/VRj2HUJOhsR8cgmvPBlhMACpZXxseY1Kn/ehQI= c=1 sm=0 a=TRgVYD6ZyiEA:10 a=81BIEIcRgRoA:10 a=Zx2FLkwYMp0A:10 a=kj9zAlcOel0A:10 a=mpMdnlmFKti1S5SNY1DT+A==:17 a=yQdBAQUQAAAA:8 a=qIwKMGjsR0Ztu3TDoT4A:9 a=CjuIK1q_8ugA:10 a=IcxpeKGZWnEA:10 a=mpMdnlmFKti1S5SNY1DT+A==:117
X-Cloudmark-Score: 0
X-Originating-IP: 65.28.92.85
Date: Wed, 21 Sep 2011 17:22:11 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: paul.gortmaker@windriver.com
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, sfr@canb.auug.org.au,
        akpm@linux-foundation.org
Subject: [PATCH -next] rtlwifi: rtl8192c: Add includes of export.h
Message-ID: <4e7a6393.eQ0IEnMVbVlQIbx0%Larry.Finger@lwfinger.net>
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the split of include/linux/module.h into two parts, several files in
drivers rtlwifi and rtl8192c need to include the new file.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Paul,

At Randy Dunlap's suggestion, I am sending this to you in hopes that
I can save you some time. I think I found all the routines that will have
a problem, but as these patches do not compile, I cannot be sure.

Larry
---

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/base.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/base.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/base.c
@@ -30,6 +30,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/ip.h>
+#include <linux/export.h>
 #include "wifi.h"
 #include "rc.h"
 #include "base.h"
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/cam.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/cam.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/cam.c
@@ -29,6 +29,8 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/export.h>
+
 #include "wifi.h"
 #include "cam.h"
 
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/efuse.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/efuse.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/efuse.c
@@ -27,6 +27,8 @@
  *
  *****************************************************************************/
 
+#include <linux/export.h>
+
 #include "wifi.h"
 #include "efuse.h"
 
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/pci.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/pci.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/pci.c
@@ -27,6 +27,8 @@
  *
  *****************************************************************************/
 
+#include <linux/export.h>
+
 #include "core.h"
 #include "wifi.h"
 #include "pci.h"
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/ps.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/ps.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/ps.c
@@ -27,6 +27,8 @@
  *
  *****************************************************************************/
 
+#include <linux/export.h>
+
 #include "wifi.h"
 #include "base.h"
 #include "ps.h"
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
@@ -27,6 +27,8 @@
  *
  *****************************************************************************/
 
+#include <linux/export.h>
+
 #include "dm_common.h"
 #include "phy_common.h"
 #include "../pci.h"
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
@@ -30,6 +30,8 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/firmware.h>
+#include <linux/export.h>
+
 #include "../wifi.h"
 #include "../pci.h"
 #include "../base.h"
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
@@ -27,6 +27,8 @@
  *
  *****************************************************************************/
 
+#include <linux/export.h>
+
 #include "../wifi.h"
 #include "../rtl8192ce/reg.h"
 #include "../rtl8192ce/def.h"
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/usb.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/usb.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/usb.c
@@ -28,6 +28,8 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/usb.h>
+#include <linux/export.h>
+
 #include "core.h"
 #include "wifi.h"
 #include "usb.h"
