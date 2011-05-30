Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872Ab1E3ULZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 16:11:25 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59357 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753064Ab1E3ULX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 16:11:23 -0400
From: Borislav Petkov <bp@alien8.de>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Subject: [PATCH] kvm: Fix build warnings
Date: Mon, 30 May 2011 22:11:17 +0200
Message-Id: <1306786278-12219-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.7.5.rc1.16.g9db1
In-Reply-To: <20110530124600.GB494@eferding.osrc.amd.com>
References: <20110530124600.GB494@eferding.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3.0-rc1 I get

In file included from arch/x86/kvm/mmu.c:2856:
arch/x86/kvm/paging_tmpl.h: In function ‘paging32_walk_addr_generic’:
arch/x86/kvm/paging_tmpl.h:124: warning: ‘ptep_user’ may be used uninitialized in this function
In file included from arch/x86/kvm/mmu.c:2852:
arch/x86/kvm/paging_tmpl.h: In function ‘paging64_walk_addr_generic’:
arch/x86/kvm/paging_tmpl.h:124: warning: ‘ptep_user’ may be used uninitialized in this function

caused by 6e2ca7d1802bf8ed9908435e34daa116662e7790. According to Takuya
Yoshikawa, ptep_user won't be used uninitialized so shut up gcc.

Cc: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Link: http://lkml.kernel.org/r/20110530094604.GC21833@liondog.tnic
Signed-off-by: Borislav Petkov <bp@alien8.de>
---
 arch/x86/kvm/paging_tmpl.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 6c4dc01..9d03ad4 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -121,7 +121,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 				    gva_t addr, u32 access)
 {
 	pt_element_t pte;
-	pt_element_t __user *ptep_user;
+	pt_element_t __user *uninitialized_var(ptep_user);
 	gfn_t table_gfn;
 	unsigned index, pt_access, uninitialized_var(pte_access);
 	gpa_t pte_gpa;
-- 
1.7.5.rc1.16.g9db1

