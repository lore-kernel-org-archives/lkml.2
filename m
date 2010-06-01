Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab0FATEy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 15:04:54 -0400
Received: from mail-va3.bigfish.com ([216.32.180.114]:33982 "EHLO
	mail195-va3-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751373Ab0FATEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 15:04:53 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzzz32i2a8h62h)
X-Spam-TCS-SCL: 1:0
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-WSS-ID: 0L3CNNQ-02-51P-02
X-M-MSG: 
Date: Tue, 1 Jun 2010 21:04:55 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
CC: x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86, smpboot: Fix cores per node printing on boot
Message-ID: <20100601190455.GA14237@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Einsteinring_24=2C_85609_Dornach_bei_M=FCnchen=2C_Gesc?=
	=?iso-8859-1?Q?h=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuliano_Meroni=2C?=
	=?iso-8859-1?Q?_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_Aschheim=2C_La?=
	=?iso-8859-1?Q?ndkreis_M=FCnchen=2C_Registergericht_M=FCnchen?=
	=?iso-8859-1?Q?=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Percpu initialization happens now after booting the cores on the machine
and this causes them all to be displayed as belonging to node 0:

Jun  8 05:57:21 kepek kernel: [    0.106999] Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #7 #8 #9 #10 #11 #12 #13 #14 #15 #16 #17 #18 #19 #20 #21 #22 #23 Ok.

Use early_cpu_to_node() to get the correct node of each core instead.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/smpboot.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 37462f1..c4f33b2 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -686,7 +686,7 @@ static void __cpuinit do_fork_idle(struct work_struct *work)
 static void __cpuinit announce_cpu(int cpu, int apicid)
 {
 	static int current_node = -1;
-	int node = cpu_to_node(cpu);
+	int node = early_cpu_to_node(cpu);
 
 	if (system_state == SYSTEM_BOOTING) {
 		if (node != current_node) {
-- 
1.6.4.4


-- 
Regards/Gruss,
Boris.

Operating Systems Research Center
Advanced Micro Devices, Inc.

