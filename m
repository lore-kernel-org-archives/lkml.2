Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab0DFKdv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 06:33:51 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57951 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752700Ab0DFKdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 06:33:43 -0400
Message-ID: <4BBB0D71.8070409@cn.fujitsu.com>
Date: Tue, 06 Apr 2010 18:31:13 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] KVM MMU: remove unnecessary judgement
References: <4BBB0CF1.6040204@cn.fujitsu.com>
In-Reply-To: <4BBB0CF1.6040204@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After is_rsvd_bits_set() checks, EFER.NXE must be enabled if NX bit is seted

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/paging_tmpl.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 067797a..d9dea28 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -170,7 +170,7 @@ walk:
 			goto access_error;
 
 #if PTTYPE == 64
-		if (fetch_fault && is_nx(vcpu) && (pte & PT64_NX_MASK))
+		if (fetch_fault && (pte & PT64_NX_MASK))
 			goto access_error;
 #endif
 
-- 
1.6.1.2


