Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089Ab1AZK6n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 05:58:43 -0500
Received: from hera.kernel.org ([140.211.167.34]:37521 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752134Ab1AZK6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 05:58:42 -0500
Date: Wed, 26 Jan 2011 10:58:19 GMT
From: tip-bot for Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: linux-kernel@vger.kernel.org, hans.rosenfeld@amd.com, hpa@zytor.com,
        mingo@redhat.com, andreas.herrmann3@amd.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, hans.rosenfeld@amd.com,
        linux-kernel@vger.kernel.org, andreas.herrmann3@amd.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1295881543-572552-3-git-send-email-hans.rosenfeld@amd.com>
References: <1295881543-572552-3-git-send-email-hans.rosenfeld@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/amd-nb] x86, amd: Enable L3 cache index disable on family 0x15
Message-ID: <tip-b453de02b786c63b8928ec822401468131db0a9b@git.kernel.org>
Git-Commit-ID: b453de02b786c63b8928ec822401468131db0a9b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 26 Jan 2011 10:58:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b453de02b786c63b8928ec822401468131db0a9b
Gitweb:     http://git.kernel.org/tip/b453de02b786c63b8928ec822401468131db0a9b
Author:     Hans Rosenfeld <hans.rosenfeld@amd.com>
AuthorDate: Mon, 24 Jan 2011 16:05:41 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 26 Jan 2011 08:28:23 +0100

x86, amd: Enable L3 cache index disable on family 0x15

AMD family 0x15 CPUs support L3 cache index disable, so enable
it on them.

Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: <andreas.herrmann3@amd.com>
LKML-Reference: <1295881543-572552-3-git-send-email-hans.rosenfeld@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/amd_nb.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
index 0a99f71..a4f394c 100644
--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -85,6 +85,9 @@ int amd_cache_northbridges(void)
 	     boot_cpu_data.x86_mask >= 0x1))
 		amd_northbridges.flags |= AMD_NB_L3_INDEX_DISABLE;
 
+	if (boot_cpu_data.x86 == 0x15)
+		amd_northbridges.flags |= AMD_NB_L3_INDEX_DISABLE;
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(amd_cache_northbridges);
