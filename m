Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300Ab2GYHxx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 03:53:53 -0400
Received: from mga14.intel.com ([143.182.124.37]:4450 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755385Ab2GYHxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 03:53:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="126641558"
Date: Wed, 25 Jul 2012 15:53:49 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] ia64: mark PARAVIRT and KVM as broken
Message-ID: <20120725075349.GA17762@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, this at least makes allmodconfig happy.

Proposed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 arch/ia64/Kconfig     |    3 +--
 arch/ia64/kvm/Kconfig |    1 +
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 8186ec5..310cf57 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -126,6 +126,7 @@ config AUDIT_ARCH
 
 menuconfig PARAVIRT_GUEST
 	bool "Paravirtualized guest support"
+	depends on BROKEN
 	help
 	  Say Y here to get to see options related to running Linux under
 	  various hypervisors.  This option alone does not add any kernel code.
@@ -138,8 +139,6 @@ config PARAVIRT
 	bool "Enable paravirtualization code"
 	depends on PARAVIRT_GUEST
 	default y
-	bool
-	default y
 	help
 	  This changes the kernel so it can modify itself when it is run
 	  under a hypervisor, potentially improving performance significantly
diff --git a/arch/ia64/kvm/Kconfig b/arch/ia64/kvm/Kconfig
index 9806e55..8ca8e35 100644
--- a/arch/ia64/kvm/Kconfig
+++ b/arch/ia64/kvm/Kconfig
@@ -22,6 +22,7 @@ config KVM
 	depends on HAVE_KVM && MODULES && EXPERIMENTAL
 	# for device assignment:
 	depends on PCI
+	depends on BROKEN
 	select PREEMPT_NOTIFIERS
 	select ANON_INODES
 	select HAVE_KVM_IRQCHIP
-- 
1.7.10

