Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760063Ab1EOPXY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 11:23:24 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49287 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756507Ab1EOPXV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 11:23:21 -0400
Message-ID: <4DCFF056.80608@cn.fujitsu.com>
Date: Sun, 15 May 2011 23:25:10 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 3/7] KVM: fix uninitialized warning
References: <4DCFEF3B.5060806@cn.fujitsu.com>
In-Reply-To: <4DCFEF3B.5060806@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-05-15 23:23:31,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-05-15 23:23:31
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

