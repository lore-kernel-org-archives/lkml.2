Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785Ab2GDJdb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 05:33:31 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:34952 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541Ab2GDJda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 05:33:30 -0400
X-AuditID: b753bd60-9ea82ba000000655-15-4ff40de761d5
X-AuditID: b753bd60-9ea82ba000000655-15-4ff40de761d5
Message-ID: <4FF40DEF.5090307@hitachi.com>
Date: Wed, 04 Jul 2012 18:33:35 +0900
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH 00/18] KVM: x86: CPU isolation and direct interrupts
 handling by guests
References: <20120628060719.19298.43879.stgit@localhost.localdomain>
In-Reply-To: <20120628060719.19298.43879.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

There were some missing pieces for trying this patch series.

Firstly, the patch is for v3.5-rc4, but that version has an issue
that it cannot passthrough PCI devices because of genirq changes.
A patch to avoid this issue is available at
https://lkml.org/lkml/2012/6/1/261 .

Secondly, to successfully build the patched qemu-kvm, you need the
following additional definitions to qemu-kvm's header files for KVM.

diff -u -r qemu-kvm-0.15.1/linux-headers/linux/kvm.h qemu-kvm-0.15.1-test/linux-headers/linux/kvm.h
--- qemu-kvm-0.15.1/linux-headers/linux/kvm.h	2011-10-19 22:54:48.000000000 +0900
+++ qemu-kvm-0.15.1-test/linux-headers/linux/kvm.h	2012-06-25 21:21:20.273488167 +0900
@@ -544,6 +544,7 @@
 #define KVM_CAP_TSC_CONTROL 60
 #define KVM_CAP_GET_TSC_KHZ 61
 #define KVM_CAP_PPC_BOOKE_SREGS 62
+#define KVM_CAP_SLAVE_CPU 80
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -746,6 +747,9 @@
 /* Available with KVM_CAP_XCRS */
 #define KVM_GET_XCRS		  _IOR(KVMIO,  0xa6, struct kvm_xcrs)
 #define KVM_SET_XCRS		  _IOW(KVMIO,  0xa7, struct kvm_xcrs)
+/* Available with KVM_CAP_SLAVE_CPU */
+#define KVM_GET_SLAVE_CPU         _IO(KVMIO,  0xae)
+#define KVM_SET_SLAVE_CPU         _IO(KVMIO,  0xaf)
 
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 


Thanks,
-- 
Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory

