Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751695Ab0JAQCA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 12:02:00 -0400
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:33998
	"EHLO AM1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751582Ab0JAQB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 12:01:59 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz32i87h2a8h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L9MCH4-02-D82-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        Will Deacon <will.deacon@arm.com>,
        Matt Fleming <matt@console-pimps.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 4/5] oprofile, ARM: Remove some goto statements
Date: Fri, 1 Oct 2010 17:56:26 +0200
Message-ID: <1285948587-24521-5-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1285948587-24521-1-git-send-email-robert.richter@amd.com>
References: <1285948587-24521-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes some unnecessary goto statements.

Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/arm/oprofile/common.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm/oprofile/common.c b/arch/arm/oprofile/common.c
index cec9305..ab875f3 100644
--- a/arch/arm/oprofile/common.c
+++ b/arch/arm/oprofile/common.c
@@ -135,11 +135,10 @@ static int op_perf_start(void)
 		for (event = 0; event < perf_num_counters; ++event) {
 			ret = op_create_counter(cpu, event);
 			if (ret)
-				goto out;
+				return ret;
 		}
 	}
 
-out:
 	return ret;
 }
 
@@ -263,7 +262,7 @@ static int __init init_driverfs(void)
 
 	ret = platform_driver_register(&oprofile_driver);
 	if (ret)
-		goto out;
+		return ret;
 
 	oprofile_pdev =	platform_device_register_simple(
 				oprofile_driver.driver.name, 0, NULL, 0);
@@ -272,7 +271,6 @@ static int __init init_driverfs(void)
 		platform_driver_unregister(&oprofile_driver);
 	}
 
-out:
 	return ret;
 }
 
-- 
1.7.2.2


