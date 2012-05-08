Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab2EHKB6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 06:01:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53377 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538Ab2EHKBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 06:01:55 -0400
Date: Tue, 8 May 2012 03:01:42 -0700
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-399988eea194a8453e283fdd2da968d1fd39a7cf@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        joerg.roedel@amd.com, suresh.b.siddha@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        joerg.roedel@amd.com, suresh.b.siddha@intel.com, tglx@linutronix.de
In-Reply-To: <1336460934-23592-1-git-send-email-suresh.b.siddha@intel.com>
References: <1336460934-23592-1-git-send-email-suresh.b.siddha@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/iommu] irq_remap:
  Fix compiler warning with CONFIG_IRQ_REMAP=y
Git-Commit-ID: 399988eea194a8453e283fdd2da968d1fd39a7cf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 08 May 2012 03:01:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  399988eea194a8453e283fdd2da968d1fd39a7cf
Gitweb:     http://git.kernel.org/tip/399988eea194a8453e283fdd2da968d1fd39a7cf
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Tue, 8 May 2012 00:08:52 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 8 May 2012 11:17:29 +0200

irq_remap: Fix compiler warning with CONFIG_IRQ_REMAP=y

Fix the below compiler warning:

arch/x86/include/asm/irq_remapping.h:72:19: warning: ‘struct IO_APIC_route_entry’ declared inside parameter list [enabled by default]

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: joro@8bytes.org
Cc: iommu@lists.linux-foundation.org
Cc: Joerg Roedel <joerg.roedel@amd.com>
Link: http://lkml.kernel.org/r/1336460934-23592-1-git-send-email-suresh.b.siddha@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/irq_remapping.h |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index dcb0c72..5fb9bbb 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -22,11 +22,9 @@
 #ifndef __X86_IRQ_REMAPPING_H
 #define __X86_IRQ_REMAPPING_H
 
-#ifdef CONFIG_IRQ_REMAP
+#include <asm/io_apic.h>
 
-struct IO_APIC_route_entry;
-struct io_apic_irq_attr;
-struct pci_dev;
+#ifdef CONFIG_IRQ_REMAP
 
 extern int irq_remapping_enabled;
 
