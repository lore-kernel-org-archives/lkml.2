Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab0DQJAS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 05:00:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50078 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755142Ab0DQJAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 05:00:15 -0400
Message-ID: <4BC978A3.8010502@cn.fujitsu.com>
Date: Sat, 17 Apr 2010 17:00:19 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Subject: [PATCH] kvm: do not need hardware_disable when CPU_UP_CANCELED
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When CPU_UP_CANCELED, hardware_enable() has not been called at the CPU
which is going up because raw_notifier_call_chain(CPU_ONLINE)
has not been called for this cpu.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 5a0cd19..b03f863 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1921,11 +1921,6 @@ static int kvm_cpu_hotplug(struct notifier_block *notifier, unsigned long val,
 		       cpu);
 		hardware_disable(NULL);
 		break;
-	case CPU_UP_CANCELED:
-		printk(KERN_INFO "kvm: disabling virtualization on CPU%d\n",
-		       cpu);
-		smp_call_function_single(cpu, hardware_disable, NULL, 1);
-		break;
 	case CPU_ONLINE:
 		printk(KERN_INFO "kvm: enabling virtualization on CPU%d\n",
 		       cpu);



