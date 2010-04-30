Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758633Ab0D3VhM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 17:37:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:47558 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758150Ab0D3VhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 17:37:01 -0400
Date: Fri, 30 Apr 2010 21:36:42 GMT
From: tip-bot for Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de, prarit@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com, tglx@linutronix.de, prarit@redhat.com
In-Reply-To: <20100427152434.16193.49104.sendpatchset@prarit.bos.redhat.com>
References: <20100427152434.16193.49104.sendpatchset@prarit.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Fix NULL pointer access in irq_force_complete_move() for Xen guests
Message-ID: <tip-bbd391a15d82e14efe9d69ba64cadb855b061dba@git.kernel.org>
Git-Commit-ID: bbd391a15d82e14efe9d69ba64cadb855b061dba
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 30 Apr 2010 21:36:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bbd391a15d82e14efe9d69ba64cadb855b061dba
Gitweb:     http://git.kernel.org/tip/bbd391a15d82e14efe9d69ba64cadb855b061dba
Author:     Prarit Bhargava <prarit@redhat.com>
AuthorDate: Tue, 27 Apr 2010 11:24:42 -0400
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 30 Apr 2010 14:31:38 -0700

x86: Fix NULL pointer access in irq_force_complete_move() for Xen guests

Upstream PV guests fail to boot because of a NULL pointer in
irq_force_complete_move().  It is possible that xen guests have
irq_desc->chip_data = NULL.

Test for NULL chip_data pointer before attempting to complete an irq move.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
LKML-Reference: <20100427152434.16193.49104.sendpatchset@prarit.bos.redhat.com>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: <stable@kernel.org> [2.6.33]
---
 arch/x86/kernel/apic/io_apic.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 127b871..eb2789c 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2545,6 +2545,9 @@ void irq_force_complete_move(int irq)
 	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg = desc->chip_data;
 
+	if (!cfg)
+		return;
+
 	__irq_complete_move(&desc, cfg->vector);
 }
 #else
