Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545Ab1DGSdi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 14:33:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:22650 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886Ab1DGSdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 14:33:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,317,1299484800"; 
   d="scan'208";a="730457027"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        LKML <linux-kernel@vger.kernel.org>, Feng Tang <feng.tang@intel.com>,
        Alan Cox <alan@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH] x86/mrst: correct pin to irq mapping
Date: Thu,  7 Apr 2011 11:32:52 -0700
Message-Id: <1302201172-1254-1-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set mp_bus_not_pci bit to allow 1:1 mapping of pin2irq on Moorestown.
Refer to discussion in:
https://lkml.org/lkml/2010/6/10/70

Suggested-by: "Eric W. Biederman" <ebiederm@xmission.com>

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 arch/x86/platform/mrst/mrst.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
index 5c0207b..d51d644 100644
--- a/arch/x86/platform/mrst/mrst.c
+++ b/arch/x86/platform/mrst/mrst.c
@@ -282,7 +282,7 @@ void __init x86_mrst_early_setup(void)
 	/* Avoid searching for BIOS MP tables */
 	x86_init.mpparse.find_smp_config = x86_init_noop;
 	x86_init.mpparse.get_smp_config = x86_init_uint_noop;
-
+	set_bit(0, mp_bus_not_pci);
 }
 
 /*
-- 
1.7.1

