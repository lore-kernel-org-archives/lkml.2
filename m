Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205Ab1AaHps (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 02:45:48 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60314 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978Ab1AaHpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 02:45:47 -0500
Subject: [PATCH 3/3 RFC] dt: add documentation of ARM dt boot interface
To: devicetree-discuss@lists.ozlabs.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
From: Grant Likely <grant.likely@secretlab.ca>
Cc: jwboyer@linux.vnet.ibm.com, sam@ravnborg.org, benh@kernel.crashing.org
Date: Mon, 31 Jan 2011 00:45:41 -0700
Message-ID: <20110131074510.9058.59071.stgit@localhost6.localdomain6>
In-Reply-To: <20110131073918.9058.37628.stgit@localhost6.localdomain6>
References: <20110131073918.9058.37628.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

For RFC only.  I do not plan to merge this change yet.

g.

 Documentation/devicetree/booting-without-of.txt |   40 +++++++++++++++++++++++
 1 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/booting-without-of.txt b/Documentation/devicetree/booting-without-of.txt
index 6bca668..3950aea 100644
--- a/Documentation/devicetree/booting-without-of.txt
+++ b/Documentation/devicetree/booting-without-of.txt
@@ -13,6 +13,7 @@ Table of Contents
 
   I - Introduction
     1) Entry point for arch/powerpc
+    2) Entry point for arch/arm
 
   II - The DT block format
     1) Header
@@ -232,6 +233,45 @@ it with special cases.
   cannot support both configurations with Book E and configurations
   with classic Powerpc architectures.
 
+2) Entry point for arch/arm
+---------------------------
+
+   There is one and one single entry point to the kernel, at the start
+   of the kernel image. That entry point supports two calling
+   conventions.  A summary of the interface is described here.  A full
+   description of the boot requirements is documented in
+   Documentation/arm/Booting
+
+        a) ATAGS interface.  Minimal information is passed from firmware
+        to the kernel with a tagged list of predefined parameters.
+
+                r0 : 0
+
+                r1 : Machine type number
+
+                r2 : Physical address of tagged list in system RAM
+
+        b) Entry with a flattened device-tree block.  Firmware loads the
+        physical address of the flattened device tree block (dtb) into r2,
+        r1 is not used, but it is considered good practise to use a valid
+        machine number as described in Documentation/arm/Booting.
+
+                r0 : 0
+
+                r1 : Valid machine type number.  When using a device tree,
+                a single machine type number will often be assigned to
+                represent a class or family of SoCs.
+
+                r2 : physical pointer to the device-tree block
+                (defined in chapter II) in RAM.  Device tree can be located
+                anywhere in system RAM, but it should be aligned on a 32 bit
+                boundary.
+
+   The kernel will differentiate between ATAGS and device tree booting by
+   reading the memory pointed to by r1 and looking for either the flattened
+   device tree block magic value (0xd00dfeed) or the ATAG_CORE value at
+   offset 0x4 from r2 (0x54410001).
+
 
 II - The DT block format
 ========================

