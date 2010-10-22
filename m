Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751711Ab0JVIqG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 04:46:06 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59046 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751406Ab0JVIqE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 04:46:04 -0400
Message-ID: <4CC15051.3030207@cn.fujitsu.com>
Date: Fri, 22 Oct 2010 16:50:25 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH] KVM: mark the function 'inline' defined in .h file
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix:
arch/x86/include/asm/kvm_para.h:185: warning: ‘kvm_read_and_reset_pf_reason’ defined but not used
  CC [M]  arch/x86/kvm/x86.o
arch/x86/include/asm/kvm_para.h:185: warning: ‘kvm_read_and_reset_pf_reason’ defined but not used
  CC [M]  arch/x86/kvm/mmu.o
arch/x86/include/asm/kvm_para.h:185: warning: ‘kvm_read_and_reset_pf_reason’ defined but not used
  CC [M]  arch/x86/kvm/emulate.o

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/include/asm/kvm_para.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index d3a1a48..a427bf7 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -182,7 +182,7 @@ u32 kvm_read_and_reset_pf_reason(void);
 #define kvm_guest_init() do { } while (0)
 #define kvm_async_pf_task_wait(T) do {} while(0)
 #define kvm_async_pf_task_wake(T) do {} while(0)
-static u32 kvm_read_and_reset_pf_reason(void)
+static inline u32 kvm_read_and_reset_pf_reason(void)
 {
 	return 0;
 }
-- 
1.7.0.4
