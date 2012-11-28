Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932654Ab2K1V4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 16:56:22 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:44971 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756178Ab2K1Vsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 16:48:46 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v9 09/46] x86, mm: Set memblock initial limit to 1M
Date: Wed, 28 Nov 2012 13:47:20 -0800
Message-Id: <1354139277-17376-10-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1354139277-17376-1-git-send-email-yinghai@kernel.org>
References: <1354139277-17376-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memblock_x86_fill() could double memory array.
If we set memblock.current_limit to 512M, so memory array could be around 512M.
So kdump will not get big range (like 512M) under 1024M.

Try to put it down under 1M, it would use about 4k or so, and that is limited.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
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

