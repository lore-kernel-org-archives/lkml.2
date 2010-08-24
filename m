Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934418Ab0HXXmq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:42:46 -0400
Received: from kroah.org ([198.145.64.141]:52279 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932524Ab0HXWyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:54:16 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:25:26 2010
Message-Id: <20100824222525.975705251@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:24:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "John L. Villalovos" <john.l.villalovos@intel.com>,
        Robert Richter <robert.richter@amd.com>
Subject: [41/59] Oprofile: Change CPUIDS from decimal to hex, and add some comments
In-Reply-To: <20100824224625.GA5449@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: John Villalovos <sodarock@gmail.com>

commit 45c34e05c4e3d36e7c44e790241ea11a1d90d54e upstream.

Back when the patch was submitted for "Add Xeon 7500 series support to
oprofile", Robert Richter had asked for a followon patch that
converted all the CPU ID values to hex.

I have done that here for the "i386/core_i7" and "i386/atom" class
processors in the ppro_init() function and also added some comments on
where to find documentation on the Intel processors.

Signed-off-by: John L. Villalovos <john.l.villalovos@intel.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/oprofile/nmi_int.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -584,6 +584,18 @@ static int __init ppro_init(char **cpu_t
 	if (force_arch_perfmon && cpu_has_arch_perfmon)
 		return 0;
 
+	/*
+	 * Documentation on identifying Intel processors by CPU family
+	 * and model can be found in the Intel Software Developer's
+	 * Manuals (SDM):
+	 *
+	 *  http://www.intel.com/products/processor/manuals/
+	 *
+	 * As of May 2010 the documentation for this was in the:
+	 * "Intel 64 and IA-32 Architectures Software Developer's
+	 * Manual Volume 3B: System Programming Guide", "Table B-1
+	 * CPUID Signature Values of DisplayFamily_DisplayModel".
+	 */
 	switch (cpu_model) {
 	case 0 ... 2:
 		*cpu_type = "i386/ppro";
@@ -605,12 +617,12 @@ static int __init ppro_init(char **cpu_t
 	case 15: case 23:
 		*cpu_type = "i386/core_2";
 		break;
+	case 0x1a:
 	case 0x2e:
-	case 26:
 		spec = &op_arch_perfmon_spec;
 		*cpu_type = "i386/core_i7";
 		break;
-	case 28:
+	case 0x1c:
 		*cpu_type = "i386/atom";
 		break;
 	default:


