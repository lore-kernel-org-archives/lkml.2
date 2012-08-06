Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802Ab2HFJYO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 05:24:14 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:42441 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755771Ab2HFJYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 05:24:10 -0400
X-IronPort-AV: E=Sophos;i="4.77,719,1336320000"; 
   d="scan'208";a="5560154"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC V3 PATCH 22/25] x86: use memblock_set_current_limit() to set memblock.current_limit
Date: Mon, 6 Aug 2012 17:23:16 +0800
Message-Id: <1344244999-5081-23-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1344244999-5081-1-git-send-email-laijs@cn.fujitsu.com>
References: <1343887288-8866-1-git-send-email-laijs@cn.fujitsu.com>
 <1344244999-5081-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/06 17:24:33,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/06 17:24:34,
	Serialize complete at 2012/08/06 17:24:34
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

memblock.current_limit is set directly though memblock_set_current_limit()
is prepared. So fix it.

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 arch/x86/kernel/setup.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index f4b9b80..bb9d9f8 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -889,7 +889,7 @@ void __init setup_arch(char **cmdline_p)
 
 	cleanup_highmap();
 
-	memblock.current_limit = get_max_mapped();
+	memblock_set_current_limit(get_max_mapped());
 	memblock_x86_fill();
 
 	/*
@@ -925,7 +925,7 @@ void __init setup_arch(char **cmdline_p)
 		max_low_pfn = max_pfn;
 	}
 #endif
-	memblock.current_limit = get_max_mapped();
+	memblock_set_current_limit(get_max_mapped());
 	dma_contiguous_reserve(0);
 
 	/*
-- 
1.7.4.4

