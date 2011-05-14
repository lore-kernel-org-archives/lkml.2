Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759272Ab1ENVfp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 17:35:45 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50431 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754544Ab1ENVfn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 17:35:43 -0400
Message-ID: <4DCEF61B.5000303@cn.fujitsu.com>
Date: Sun, 15 May 2011 05:37:31 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 3/7] KVM: fix uninitialized warning
References: <4DCEF5B1.3050706@cn.fujitsu.com>
In-Reply-To: <4DCEF5B1.3050706@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-05-15 05:35:54,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-05-15 05:35:54
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix:

 warning: ‘cs_sel’ may be used uninitialized in this function
 warning: ‘ss_sel’ may be used uninitialized in this function

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/emulate.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 291c872..ea32340 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2015,7 +2015,7 @@ emulate_sysexit(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 	struct desc_struct cs, ss;
 	u64 msr_data;
 	int usermode;
-	u16 cs_sel, ss_sel;
+	u16 cs_sel = 0, ss_sel = 0;
 
 	/* inject #GP if in real mode or Virtual 8086 mode */
 	if (ctxt->mode == X86EMUL_MODE_REAL ||
-- 
1.7.4.4

