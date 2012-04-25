Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759286Ab2DYN4x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 09:56:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44589 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab2DYN4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 09:56:51 -0400
Date: Wed, 25 Apr 2012 06:56:40 -0700
From: tip-bot for H Hartley Sweeten <hartleys@visionengravers.com>
Message-ID: <tip-d0d3bc65afcdd69bdd3b5bebdf8b3ee3680efa0e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com, hpa@zytor.com,
        mingo@kernel.org, hartleys@visionengravers.com, tglx@linutronix.de,
        hsweeten@visionengravers.com
Reply-To: mingo@kernel.org, hpa@zytor.com, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        hartleys@visionengravers.com, hsweeten@visionengravers.com
In-Reply-To: <201204241500.53685.hartleys@visionengravers.com>
References: <201204241500.53685.hartleys@visionengravers.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/mrst:
  Quiet sparse noise about plain integer as NULL pointer
Git-Commit-ID: d0d3bc65afcdd69bdd3b5bebdf8b3ee3680efa0e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 25 Apr 2012 06:56:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d0d3bc65afcdd69bdd3b5bebdf8b3ee3680efa0e
Gitweb:     http://git.kernel.org/tip/d0d3bc65afcdd69bdd3b5bebdf8b3ee3680efa0e
Author:     H Hartley Sweeten <hartleys@visionengravers.com>
AuthorDate: Tue, 24 Apr 2012 15:00:53 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 25 Apr 2012 12:47:08 +0200

x86/mrst: Quiet sparse noise about plain integer as NULL pointer

The second parameter to intel_scu_notifier_post is a void *, not
an integer.

This quiets the sparse noise:

 arch/x86/platform/mrst/mrst.c:808:48: warning: Using plain integer as NULL pointer
 arch/x86/platform/mrst/mrst.c:817:43: warning: Using plain integer as NULL pointer

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Acked-by: Alan Cox <alan@linux.intel.com>
Link: http://lkml.kernel.org/r/201204241500.53685.hartleys@visionengravers.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/platform/mrst/mrst.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
index e0a3723..e31bcd8 100644
--- a/arch/x86/platform/mrst/mrst.c
+++ b/arch/x86/platform/mrst/mrst.c
@@ -805,7 +805,7 @@ void intel_scu_devices_create(void)
 		} else
 			i2c_register_board_info(i2c_bus[i], i2c_devs[i], 1);
 	}
-	intel_scu_notifier_post(SCU_AVAILABLE, 0L);
+	intel_scu_notifier_post(SCU_AVAILABLE, NULL);
 }
 EXPORT_SYMBOL_GPL(intel_scu_devices_create);
 
@@ -814,7 +814,7 @@ void intel_scu_devices_destroy(void)
 {
 	int i;
 
-	intel_scu_notifier_post(SCU_DOWN, 0L);
+	intel_scu_notifier_post(SCU_DOWN, NULL);
 
 	for (i = 0; i < ipc_next_dev; i++)
 		platform_device_del(ipc_devs[i]);
