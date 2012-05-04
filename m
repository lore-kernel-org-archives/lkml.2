Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760167Ab2EDWGp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 18:06:45 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:14213 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756625Ab2EDWGo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 18:06:44 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 04 May 2012 15:06:21 -0700
From: Diwakar Tundlam <dtundlam@nvidia.com>
To: "'Ingo Molnar'" <mingo@kernel.org>,
        "'Peter Zijlstra'" <a.p.zijlstra@chello.nl>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Christoph Lameter'" <cl@gentwo.org>,
        "'Michael Neuling'" <mikey@neuling.org>,
        "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
        "'Benjamin Herrenschmidt'" <benh@kernel.crashing.org>,
        "'David Rientjes'" <rientjes@google.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
CC: Peter De Schrijver <pdeschrijver@nvidia.com>
Date: Fri, 4 May 2012 15:06:21 -0700
Subject: RE: [PATCH] sched: Enable arch-specific asym packing option in
 sched domain
Thread-Topic: [PATCH] sched: Enable arch-specific asym packing option in
 sched domain
Thread-Index: Ac0qNHe4gwlID3qFSgKSSSyMfRIpDAACtMQA
Message-ID: <1DD7BFEDD3147247B1355BEFEFE46652379C3DF101@HQMAIL04.nvidia.com>
References: <1DD7BFEDD3147247B1355BEFEFE46652379C3DF0FF@HQMAIL04.nvidia.com>
In-Reply-To: <1DD7BFEDD3147247B1355BEFEFE46652379C3DF0FF@HQMAIL04.nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add arch specific (weak) routine to set (or not set) the ASYM_PACKING
sched domain flag. This change itself does nothing, but allows archs
that require asym-packing option to set it by implementing the arch
specific routine to turn it on.

The weak symbol is already defined in sched/core.c but was mis-spelled
in the header file. Fixed spelling error in the weak symbol definition.

Signed-off-by: Diwakar Tundlam <dtundlam@nvidia.com>

diff --git a/include/linux/sched.h b/include/linux/sched.h
index c569719..cf793f0 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -903,7 +903,7 @@ static inline int sd_balance_for_package_power(void)
 	return SD_PREFER_SIBLING;
 }
 
-extern int __weak arch_sd_sibiling_asym_packing(void);
+extern int __weak arch_sd_sibling_asym_packing(void);
 
 /*
  * Optimise SD flags for power savings:
diff --git a/include/linux/topology.h b/include/linux/topology.h
index b480403..eb09cd4 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -168,6 +168,7 @@ int arch_update_cpu_topology(void);
 				| 0*SD_SHARE_CPUPOWER			\
 				| 0*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
+				| arch_sd_sibling_asym_packing()	\
 				| sd_balance_for_package_power()	\
 				| sd_power_saving_flags()		\
 				,					\
