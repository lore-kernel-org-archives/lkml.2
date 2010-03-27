Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235Ab0C0GyT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 02:54:19 -0400
Received: from server78.greatnet.de ([83.133.96.102]:42749 "EHLO
	server78.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab0C0GyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 02:54:17 -0400
From: Henrik Kretzschmar <henne@nachtwindheim.de>
To: steffen.klassert@secunet.com
Cc: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
       Henrik Kretzschmar <henne@nachtwindheim.de>
Subject: [PATCH] padata: section cleanup
Date: Sat, 27 Mar 2010 07:53:46 +0100
Message-Id: <1269672826-1102-1-git-send-email-henne@nachtwindheim.de>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the __cupinit from padata_cpu_callback(),
which is refered by the exportet function padata_alloc().

This could lead to problems if CONFIG_HOTPLUG_CPU is disabled,
which should happen very often.

WARNING: kernel/built-in.o(.text+0x7ffcb): Section mismatch in reference from the function padata_alloc() to the function .cpuinit.text:padata_cpu_callback()
The function padata_alloc() references
the function __cpuinit padata_cpu_callback().
This is often because padata_alloc lacks a __cpuinit
annotation or the annotation of padata_cpu_callback is wrong.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
---
 kernel/padata.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 93caf65..32fdd5f 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -569,7 +569,7 @@ void padata_stop(struct padata_instance *pinst)
 }
 EXPORT_SYMBOL(padata_stop);
 
-static int __cpuinit padata_cpu_callback(struct notifier_block *nfb,
+static int padata_cpu_callback(struct notifier_block *nfb,
 					 unsigned long action, void *hcpu)
 {
 	int err;
-- 
1.7.0

