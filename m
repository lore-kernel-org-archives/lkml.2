Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395Ab2KVUs7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:48:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37038 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964892Ab2KVS6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:58:42 -0500
Date: Wed, 21 Nov 2012 17:46:46 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-dd7dfad7fb297b1746bcdbebbdc970d723a635bd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1353123563-3103-10-git-send-email-yinghai@kernel.org>
References: <1353123563-3103-10-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, mm: Set memblock initial limit to 1M
Git-Commit-ID: dd7dfad7fb297b1746bcdbebbdc970d723a635bd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 21 Nov 2012 17:46:52 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dd7dfad7fb297b1746bcdbebbdc970d723a635bd
Gitweb:     http://git.kernel.org/tip/dd7dfad7fb297b1746bcdbebbdc970d723a635bd
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 16 Nov 2012 19:38:46 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sat, 17 Nov 2012 11:59:07 -0800

x86, mm: Set memblock initial limit to 1M

memblock_x86_fill() could double memory array.
If we set memblock.current_limit to 512M, so memory array could be around 512M.
So kdump will not get big range (like 512M) under 1024M.

Try to put it down under 1M, it would use about 4k or so, and that is limited.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1353123563-3103-10-git-send-email-yinghai@kernel.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/setup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
