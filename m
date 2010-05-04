Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757996Ab0EDKrJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 06:47:09 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:7416 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756225Ab0EDKrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 06:47:04 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzz6ff19hz32i2a8h87h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L1W5XR-01-7XM-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 7/7] oprofile/x86: remove duplicate IBS capability check
Date: Tue, 4 May 2010 12:44:53 +0200
Message-ID: <1272969893-29233-8-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <1272969893-29233-1-git-send-email-robert.richter@amd.com>
References: <1272969893-29233-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The check is already done in ibs_exit().

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_amd.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index e159254..384c524 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -490,8 +490,7 @@ static int init_ibs_nmi(void)
 /* uninitialize the APIC for the IBS interrupts if needed */
 static void clear_ibs_nmi(void)
 {
-	if (ibs_caps)
-		on_each_cpu(apic_clear_ibs_nmi_per_cpu, NULL, 1);
+	on_each_cpu(apic_clear_ibs_nmi_per_cpu, NULL, 1);
 }
 
 /* initialize the APIC for the IBS interrupts if available */
-- 
1.7.0.3


