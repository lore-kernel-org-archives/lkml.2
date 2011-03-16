Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073Ab1CPN5M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 09:57:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:35830 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710Ab1CPN5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 09:57:09 -0400
Date: Wed, 16 Mar 2011 13:56:43 GMT
From: tip-bot for Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        f3d27b@gmail.com, akpm@linux-foundation.org, andreas.herrmann3@amd.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        f3d27b@gmail.com, andreas.herrmann3@amd.com, akpm@linux-foundation.org,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110315143137.GD29499@alberich.amd.com>
References: <20110315143137.GD29499@alberich.amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, quirk: Fix SB600 revision check
Message-ID: <tip-1d3e09a304e6c4e004ca06356578b171e8735d3c@git.kernel.org>
Git-Commit-ID: 1d3e09a304e6c4e004ca06356578b171e8735d3c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 16 Mar 2011 13:56:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1d3e09a304e6c4e004ca06356578b171e8735d3c
Gitweb:     http://git.kernel.org/tip/1d3e09a304e6c4e004ca06356578b171e8735d3c
Author:     Andreas Herrmann <andreas.herrmann3@amd.com>
AuthorDate: Tue, 15 Mar 2011 15:31:37 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Mar 2011 14:03:32 +0100

x86, quirk: Fix SB600 revision check

Commit 7f74f8f28a2bd9db9404f7d364e2097a0c42cc12
(x86 quirk: Fix polarity for IRQ0 pin2 override on SB800
systems) introduced a regression. It removed some SB600 specific
code to determine the revision ID without adapting a
corresponding revision ID check for SB600.

See this mail thread:

  http://marc.info/?l=linux-kernel&m=129980296006380&w=2

This patch adapts the corresponding check to cover all SB600
revisions.

Tested-by: Wang Lei <f3d27b@gmail.com>
Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: stable@kernel.org # 38.x, 37.x, 32.x
LKML-Reference: <20110315143137.GD29499@alberich.amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/early-quirks.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index 9efbdcc..3755ef4 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -159,7 +159,12 @@ static void __init ati_bugs_contd(int num, int slot, int func)
 	if (rev >= 0x40)
 		acpi_fix_pin2_polarity = 1;
 
-	if (rev > 0x13)
+	/*
+	 * SB600: revisions 0x11, 0x12, 0x13, 0x14, ...
+	 * SB700: revisions 0x39, 0x3a, ...
+	 * SB800: revisions 0x40, 0x41, ...
+	 */
+	if (rev >= 0x39)
 		return;
 
 	if (acpi_use_timer_override)
