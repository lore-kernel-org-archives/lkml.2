Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226Ab0JYOkB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 10:40:01 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:16356 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756094Ab0JYOjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 10:39:39 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz32i87h2a8h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0LAUOPT-01-6ZC-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 4/5] mce, amd: Remove goto in threshold_create_device()
Date: Mon, 25 Oct 2010 16:03:38 +0200
Message-ID: <1288015419-29543-5-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1288015419-29543-1-git-send-email-robert.richter@amd.com>
References: <1288015419-29543-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing the goto in threshold_create_device().

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/mcheck/mce_amd.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index e316684..5bf2fac 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -622,9 +622,9 @@ static __cpuinit int threshold_create_device(unsigned int cpu)
 			continue;
 		err = threshold_create_bank(cpu, bank);
 		if (err)
-			goto out;
+			return err;
 	}
-out:
+
 	return err;
 }
 
-- 
1.7.3.1


