Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134Ab1JTCmZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 22:42:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:25285 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099Ab1JTCmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 22:42:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,375,1315206000"; 
   d="scan'208";a="75643231"
Subject: Re: [PATCH] Code clean up for percpu_xxx() functions
From: "Alex,Shi" <alex.shi@intel.com>
To: Avi Kivity <avi@redhat.com>
Cc: Christoph Lameter <cl@gentwo.org>, "tj@kernel.org" <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kaber@trash.net" <kaber@trash.net>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jeremy@xensource.com" <jeremy@xensource.com>
In-Reply-To: <4E9E97D2.1040807@redhat.com>
References: <1318237851.27949.190.camel@debian>
	 <alpine.DEB.2.00.1110101026080.16264@router.home>
	 <1318324774.27949.693.camel@debian>
	 <alpine.DEB.2.00.1110110910480.3388@router.home>
	 <1318382964.27949.782.camel@debian> <1318428673.29699.13.camel@debian>
	 <alpine.DEB.2.00.1110120910540.26610@router.home>
	 <1318908091.23426.52.camel@debian>
	 <alpine.DEB.2.00.1110180932330.687@router.home>
	 <1319016218.23426.104.camel@debian>  <4E9E97D2.1040807@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Oct 2011 10:45:12 +0800
Message-ID: <1319078712.23426.148.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> All of the kvm usage is in preemption disabled contexts.

Thanks! So would you like to ack this patch? 

===
>From 8ca7e6e40d75eab598c4fb4f8d555299b747adfa Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@intel.com>
Date: Thu, 20 Oct 2011 10:31:51 +0800
Subject: [PATCH 2/2] Change this_cpu_xxx to __this_cpu_xxx funcs

According to Avi, all of this_cpu_xx used in preempt disable context,
So change them to __this_cpu_xxx that without abundant preempt
protection.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 arch/x86/kvm/x86.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5ff2516..432c4bc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5024,15 +5024,15 @@ static DEFINE_PER_CPU(struct kvm_vcpu *, current_vcpu);
 
 static int kvm_is_in_guest(void)
 {
-	return this_cpu_read(current_vcpu) != NULL;
+	return __this_cpu_read(current_vcpu) != NULL;
 }
 
 static int kvm_is_user_mode(void)
 {
 	int user_mode = 3;
 
-	if (this_cpu_read(current_vcpu))
-		user_mode = kvm_x86_ops->get_cpl(this_cpu_read(current_vcpu));
+	if (__this_cpu_read(current_vcpu))
+		user_mode = kvm_x86_ops->get_cpl(__this_cpu_read(current_vcpu));
 
 	return user_mode != 0;
 }
@@ -5041,8 +5041,8 @@ static unsigned long kvm_get_guest_ip(void)
 {
 	unsigned long ip = 0;
 
-	if (this_cpu_read(current_vcpu))
-		ip = kvm_rip_read(this_cpu_read(current_vcpu));
+	if (__this_cpu_read(current_vcpu))
+		ip = kvm_rip_read(__this_cpu_read(current_vcpu));
 
 	return ip;
 }
-- 
1.6.3.3




