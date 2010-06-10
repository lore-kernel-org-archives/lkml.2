Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab0FJEyO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 00:54:14 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50185 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab0FJEyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 00:54:13 -0400
Subject: [PATCH] of/device: Move struct of_device define outside of
	CONFIG_OF_DEVICE test
From: Grant Likely <grant.likely@secretlab.ca>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, sfr@canb.auug.org.au,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 09 Jun 2010 22:54:10 -0600
Message-ID: <20100610045159.615.89343.stgit@angua>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some code uses of_device even when CONFIG_OF_DEVICE is not set.  This
patch makes of_device valid all the time by moving it outside of the
ifdef CONFIG_OF_DEVICE test.

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

Hi Randy,

Here's what I applied to my tree to fix the niu driver compile warning.
I've compile tested it on several architectures, and am pushing it out
to my linux-next branch now.

g.

 include/linux/of_device.h |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/include/linux/of_device.h b/include/linux/of_device.h
index c877d54..8cd1fe7 100644
--- a/include/linux/of_device.h
+++ b/include/linux/of_device.h
@@ -1,13 +1,6 @@
 #ifndef _LINUX_OF_DEVICE_H
 #define _LINUX_OF_DEVICE_H
 
-#ifdef CONFIG_OF_DEVICE
-#include <linux/device.h>
-#include <linux/platform_device.h>
-#include <linux/of.h>
-#include <linux/mod_devicetable.h>
-
-
 /*
  * The of_device *was* a kind of "base class" that was a superset of
  * struct device for use by devices attached to an OF node and probed
@@ -22,7 +15,12 @@
  * from the kernel.
  */
 #define of_device platform_device
+#include <linux/platform_device.h>
 
+#ifdef CONFIG_OF_DEVICE
+#include <linux/device.h>
+#include <linux/of.h>
+#include <linux/mod_devicetable.h>
 #include <asm/of_device.h>
 
 #define	to_of_device(d) container_of(d, struct of_device, dev)

