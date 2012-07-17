Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab2GQFCr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 01:02:47 -0400
Received: from ozlabs.org ([203.10.76.45]:38147 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754274Ab2GQFAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 01:00:49 -0400
From: Michael Ellerman <michael@ellerman.id.au>
To: <kvm@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <matt@ozlabs.org>, <penberg@kernel.org>,
        <kvm-ppc@vger.kernel.org>, <prerna@linux.vnet.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: [PATCH 04/10] kvm tools, powerpc: Use designated initializers for struct cpu_info
Date: Tue, 17 Jul 2012 15:00:14 +1000
Message-Id: <1342501220-10209-5-git-send-email-michael@ellerman.id.au>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342501220-10209-1-git-send-email-michael@ellerman.id.au>
References: <1342501220-10209-1-git-send-email-michael@ellerman.id.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using designated initializers for structs is preferable because it
is self documenting, and more robust against changes to the structure
layout.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
---
 tools/kvm/powerpc/cpu_info.c |   38 +++++++++++++++++++++-----------------
 tools/kvm/powerpc/cpu_info.h |    6 +++---
 2 files changed, 24 insertions(+), 20 deletions(-)

diff --git a/tools/kvm/powerpc/cpu_info.c b/tools/kvm/powerpc/cpu_info.c
index c364b74..ad27451 100644
--- a/tools/kvm/powerpc/cpu_info.c
+++ b/tools/kvm/powerpc/cpu_info.c
@@ -30,14 +30,16 @@ static u32 power7_page_sizes_prop[] = {0xc, 0x0, 0x1, 0xc, 0x0, 0x18, 0x100, 0x1
 static u32 power7_segment_sizes_prop[] = {0x1c, 0x28, 0xffffffff, 0xffffffff};
 
 static struct cpu_info cpu_power7_info = {
-	"POWER7",
-	power7_page_sizes_prop, sizeof(power7_page_sizes_prop),
-	power7_segment_sizes_prop, sizeof(power7_segment_sizes_prop),
-	32, 		/* SLB size */
-	512000000, 	/* TB frequency */
-	128,		/* d-cache block size */
-	128,		/* i-cache block size */
-	CPUINFO_FLAG_DFP | CPUINFO_FLAG_VSX | CPUINFO_FLAG_VMX
+	.name = "POWER7",
+	.page_sizes_prop = power7_page_sizes_prop,
+	.page_sizes_prop_len = sizeof(power7_segment_sizes_prop),
+	.segment_sizes_prop = power7_segment_sizes_prop,
+	.segment_sizes_prop_len = sizeof(power7_segment_sizes_prop),
+	.slb_size = 32,
+	.tb_freq = 512000000,
+	.d_bsize = 128,
+	.i_bsize = 128,
+	.flags = CPUINFO_FLAG_DFP | CPUINFO_FLAG_VSX | CPUINFO_FLAG_VMX,
 };
 
 /* PPC970/G5 */
@@ -45,18 +47,20 @@ static struct cpu_info cpu_power7_info = {
 static u32 g5_page_sizes_prop[] = {0xc, 0x0, 0x1, 0xc, 0x0, 0x18, 0x100, 0x1, 0x18, 0x0};
 
 static struct cpu_info cpu_970_info = {
-	"G5",
-	g5_page_sizes_prop, sizeof(g5_page_sizes_prop),
-	0 /* Null = no segment sizes prop, use defaults */, 0,
-	0, 		/* SLB size default */
-	33333333, 	/* TB frequency */
-	128,		/* d-cache block size */
-	128,		/* i-cache block size */
-	CPUINFO_FLAG_VMX
+	.name = "G5",
+	.page_sizes_prop = g5_page_sizes_prop,
+	.page_sizes_prop_len = sizeof(g5_page_sizes_prop),
+	.segment_sizes_prop = NULL /* no segment sizes prop, use defaults */,
+	.segment_sizes_prop_len = 0,
+	.slb_size = 0,
+	.tb_freq = 33333333,
+	.d_bsize = 128,
+	.i_bsize = 128,
+	.flags = CPUINFO_FLAG_VMX,
 };
 
 /* This is a default catchall for 'no match' on PVR: */
-static struct cpu_info cpu_dummy_info = { "unknown", 0, 0, 0, 0, 0, 0, 0, 0 };
+static struct cpu_info cpu_dummy_info = { .name = "unknown" };
 
 static struct pvr_info host_pvr_info[] = {
 	{ 0xffffffff, 0x0f000003, &cpu_power7_info },
diff --git a/tools/kvm/powerpc/cpu_info.h b/tools/kvm/powerpc/cpu_info.h
index 4a43ed5..2115c7f 100644
--- a/tools/kvm/powerpc/cpu_info.h
+++ b/tools/kvm/powerpc/cpu_info.h
@@ -21,9 +21,9 @@ struct cpu_info {
 	u32 		*segment_sizes_prop;
 	u32		segment_sizes_prop_len;
 	u32		slb_size;
-	u32		tb_freq;
-	u32		d_bsize;
-	u32		i_bsize;
+	u32		tb_freq; /* timebase frequency */
+	u32		d_bsize; /* d-cache block size */
+	u32		i_bsize; /* i-cache block size */
 	u32		flags;
 };
 
-- 
1.7.9.5

