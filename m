Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493Ab1KXKJU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 05:09:20 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44443 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab1KXKJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 05:09:18 -0500
Message-ID: <4ECE17C7.2080801@gmail.com>
Date: Thu, 24 Nov 2011 18:09:11 +0800
From: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH] KVM: IA64: fix struct redefinition
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>

There is the same struct definition in ia64 and kvm common code:
arch/ia64/kvm//kvm-ia64.c: At top level:
arch/ia64/kvm//kvm-ia64.c:777:8: error: redefinition of ‘struct kvm_io_range’
include/linux/kvm_host.h:62:8: note: originally defined here

So, rename kvm_io_range to kvm_ia64_io_range in ia64 code

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/ia64/kvm/kvm-ia64.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index 92d9f1e..4050520 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -774,13 +774,13 @@ struct kvm *kvm_arch_alloc_vm(void)
 	return kvm;
 }

-struct kvm_io_range {
+struct kvm_ia64_io_range {
 	unsigned long start;
 	unsigned long size;
 	unsigned long type;
 };

-static const struct kvm_io_range io_ranges[] = {
+static const struct kvm_ia64_io_range io_ranges[] = {
 	{VGA_IO_START, VGA_IO_SIZE, GPFN_FRAME_BUFFER},
 	{MMIO_START, MMIO_SIZE, GPFN_LOW_MMIO},
 	{LEGACY_IO_START, LEGACY_IO_SIZE, GPFN_LEGACY_IO},
-- 
1.7.7.3
