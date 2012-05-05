Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910Ab2EESqS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 14:46:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54061 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926Ab2EESqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 14:46:17 -0400
Date: Sat, 5 May 2012 11:46:03 -0700
From: tip-bot for Yong Wang <yong.y.wang@intel.com>
Message-ID: <tip-ab27a20e6212cd1d96d813352b47e1fc1cfd01db@git.kernel.org>
Cc: mjg@redhat.com, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        hpa@zytor.com, mingo@kernel.org, kirill.shutemov@linux.intel.com,
        pierre.tardy@intel.com, yong.y.wang@intel.com, kangkai.yin@intel.com,
        akpm@linux-foundation.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        alan@linux.intel.com, mjg@redhat.com, kirill.shutemov@linux.intel.com,
        pierre.tardy@intel.com, yong.y.wang@intel.com, kangkai.yin@intel.com,
        akpm@linux-foundation.org, tglx@linutronix.de
In-Reply-To: <20120504210244.F2EA5A018B@akpm.mtv.corp.google.com>
References: <20120504210244.F2EA5A018B@akpm.mtv.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] intel_mid_powerbtn: mark irq as IRQF_NO_SUSPEND
Git-Commit-ID: ab27a20e6212cd1d96d813352b47e1fc1cfd01db
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 05 May 2012 11:46:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ab27a20e6212cd1d96d813352b47e1fc1cfd01db
Gitweb:     http://git.kernel.org/tip/ab27a20e6212cd1d96d813352b47e1fc1cfd01db
Author:     Yong Wang <yong.y.wang@intel.com>
AuthorDate: Fri, 4 May 2012 14:02:44 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 4 May 2012 14:40:52 -0700

intel_mid_powerbtn: mark irq as IRQF_NO_SUSPEND

So that the power button still wakes up the platform.

Signed-off-by: Pierre Tardy <pierre.tardy@intel.com>
Link: http://lkml.kernel.org/r/20120504210244.F2EA5A018B@akpm.mtv.corp.google.com
Tested-by: Kangkai Yin <kangkai.yin@intel.com>
Tested-by: Yong Wang <yong.y.wang@intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 drivers/platform/x86/intel_mid_powerbtn.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/intel_mid_powerbtn.c b/drivers/platform/x86/intel_mid_powerbtn.c
index 0a3594c..bcbad84 100644
--- a/drivers/platform/x86/intel_mid_powerbtn.c
+++ b/drivers/platform/x86/intel_mid_powerbtn.c
@@ -78,7 +78,7 @@ static int __devinit mfld_pb_probe(struct platform_device *pdev)
 
 	input_set_capability(input, EV_KEY, KEY_POWER);
 
-	error = request_threaded_irq(irq, NULL, mfld_pb_isr, 0,
+	error = request_threaded_irq(irq, NULL, mfld_pb_isr, IRQF_NO_SUSPEND,
 			DRIVER_NAME, input);
 	if (error) {
 		dev_err(&pdev->dev, "Unable to request irq %d for mfld power"
