Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab2HUB2O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 21:28:14 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:42065 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab2HUB1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 21:27:35 -0400
X-IronPort-AV: E=Sophos;i="4.77,799,1336348800"; 
   d="scan'208";a="14095098"
From: Attilio Rao <attilio.rao@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>, <xen-devel@lists.xensource.com>
CC: Attilio Rao <attilio.rao@citrix.com>
Subject: [PATCH 5/5] X86/XEN: Add few lines explaining simple semantic for x86_init.paging.pagetable_init PVOPS
Date: Tue, 21 Aug 2012 02:14:06 +0100
Message-ID: <1345511646-12427-6-git-send-email-attilio.rao@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1345511646-12427-1-git-send-email-attilio.rao@citrix.com>
References: <1345511646-12427-1-git-send-email-attilio.rao@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Explain the purpose of the PVOPS
- Report execution constraints

Signed-off-by: Attilio Rao <attilio.rao@citrix.com>
---
 arch/x86/include/asm/x86_init.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 995ea5c..7ea4186 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -82,6 +82,11 @@ struct x86_init_mapping {
 /**
  * struct x86_init_paging - platform specific paging functions
  * @pagetable_init:		platform specific paging initialization call
+ *
+ * It does setup the kernel pagetables and prepares accessors functions to
+ * manipulate them.
+ * It must be called once, during the boot sequence and after the direct
+ * mapping for phys memory is setup.
  */
 struct x86_init_paging {
 	void (*pagetable_init)(void);
-- 
1.7.2.5

