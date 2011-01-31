Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab1AaUT4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 15:19:56 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55595 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab1AaUTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 15:19:55 -0500
Subject: [PATCH v3 2/3] dt: Remove obsolete description of powerpc boot
	interface
To: devicetree-discuss@lists.ozlabs.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
From: Grant Likely <grant.likely@secretlab.ca>
Cc: benh@kernel.crashing.org, jwboyer@linux.vnet.ibm.com, sam@ravnborg.org
Date: Mon, 31 Jan 2011 13:19:49 -0700
Message-ID: <20110131201948.12434.63475.stgit@localhost6.localdomain6>
In-Reply-To: <20110131201941.12434.11171.stgit@localhost6.localdomain6>
References: <20110131201941.12434.11171.stgit@localhost6.localdomain6>
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

v3: cleaned up a lot more powerpc-isms and updated text to reflect current
    usage conventions.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 Documentation/devicetree/booting-without-of.txt |  165 ++++++++---------------
 1 files changed, 54 insertions(+), 111 deletions(-)

diff --git a/Documentation/devicetree/booting-without-of.txt b/Documentation/devicetree/booting-without-of.txt
index 7400d75..28b1c9d 100644
--- a/Documentation/devicetree/booting-without-of.txt
+++ b/Documentation/devicetree/booting-without-of.txt
@@ -13,7 +13,6 @@ Table of Contents
 
   I - Introduction
     1) Entry point for arch/powerpc
-    2) Board support
 
   II - The DT block format
     1) Header
@@ -41,13 +40,6 @@ Table of Contents
   VI - System-on-a-chip devices and nodes
     1) Defining child nodes of an SOC
     2) Representing devices without a current OF specification
-      a) PHY nodes
-      b) Interrupt controllers
-      c) 4xx/Axon EMAC ethernet nodes
-      d) Xilinx IP cores
-      e) USB EHCI controllers
-      f) MDIO on GPIOs
-      g) SPI busses
 
   VII - Specifying interrupt information for devices
     1) interrupts property
@@ -123,7 +115,7 @@ Revision Information
 I - Introduction
 ================
 
-During the recent development of the Linux/ppc64 kernel, and more
+During the development of the Linux/ppc64 kernel, and more
 specifically, the addition of new platform types outside of the old
 IBM pSeries/iSeries pair, it was decided to enforce some strict rules
 regarding the kernel entry and bootloader <-> kernel interfaces, in
@@ -146,7 +138,7 @@ section III, but, for example, the kernel does not require you to
 create a node for every PCI device in the system. It is a requirement
 to have a node for PCI host bridges in order to provide interrupt
 routing informations and memory/IO ranges, among others. It is also
-recommended to define nodes for on chip devices and other busses that
+recommended to define nodes for on chip devices and other buses that
 don't specifically fit in an existing OF specification. This creates a
 great flexibility in the way the kernel can then probe those and match
 drivers to device, without having to hard code all sorts of tables. It
@@ -158,7 +150,7 @@ it with special cases.
 1) Entry point for arch/powerpc
 -------------------------------
 
-   There is one and one single entry point to the kernel, at the start
+   There is one single entry point to the kernel, at the start
    of the kernel image. That entry point supports two calling
    conventions:
 
@@ -210,12 +202,6 @@ it with special cases.
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
@@ -234,48 +220,11 @@ it with special cases.
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
@@ -300,8 +249,8 @@ the block to RAM before passing it to the kernel.
 1) Header
 ---------
 
-   The kernel is entered with r3 pointing to an area of memory that is
-   roughly described in arch/powerpc/include/asm/prom.h by the structure
+   The kernel is passed the physical address pointing to an area of memory
+   that is roughly described in include/linux/of_fdt.h by the structure
    boot_param_header:
 
 struct boot_param_header {
@@ -339,7 +288,7 @@ struct boot_param_header {
    All values in this header are in big endian format, the various
    fields in this header are defined more precisely below. All
    "offset" values are in bytes from the start of the header; that is
-   from the value of r3.
+   from the physical base address of the device tree block.
 
    - magic
 
@@ -437,7 +386,7 @@ struct boot_param_header {
 
 
              ------------------------------
-       r3 -> |  struct boot_param_header  |
+     base -> |  struct boot_param_header  |
              ------------------------------
              |      (alignment gap) (*)   |
              ------------------------------
@@ -457,7 +406,7 @@ struct boot_param_header {
       -----> ------------------------------
       |
       |
-      --- (r3 + totalsize)
+      --- (base + totalsize)
 
   (*) The alignment gaps are not necessarily present; their presence
       and size are dependent on the various alignment requirements of
@@ -500,7 +449,7 @@ the device-tree structure. It is typically used to represent "path" in
 the device-tree. More details about the actual format of these will be
 below.
 
-The kernel powerpc generic code does not make any formal use of the
+The kernel generic code does not make any formal use of the
 unit address (though some board support code may do) so the only real
 requirement here for the unit address is to ensure uniqueness of
 the node unit name at a given level of the tree. Nodes with no notion
@@ -518,20 +467,21 @@ path to the root node is "/".
 
 Every node which actually represents an actual device (that is, a node
 which isn't only a virtual "container" for more nodes, like "/cpus"
-is) is also required to have a "device_type" property indicating the
-type of node .
+is) is also required to have a "compatible" property indicating the
+specific hardware and an optional list of devices it is fully
+backwards compatible with.
 
 Finally, every node that can be referenced from a property in another
-node is required to have a "linux,phandle" property. Real open
-firmware implementations provide a unique "phandle" value for every
-node that the "prom_init()" trampoline code turns into
-"linux,phandle" properties. However, this is made optional if the
-flattened device tree is used directly. An example of a node
+node is required to have either a "phandle" or a "linux,phandle"
+property. Real Open Firmware implementations provide a unique
+"phandle" value for every node that the "prom_init()" trampoline code
+turns into "linux,phandle" properties. However, this is made optional
+if the flattened device tree is used directly. An example of a node
 referencing another node via "phandle" is when laying out the
 interrupt tree which will be described in a further version of this
 document.
 
-This "linux, phandle" property is a 32-bit value that uniquely
+The "phandle" property is a 32-bit value that uniquely
 identifies a node. You are free to use whatever values or system of
 values, internal pointers, or whatever to generate these, the only
 requirement is that every node for which you provide that property has
@@ -694,7 +644,7 @@ made of 3 cells, the bottom two containing the actual address itself
 while the top cell contains address space indication, flags, and pci
 bus & device numbers.
 
-For busses that support dynamic allocation, it's the accepted practice
+For buses that support dynamic allocation, it's the accepted practice
 to then not provide the address in "reg" (keep it 0) though while
 providing a flag indicating the address is dynamically allocated, and
 then, to provide a separate "assigned-addresses" property that
@@ -711,7 +661,7 @@ prom_parse.c file of the recent kernels for your bus type.
 The "reg" property only defines addresses and sizes (if #size-cells is
 non-0) within a given bus. In order to translate addresses upward
 (that is into parent bus addresses, and possibly into CPU physical
-addresses), all busses must contain a "ranges" property. If the
+addresses), all buses must contain a "ranges" property. If the
 "ranges" property is missing at a given level, it's assumed that
 translation isn't possible, i.e., the registers are not visible on the
 parent bus.  The format of the "ranges" property for a bus is a list
@@ -727,9 +677,9 @@ example, for a PCI host controller, that would be a CPU address. For a
 PCI<->ISA bridge, that would be a PCI address. It defines the base
 address in the parent bus where the beginning of that range is mapped.
 
-For a new 64-bit powerpc board, I recommend either the 2/2 format or
+For new 64-bit board support, I recommend either the 2/2 format or
 Apple's 2/1 format which is slightly more compact since sizes usually
-fit in a single 32-bit word.   New 32-bit powerpc boards should use a
+fit in a single 32-bit word.   New 32-bit board support should use a
 1/1 format, unless the processor supports physical addresses greater
 than 32-bits, in which case a 2/1 format is recommended.
 
@@ -754,7 +704,7 @@ of their actual names.
 While earlier users of Open Firmware like OldWorld macintoshes tended
 to use the actual device name for the "name" property, it's nowadays
 considered a good practice to use a name that is closer to the device
-class (often equal to device_type). For example, nowadays, ethernet
+class (often equal to device_type). For example, nowadays, Ethernet
 controllers are named "ethernet", an additional "model" property
 defining precisely the chip type/model, and "compatible" property
 defining the family in case a single driver can driver more than one
@@ -772,7 +722,7 @@ is present).
 4) Note about node and property names and character set
 -------------------------------------------------------
 
-While open firmware provides more flexible usage of 8859-1, this
+While Open Firmware provides more flexible usage of 8859-1, this
 specification enforces more strict rules. Nodes and properties should
 be comprised only of ASCII characters 'a' to 'z', '0' to
 '9', ',', '.', '_', '+', '#', '?', and '-'. Node names additionally
@@ -792,7 +742,7 @@ address which can extend beyond that limit.
 --------------------------------
   These are all that are currently required. However, it is strongly
   recommended that you expose PCI host bridges as documented in the
-  PCI binding to open firmware, and your interrupt tree as documented
+  PCI binding to Open Firmware, and your interrupt tree as documented
   in OF interrupt tree specification.
 
   a) The root node
@@ -802,20 +752,12 @@ address which can extend beyond that limit.
     - model : this is your board name/model
     - #address-cells : address representation for "root" devices
     - #size-cells: the size representation for "root" devices
-    - device_type : This property shouldn't be necessary. However, if
-      you decide to create a device_type for your root node, make sure it
-      is _not_ "chrp" unless your platform is a pSeries or PAPR compliant
-      one for 64-bit, or a CHRP-type machine for 32-bit as this will
-      matched by the kernel this way.
-
-  Additionally, some recommended properties are:
-
     - compatible : the board "family" generally finds its way here,
       for example, if you have 2 board models with a similar layout,
       that typically get driven by the same platform code in the
-      kernel, you would use a different "model" property but put a
-      value in "compatible". The kernel doesn't directly use that
-      value but it is generally useful.
+      kernel, you would specify the exact board model in the
+      compatible property followed by an entry that represents the SoC
+      model.
 
   The root node is also generally where you add additional properties
   specific to your board like the serial number if any, that sort of
@@ -841,8 +783,11 @@ address which can extend beyond that limit.
 
   So under /cpus, you are supposed to create a node for every CPU on
   the machine. There is no specific restriction on the name of the
-  CPU, though It's common practice to call it PowerPC,<name>. For
+  CPU, though it's common to call it <architecture>,<core>. For
   example, Apple uses PowerPC,G5 while IBM uses PowerPC,970FX.
+  However, the Generic Names convention suggests that it would be
+  better to simply use 'cpu' for each cpu node and use the compatible
+  property to identify the specific cpu core.
 
   Required properties:
 
@@ -923,7 +868,7 @@ compatibility.
 
   e) The /chosen node
 
-  This node is a bit "special". Normally, that's where open firmware
+  This node is a bit "special". Normally, that's where Open Firmware
   puts some variable environment information, like the arguments, or
   the default input/output devices.
 
@@ -940,11 +885,7 @@ compatibility.
       console device if any. Typically, if you have serial devices on
       your board, you may want to put the full path to the one set as
       the default console in the firmware here, for the kernel to pick
-      it up as its own default console. If you look at the function
-      set_preferred_console() in arch/ppc64/kernel/setup.c, you'll see
-      that the kernel tries to find out the default console and has
-      knowledge of various types like 8250 serial ports. You may want
-      to extend this function to add your own.
+      it up as its own default console.
 
   Note that u-boot creates and fills in the chosen node for platforms
   that use it.
@@ -955,23 +896,23 @@ compatibility.
 
   f) the /soc<SOCname> node
 
-  This node is used to represent a system-on-a-chip (SOC) and must be
-  present if the processor is a SOC. The top-level soc node contains
-  information that is global to all devices on the SOC. The node name
-  should contain a unit address for the SOC, which is the base address
-  of the memory-mapped register set for the SOC. The name of an soc
+  This node is used to represent a system-on-a-chip (SoC) and must be
+  present if the processor is a SoC. The top-level soc node contains
+  information that is global to all devices on the SoC. The node name
+  should contain a unit address for the SoC, which is the base address
+  of the memory-mapped register set for the SoC. The name of an SoC
   node should start with "soc", and the remainder of the name should
   represent the part number for the soc.  For example, the MPC8540's
   soc node would be called "soc8540".
 
   Required properties:
 
-    - device_type : Should be "soc"
     - ranges : Should be defined as specified in 1) to describe the
-      translation of SOC addresses for memory mapped SOC registers.
-    - bus-frequency: Contains the bus frequency for the SOC node.
+      translation of SoC addresses for memory mapped SoC registers.
+    - bus-frequency: Contains the bus frequency for the SoC node.
       Typically, the value of this field is filled in by the boot
       loader.
+    - compatible : Exact model of the SoC
 
 
   Recommended properties:
@@ -1155,12 +1096,13 @@ while all this has been defined and implemented.
 
   - An example of code for iterating nodes & retrieving properties
     directly from the flattened tree format can be found in the kernel
-    file arch/ppc64/kernel/prom.c, look at scan_flat_dt() function,
+    file drivers/of/fdt.c.  Look at the of_scan_flat_dt() function,
     its usage in early_init_devtree(), and the corresponding various
     early_init_dt_scan_*() callbacks. That code can be re-used in a
     GPL bootloader, and as the author of that code, I would be happy
     to discuss possible free licensing to any vendor who wishes to
     integrate all or part of this code into a non-GPL bootloader.
+    (reference needed; who is 'I' here? ---gcl Jan 31, 2011)
 
 
 
@@ -1203,18 +1145,19 @@ MPC8540.
 2) Representing devices without a current OF specification
 ----------------------------------------------------------
 
-Currently, there are many devices on SOCs that do not have a standard
-representation pre-defined as part of the open firmware
-specifications, mainly because the boards that contain these SOCs are
-not currently booted using open firmware.   This section contains
-descriptions for the SOC devices for which new nodes have been
-defined; this list will expand as more and more SOC-containing
-platforms are moved over to use the flattened-device-tree model.
+Currently, there are many devices on SoCs that do not have a standard
+representation defined as part of the Open Firmware specifications,
+mainly because the boards that contain these SoCs are not currently
+booted using Open Firmware.  Binding documentation for new devices
+should be added to the Documentation/devicetree/bindings directory.
+That directory will expand as device tree support is added to more and
+more SoCs.
+
 
 VII - Specifying interrupt information for devices
 ===================================================
 
-The device tree represents the busses and devices of a hardware
+The device tree represents the buses and devices of a hardware
 system in a form similar to the physical bus topology of the
 hardware.
 

