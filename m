Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759258Ab0ENTBL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 15:01:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:53136 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758956Ab0ENTBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 15:01:08 -0400
Date: Fri, 14 May 2010 19:00:48 GMT
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       stable@kernel.org, tglx@linutronix.de, borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       stable@kernel.org, tglx@linutronix.de, borislav.petkov@amd.com
In-Reply-To: <20100503183036.GJ26107@aftab>
References: <20100503183036.GJ26107@aftab>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, k8: Fix build error when K8_NB is disabled
Message-ID: <tip-ade029e2aaacc8965a548b0b0f80c5bee97ffc68@git.kernel.org>
Git-Commit-ID: ade029e2aaacc8965a548b0b0f80c5bee97ffc68
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 14 May 2010 19:00:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ade029e2aaacc8965a548b0b0f80c5bee97ffc68
Gitweb:     http://git.kernel.org/tip/ade029e2aaacc8965a548b0b0f80c5bee97ffc68
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Sat, 24 Apr 2010 09:56:53 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 14 May 2010 11:53:01 -0700

x86, k8: Fix build error when K8_NB is disabled

K8_NB depends on PCI and when the last is disabled (allnoconfig) we fail
at the final linking stage due to missing exported num_k8_northbridges.
Add a header stub for that.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
LKML-Reference: <20100503183036.GJ26107@aftab>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: <stable@kernel.org>
---
 arch/x86/include/asm/k8.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/k8.h b/arch/x86/include/asm/k8.h
index f70e600..af00bd1 100644
--- a/arch/x86/include/asm/k8.h
+++ b/arch/x86/include/asm/k8.h
@@ -16,11 +16,16 @@ extern int k8_numa_init(unsigned long start_pfn, unsigned long end_pfn);
 extern int k8_scan_nodes(void);
 
 #ifdef CONFIG_K8_NB
+extern int num_k8_northbridges;
+
 static inline struct pci_dev *node_to_k8_nb_misc(int node)
 {
 	return (node < num_k8_northbridges) ? k8_northbridges[node] : NULL;
 }
+
 #else
+#define num_k8_northbridges 0
+
 static inline struct pci_dev *node_to_k8_nb_misc(int node)
 {
 	return NULL;
