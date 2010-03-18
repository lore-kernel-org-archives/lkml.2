Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897Ab0CRJHv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 05:07:51 -0400
Received: from mail-yw0-f201.google.com ([209.85.211.201]:59673 "EHLO
	mail-yw0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712Ab0CRJHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 05:07:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=EmUlFaG/OPmcoVONLIFt/FLKjRTiNZa00MJXJcAEU66kSaj5YZ+/wDPyR4xmVgevIH
         fYiuYD9KxhFKOnNnQsqf8mtVaiBI4YzH9H42RnXysxZ3nVSPEbKzF/YxDvtgm3Z4s9ir
         T/v5Iaam6+kaY6OfnWvKOaobJGB6tqEA0R1Co=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH 04/12] x86: convert cpu notifier to return encapsulate errno value
Date: Thu, 18 Mar 2010 18:05:16 +0900
Message-Id: <1268903124-10237-4-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1268903124-10237-1-git-send-email-akinobu.mita@gmail.com>
References: <1268903124-10237-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By the previous modification, the cpu notifier can return encapsulate
errno value. This converts the cpu notifiers for msr, cpuid, and
therm_throt.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
---
 arch/x86/kernel/cpu/mcheck/therm_throt.c |    2 +-
 arch/x86/kernel/cpuid.c                  |    2 +-
 arch/x86/kernel/msr.c                    |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index 81c499e..e1a0a3b 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -190,7 +190,7 @@ thermal_throttle_cpu_callback(struct notifier_block *nfb,
 		mutex_unlock(&therm_cpu_lock);
 		break;
 	}
-	return err ? NOTIFY_BAD : NOTIFY_OK;
+	return notifier_from_errno(err);
 }
 
 static struct notifier_block thermal_throttle_cpu_notifier __cpuinitdata =
diff --git a/arch/x86/kernel/cpuid.c b/arch/x86/kernel/cpuid.c
index 83e5e62..caf11b5 100644
--- a/arch/x86/kernel/cpuid.c
+++ b/arch/x86/kernel/cpuid.c
@@ -169,7 +169,7 @@ static int __cpuinit cpuid_class_cpu_callback(struct notifier_block *nfb,
 		cpuid_device_destroy(cpu);
 		break;
 	}
-	return err ? NOTIFY_BAD : NOTIFY_OK;
+	return notifier_from_errno(err);
 }
 
 static struct notifier_block __refdata cpuid_class_cpu_notifier =
diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index 206735a..823081b 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -229,7 +229,7 @@ static int __cpuinit msr_class_cpu_callback(struct notifier_block *nfb,
 		msr_device_destroy(cpu);
 		break;
 	}
-	return err ? NOTIFY_BAD : NOTIFY_OK;
+	return notifier_from_errno(err);
 }
 
 static struct notifier_block __refdata msr_class_cpu_notifier = {
-- 
1.6.0.6

