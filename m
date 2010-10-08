Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300Ab0JHOAq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 10:00:46 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:45277 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab0JHOAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 10:00:44 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz32i87h2a8h43h64h)
X-Spam-TCS-SCL: 3:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L9Z5KW-01-A9P-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 4/7] oprofile, x86: Remove duplicate check for IBS_CAPS_OPCNT
Date: Fri, 8 Oct 2010 15:56:29 +0200
Message-ID: <1286546192-18593-5-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1286546192-18593-1-git-send-email-robert.richter@amd.com>
References: <1286546192-18593-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since oprofile is setting up ibs_op/dispatched_ops in the fs only if
the feature is available, its corresponding variable
ibs_config.dispatched_ops is only set, if the feature is
available. Thus the check is duplicate and can be removed.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_amd.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index 96852d5..d5e9dab 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -257,8 +257,7 @@ static inline void op_amd_start_ibs(void)
 			ibs_op_ctl = min(ibs_op_ctl + IBS_RANDOM_MAXCNT_OFFSET,
 					 IBS_OP_MAX_CNT);
 		}
-		if (ibs_caps & IBS_CAPS_OPCNT && ibs_config.dispatched_ops)
-			ibs_op_ctl |= IBS_OP_CNT_CTL;
+		ibs_op_ctl |= ibs_config.dispatched_ops ? IBS_OP_CNT_CTL : 0;
 		ibs_op_ctl |= IBS_OP_ENABLE;
 		val = op_amd_randomize_ibs_op(ibs_op_ctl);
 		wrmsrl(MSR_AMD64_IBSOPCTL, val);
-- 
1.7.2.2


