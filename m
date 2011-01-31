Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221Ab1AaHpN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 02:45:13 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48433 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152Ab1AaHpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 02:45:08 -0500
Subject: [PATCH 2/3] dt: Remove obsolete description of powerpc boot interface
To: devicetree-discuss@lists.ozlabs.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
From: Grant Likely <grant.likely@secretlab.ca>
Cc: jwboyer@linux.vnet.ibm.com, sam@ravnborg.org, benh@kernel.crashing.org
Date: Mon, 31 Jan 2011 00:45:05 -0700
Message-ID: <20110131074502.9058.11473.stgit@localhost6.localdomain6>
In-Reply-To: <20110131073918.9058.37628.stgit@localhost6.localdomain6>
References: <20110131073918.9058.37628.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

32 and 64 bit powerpc support has been merged for a while now, but
the booting-without-of.txt document still describes 32 bit as not
supporting multiplatform, which is no longer true.  This patch fixes
the documentation.

Also remove references to powerpc-specific details outside of section
I in preparation to add details for other architectures.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 Documentation/devicetree/booting-without-of.txt |   60 +++--------------------
 1 files changed, 8 insertions(+), 52 deletions(-)

diff --git a/Documentation/devicetree/booting-without-of.txt b/Documentation/devicetree/booting-without-of.txt
index 7400d75..6bca668 100644
--- a/Documentation/devicetree/booting-without-of.txt
+++ b/Documentation/devicetree/booting-without-of.txt
@@ -13,7 +13,6 @@ Table of Contents
 
   I - Introduction
     1) Entry point for arch/powerpc
-    2) Board support
 
   II - The DT block format
     1) Header
@@ -123,7 +122,7 @@ Revision Information
 I - Introduction
 ================
 
-During the recent development of the Linux/ppc64 kernel, and more
+During the development of the Linux/ppc64 kernel, and more
 specifically, the addition of new platform types outside of the old
 IBM pSeries/iSeries pair, it was decided to enforce some strict rules
 regarding the kernel entry and bootloader <-> kernel interfaces, in
@@ -146,7 +145,7 @@ section III, but, for example, the kernel does not require you to
 create a node for every PCI device in the system. It is a requirement
 to have a node for PCI host bridges in order to provide interrupt
 routing informations and memory/IO ranges, among others. It is also
-recommended to define nodes for on chip devices and other busses that
+recommended to define nodes for on chip devices and other buses that
 don't specifically fit in an existing OF specification. This creates a
 great flexibility in the way the kernel can then probe those and match
 drivers to device, without having to hard code all sorts of tables. It
@@ -210,12 +209,6 @@ it with special cases.
         with all CPUs. The way to do that with method b) will be
         described in a later revision of this document.
 
-
-2) Board support
-----------------
-
-64-bit kernels:
-
    Board supports (platforms) are not exclusive config options. An
    arbitrary set of board supports can be built in a single kernel
    image. The kernel will "know" what set of functions to use for a
@@ -234,48 +227,11 @@ it with special cases.
         containing the various callbacks that the generic code will
         use to get to your platform specific code
 
-        c) Add a reference to your "ppc_md" structure in the
-        "machines" table in arch/powerpc/kernel/setup_64.c if you are
-        a 64-bit platform.
-
-        d) request and get assigned a platform number (see PLATFORM_*
-        constants in arch/powerpc/include/asm/processor.h
-
-32-bit embedded kernels:
-
-  Currently, board support is essentially an exclusive config option.
-  The kernel is configured for a single platform.  Part of the reason
-  for this is to keep kernels on embedded systems small and efficient;
-  part of this is due to the fact the code is already that way. In the
-  future, a kernel may support multiple platforms, but only if the
+  A kernel image may support multiple platforms, but only if the
   platforms feature the same core architecture.  A single kernel build
   cannot support both configurations with Book E and configurations
   with classic Powerpc architectures.
 
-  32-bit embedded platforms that are moved into arch/powerpc using a
-  flattened device tree should adopt the merged tree practice of
-  setting ppc_md up dynamically, even though the kernel is currently
-  built with support for only a single platform at a time.  This allows
-  unification of the setup code, and will make it easier to go to a
-  multiple-platform-support model in the future.
-
-NOTE: I believe the above will be true once Ben's done with the merge
-of the boot sequences.... someone speak up if this is wrong!
-
-  To add a 32-bit embedded platform support, follow the instructions
-  for 64-bit platforms above, with the exception that the Kconfig
-  option should be set up such that the kernel builds exclusively for
-  the platform selected.  The processor type for the platform should
-  enable another config option to select the specific board
-  supported.
-
-NOTE: If Ben doesn't merge the setup files, may need to change this to
-point to setup_32.c
-
-
-   I will describe later the boot process and various callbacks that
-   your platform should implement.
-
 
 II - The DT block format
 ========================
@@ -300,8 +256,8 @@ the block to RAM before passing it to the kernel.
 1) Header
 ---------
 
-   The kernel is entered with r3 pointing to an area of memory that is
-   roughly described in arch/powerpc/include/asm/prom.h by the structure
+   The kernel is passed the physical address pointing to an area of memory
+   that is roughly described in include/linux/fdt.h by the structure
    boot_param_header:
 
 struct boot_param_header {
@@ -339,7 +295,7 @@ struct boot_param_header {
    All values in this header are in big endian format, the various
    fields in this header are defined more precisely below. All
    "offset" values are in bytes from the start of the header; that is
-   from the value of r3.
+   from the physical base address of the device tree block.
 
    - magic
 
@@ -437,7 +393,7 @@ struct boot_param_header {
 
 
              ------------------------------
-       r3 -> |  struct boot_param_header  |
+     base -> |  struct boot_param_header  |
              ------------------------------
              |      (alignment gap) (*)   |
              ------------------------------
@@ -457,7 +413,7 @@ struct boot_param_header {
       -----> ------------------------------
       |
       |
-      --- (r3 + totalsize)
+      --- (base + totalsize)
 
   (*) The alignment gaps are not necessarily present; their presence
       and size are dependent on the various alignment requirements of

