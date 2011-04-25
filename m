Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331Ab1DYX1Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 19:27:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:37723 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755104Ab1DYX1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 19:27:23 -0400
Date: Mon, 25 Apr 2011 23:25:02 GMT
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-39b68976ac653cfdc7f872a293e8b7928de2dcc6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, thomas@m3y3r.de, hpa@zytor.com,
        mingo@redhat.com, chris@csamuel.org, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, thomas@m3y3r.de,
        linux-kernel@vger.kernel.org, chris@csamuel.org, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1303566747.12067.10.camel@localhost.localdomain>
References: <1303566747.12067.10.camel@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, setup: When probing memory with e801, use ax/bx as a pair
Git-Commit-ID: 39b68976ac653cfdc7f872a293e8b7928de2dcc6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 25 Apr 2011 23:25:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  39b68976ac653cfdc7f872a293e8b7928de2dcc6
Gitweb:     http://git.kernel.org/tip/39b68976ac653cfdc7f872a293e8b7928de2dcc6
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Mon, 25 Apr 2011 14:52:37 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 25 Apr 2011 14:52:37 -0700

x86, setup: When probing memory with e801, use ax/bx as a pair

When we use BIOS function e801 to probe memory, we should use ax/bx
(or cx/dx) as a pair, not mix and match.  This was a typo during the
translation from assembly code, and breaks at least one set of
machines in the field (which return cx = dx = 0).

Reported-and-tested-by: Chris Samuel <chris@csamuel.org>
Fix-proposed-by: Thomas Meyer <thomas@m3y3r.de>
Link: http://lkml.kernel.org/r/1303566747.12067.10.camel@localhost.localdomain
---
 arch/x86/boot/memory.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/boot/memory.c b/arch/x86/boot/memory.c
index cae3feb..db75d07 100644
--- a/arch/x86/boot/memory.c
+++ b/arch/x86/boot/memory.c
@@ -91,7 +91,7 @@ static int detect_memory_e801(void)
 	if (oreg.ax > 15*1024) {
 		return -1;	/* Bogus! */
 	} else if (oreg.ax == 15*1024) {
-		boot_params.alt_mem_k = (oreg.dx << 6) + oreg.ax;
+		boot_params.alt_mem_k = (oreg.bx << 6) + oreg.ax;
 	} else {
 		/*
 		 * This ignores memory above 16MB if we have a memory
