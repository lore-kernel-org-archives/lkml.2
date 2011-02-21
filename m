Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776Ab1BUDvH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 22:51:07 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58525 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755703Ab1BUDvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 22:51:05 -0500
Message-ID: <4D61E147.8050602@cn.fujitsu.com>
Date: Mon, 21 Feb 2011 11:51:35 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH] kvm: better readability of efer_reserved_bits
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-21 11:50:03,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-21 11:50:03,
	Serialize complete at 2011-02-21 11:50:03
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


use EFER_SCE, EFER_LME and EFER_LMA instead of magic numbers.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bcc0efc..9d1d3f2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -81,9 +81,10 @@
  * - enable LME and LMA per default on 64 bit KVM
  */
 #ifdef CONFIG_X86_64
-static u64 __read_mostly efer_reserved_bits = 0xfffffffffffffafeULL;
+static
+u64 __read_mostly efer_reserved_bits = ~((u64)(EFER_SCE | EFER_LME | EFER_LMA));
 #else
-static u64 __read_mostly efer_reserved_bits = 0xfffffffffffffffeULL;
+static u64 __read_mostly efer_reserved_bits = ~((u64)EFER_SCE);
 #endif
 
 #define VM_STAT(x) offsetof(struct kvm, stat.x), KVM_STAT_VM
