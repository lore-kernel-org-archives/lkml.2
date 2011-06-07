Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab1FGNEf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 09:04:35 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56729 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753221Ab1FGNEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 09:04:34 -0400
Message-ID: <4DEE2259.7080009@cn.fujitsu.com>
Date: Tue, 07 Jun 2011 21:06:33 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 13/15] KVM: VMX: modify the default value of nontrap shadow
 pte
References: <4DEE205E.8000601@cn.fujitsu.com>
In-Reply-To: <4DEE205E.8000601@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-07 21:04:16,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-07 21:04:17,
	Serialize complete at 2011-06-07 21:04:17
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify the default value to identify nontrap shadow pte and mmio shadow pte
whill will be introduced in later patch

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/vmx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 20dbf7f..8c3d343 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -7110,7 +7110,7 @@ static int __init vmx_init(void)
 		kvm_disable_tdp();
 
 	if (bypass_guest_pf)
-		kvm_mmu_set_nonpresent_ptes(~0xffeull, 0ull);
+		kvm_mmu_set_nonpresent_ptes(0xfull << 49 | 1ull, 0ull);
 
 	return 0;
 
-- 
1.7.4.4

