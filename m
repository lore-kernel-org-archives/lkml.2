Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab2KLVTa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 16:19:30 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:24491 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851Ab2KLVT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 16:19:27 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 09/46] x86, mm: Set memblock initial limit to 1M
Date: Mon, 12 Nov 2012 13:18:05 -0800
Message-Id: <1352755122-25660-10-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1352755122-25660-1-git-send-email-yinghai@kernel.org>
References: <20121112193044.GA11615@phenom.dumpdata.com>
 <1352755122-25660-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memblock_x86_fill() could double memory array.
If we set memblock.current_limit to 512M, so memory array could be around 512M.
So kdump will not get big range (like 512M) under 1024M.

Try to put it down under 1M, it would use about 4k or so, and that is limited.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/setup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 23b079f..4bd8921 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -890,7 +890,7 @@ void __init setup_arch(char **cmdline_p)
 
 	cleanup_highmap();
 
-	memblock.current_limit = get_max_mapped();
+	memblock.current_limit = ISA_END_ADDRESS;
 	memblock_x86_fill();
 
 	/*
-- 
1.7.7

