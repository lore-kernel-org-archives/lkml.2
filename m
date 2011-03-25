Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367Ab1CYXwi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 19:52:38 -0400
Received: from kroah.org ([198.145.64.141]:41574 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932325Ab1CYXwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:52:34 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 16:48:41 2011
Message-Id: <20110325234840.908731104@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 16:47:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Len Brown <len.brown@intel.com>
Subject: [19/55] intel_idle: disable Atom/Lincroft HW C-state auto-demotion
In-Reply-To: <20110325234853.GA21145@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Len Brown <len.brown@intel.com>

commit bfb53ccf1c734b1907df7189eef4c08489827951 upstream.

Just as we had to disable auto-demotion for NHM/WSM,
we need to do the same for Atom (Lincroft version).

In particular, auto-demotion will prevent Lincroft
from entering the S0i3 idle power saving state.

https://bugzilla.kernel.org/show_bug.cgi?id=25252

Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/msr-index.h |    1 +
 drivers/idle/intel_idle.c        |    4 ++++
 2 files changed, 5 insertions(+)

--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -39,6 +39,7 @@
 #define MSR_NHM_SNB_PKG_CST_CFG_CTL	0x000000e2
 #define NHM_C3_AUTO_DEMOTE		(1UL << 25)
 #define NHM_C1_AUTO_DEMOTE		(1UL << 26)
+#define ATM_LNC_C6_AUTO_DEMOTE		(1UL << 25)
 
 #define MSR_MTRRcap			0x000000fe
 #define MSR_IA32_BBL_CR_CTL		0x00000119
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -340,8 +340,12 @@ static int intel_idle_probe(void)
 		break;
 
 	case 0x1C:	/* 28 - Atom Processor */
+		cpuidle_state_table = atom_cstates;
+		break;
+
 	case 0x26:	/* 38 - Lincroft Atom Processor */
 		cpuidle_state_table = atom_cstates;
+		auto_demotion_disable_flags = ATM_LNC_C6_AUTO_DEMOTE;
 		break;
 
 	case 0x2A:	/* SNB */


