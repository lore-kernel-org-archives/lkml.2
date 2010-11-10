Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676Ab0KJShS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 13:37:18 -0500
Received: from smtp.outflux.net ([198.145.64.163]:42213 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755587Ab0KJShO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 13:37:14 -0500
From: Kees Cook <kees.cook@canonical.com>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: Pekka Enberg <penberg@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 4/4] x86: only CPU features determine NX capabilities
Date: Wed, 10 Nov 2010 10:35:54 -0800
Message-Id: <1289414154-7829-5-git-send-email-kees.cook@canonical.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1289414154-7829-1-git-send-email-kees.cook@canonical.com>
References: <1289414154-7829-1-git-send-email-kees.cook@canonical.com>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the NX feature boot warning when NX is missing to correctly
reflect that BIOSes cannot disable NX now.

Signed-off-by: Kees Cook <kees.cook@canonical.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
---
 arch/x86/mm/setup_nx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/setup_nx.c b/arch/x86/mm/setup_nx.c
index a3250aa..410531d 100644
--- a/arch/x86/mm/setup_nx.c
+++ b/arch/x86/mm/setup_nx.c
@@ -41,7 +41,7 @@ void __init x86_report_nx(void)
 {
 	if (!cpu_has_nx) {
 		printk(KERN_NOTICE "Notice: NX (Execute Disable) protection "
-		       "missing in CPU or disabled in BIOS!\n");
+		       "missing in CPU!\n");
 	} else {
 #if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
 		if (disable_nx) {
-- 
1.7.2.3

