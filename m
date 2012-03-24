Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab2CXUVf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 16:21:35 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51355 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772Ab2CXUVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 16:21:34 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 24 Mar 2012 21:21:25 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org
Subject: On patch "device.h: audit and cleanup users in main include dir"
Message-ID: <20120324212125.460c89d3@stein>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

commit 313162d0b83836e2f57e51b9b8650fb4b9c396ea is not 100.00% correct.

--- a/include/linux/firewire.h
+++ b/include/linux/firewire.h
@@ -2,7 +2,6 @@
 #define _LINUX_FIREWIRE_H
 
 #include <linux/completion.h>
-#include <linux/device.h>
 #include <linux/dma-mapping.h>
 #include <linux/kernel.h>
 #include <linux/kref.h>
@@ -68,6 +67,8 @@
 #define CSR_MODEL              0x17
 #define CSR_DIRECTORY_ID       0x20
 
+struct device;
+
 struct fw_csr_iterator {
        const u32 *p;
        const u32 *end;

But struct fw_device and struct fw_unit, defined in include/firewire.h,
incorporate struct device.

Furthermore, the inline function definitions
    fw_device,
    fw_unit,
    fw_unit_get,
    fw_unit_put,
    fw_parent_device
all require definitions from linux/device.h.
-- 
Stefan Richter
-=====-===-- --== ==---
http://arcgraph.de/sr/
