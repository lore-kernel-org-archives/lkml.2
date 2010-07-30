Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab0G3Hzw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 03:55:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:37876 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303Ab0G3Hzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 03:55:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,285,1278313200"; 
   d="scan'208";a="591234468"
Subject: [trival patch]x86: unmap vdso pages are missed
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Jul 2010 15:55:49 +0800
Message-ID: <1280476549.10564.2.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The memory hasn't been unmapped.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index ac74869..80f23ed 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -67,6 +67,7 @@ static int __init init_vdso_vars(void)
 	*(typeof(__ ## x) **) var_ref(VDSO64_SYMBOL(vbase, x), #x) = &__ ## x;
 #include "vextern.h"
 #undef VEXTERN
+	vunmap(vbase);
 	return 0;
 
  oom:


