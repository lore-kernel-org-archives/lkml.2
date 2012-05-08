Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab2EHPNF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 11:13:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57068 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755893Ab2EHPND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 11:13:03 -0400
Date: Tue, 8 May 2012 08:12:44 -0700
From: tip-bot for Jan Beulich <JBeulich@suse.com>
Message-ID: <tip-b2a3477727c1d43b92a3e4223f10ad5bf639df06@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jbeulich@suse.com, JBeulich@suse.com, sp@numascale.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        JBeulich@suse.com, jbeulich@suse.com, tglx@linutronix.de,
        sp@numascale.com
In-Reply-To: <4FA947910200007800082470@nat28.tlf.novell.com>
References: <4FA947910200007800082470@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Fix section annotation of acpi_map_cpu2node(
 )
Git-Commit-ID: b2a3477727c1d43b92a3e4223f10ad5bf639df06
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 08 May 2012 08:12:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b2a3477727c1d43b92a3e4223f10ad5bf639df06
Gitweb:     http://git.kernel.org/tip/b2a3477727c1d43b92a3e4223f10ad5bf639df06
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Tue, 8 May 2012 15:19:29 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 8 May 2012 16:40:26 +0200

x86: Fix section annotation of acpi_map_cpu2node()

Commit 943bc7e110f2 ("x86: Fix section warnings") added
__cpuinitdata here, while for functions __cpuinit should be
used.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: <sp@numascale.com>
Link: http://lkml.kernel.org/r/4FA947910200007800082470@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Steffen Persvold <sp@numascale.com>
---
 arch/x86/kernel/acpi/boot.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index a415b1f..7c439fe 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -593,7 +593,7 @@ void __init acpi_set_irq_model_ioapic(void)
 #ifdef CONFIG_ACPI_HOTPLUG_CPU
 #include <acpi/processor.h>
 
-static void __cpuinitdata acpi_map_cpu2node(acpi_handle handle, int cpu, int physid)
+static void __cpuinit acpi_map_cpu2node(acpi_handle handle, int cpu, int physid)
 {
 #ifdef CONFIG_ACPI_NUMA
 	int nid;
