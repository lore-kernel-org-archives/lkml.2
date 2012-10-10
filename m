Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520Ab2JJRwu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 13:52:50 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:20035 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755649Ab2JJRwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 13:52:44 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 3/3] xen/bootup: allow read_tscp call for Xen PV guests.
Date: Wed, 10 Oct 2012 13:40:49 -0400
Message-Id: <1349890849-17471-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1349890849-17471-1-git-send-email-konrad.wilk@oracle.com>
References: <1349890849-17471-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hypervisor will trap it. However without this patch,
we would crash as the .read_tscp is set to NULL. This patch
fixes it and sets it to the native_read_tscp call.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/enlighten.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index e1e4636..c1461de 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1175,6 +1175,8 @@ static const struct pv_cpu_ops xen_cpu_ops __initconst = {
 	.read_tsc = native_read_tsc,
 	.read_pmc = native_read_pmc,
 
+	.read_tscp = native_read_tscp,
+
 	.iret = xen_iret,
 	.irq_enable_sysexit = xen_sysexit,
 #ifdef CONFIG_X86_64
-- 
1.7.7.6

