Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326Ab1FOTMI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 15:12:08 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:20128 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294Ab1FOTMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 15:12:05 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Tom Goetz <tom.goetz@virtualcomputer.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 4/4] xen: When calling power_off, don't call the halt function.
Date: Wed, 15 Jun 2011 15:11:35 -0400
Message-Id: <1308165095-17303-5-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308165095-17303-1-git-send-email-konrad.wilk@oracle.com>
References: <1308165095-17303-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4DF903FF.00BB:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Goetz <tom.goetz@virtualcomputer.com>

.. As it won't actually power off the machine.

Signed-off-by: Tom Goetz <tom.goetz@virtualcomputer.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/enlighten.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index dd7b88f..5525163 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1033,6 +1033,13 @@ static void xen_machine_halt(void)
 	xen_reboot(SHUTDOWN_poweroff);
 }
 
+static void xen_machine_power_off(void)
+{
+	if (pm_power_off)
+		pm_power_off();
+	xen_reboot(SHUTDOWN_poweroff);
+}
+
 static void xen_crash_shutdown(struct pt_regs *regs)
 {
 	xen_reboot(SHUTDOWN_crash);
@@ -1058,7 +1065,7 @@ int xen_panic_handler_init(void)
 static const struct machine_ops xen_machine_ops __initconst = {
 	.restart = xen_restart,
 	.halt = xen_machine_halt,
-	.power_off = xen_machine_halt,
+	.power_off = xen_machine_power_off,
 	.shutdown = xen_machine_halt,
 	.crash_shutdown = xen_crash_shutdown,
 	.emergency_restart = xen_emergency_restart,
-- 
1.7.4.1

