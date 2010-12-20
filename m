Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933000Ab0LTROZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 12:14:25 -0500
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:41403
	"EHLO DB3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932940Ab0LTROV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 12:14:21 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LDQL70-02-3MW-02
X-M-MSG: 
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: <hpa@zytor.com>, <tglx@linutronix.de>, <mingo@elte.hu>
CC: <linux-kernel@vger.kernel.org>, <andreas.herrmann3@amd.com>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>
Subject: [PATCH 2/4] x86, amd: Enable L3 cache index disable on family 0x15
Date: Mon, 20 Dec 2010 18:13:45 +0100
Message-ID: <1292865227-647466-3-git-send-email-hans.rosenfeld@amd.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1292865227-647466-1-git-send-email-hans.rosenfeld@amd.com>
References: <1292865227-647466-1-git-send-email-hans.rosenfeld@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AMD family 0x15 CPUs support L3 cache index disable, so enable it on
them.

Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
---
 arch/x86/kernel/amd_nb.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
index affacb5..4ce87c2 100644
--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -78,6 +78,9 @@ int amd_cache_northbridges(void)
 	     boot_cpu_data.x86_mask >= 0x1))
 		amd_northbridges.flags |= AMD_NB_L3_INDEX_DISABLE;
 
+	if (boot_cpu_data.x86 == 0x15)
+		amd_northbridges.flags |= AMD_NB_L3_INDEX_DISABLE;
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(amd_cache_northbridges);
-- 
1.5.6.5


