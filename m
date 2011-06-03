Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab1FCOEL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 10:04:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:43737 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086Ab1FCOEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 10:04:07 -0400
Date: Fri, 3 Jun 2011 14:03:52 GMT
From: tip-bot for Jack Steiner <steiner@sgi.com>
Message-ID: <tip-6885685923ee786f26e7b170e3b961ac0fa14037@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        steiner@sgi.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        steiner@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110602195943.GA27079@sgi.com>
References: <20110602195943.GA27079@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/uv] x66, UV: Enable 64-bit ACPI MFCG support for SGI UV2 platform
Git-Commit-ID: 6885685923ee786f26e7b170e3b961ac0fa14037
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 03 Jun 2011 14:03:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6885685923ee786f26e7b170e3b961ac0fa14037
Gitweb:     http://git.kernel.org/tip/6885685923ee786f26e7b170e3b961ac0fa14037
Author:     Jack Steiner <steiner@sgi.com>
AuthorDate: Thu, 2 Jun 2011 14:59:43 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 3 Jun 2011 16:00:03 +0200

x66, UV: Enable 64-bit ACPI MFCG support for SGI UV2 platform

Enable 64-bit ACPI MFCG support for SGI UV2 platform. The check
is similar to the check on UV1. UV2 has a different oem_id
string.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Link: http://lkml.kernel.org/r/20110602195943.GA27079@sgi.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/pci/mmconfig-shared.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
index 750c346..301e325 100644
--- a/arch/x86/pci/mmconfig-shared.c
+++ b/arch/x86/pci/mmconfig-shared.c
@@ -519,7 +519,8 @@ static int __init acpi_mcfg_check_entry(struct acpi_table_mcfg *mcfg,
 	if (cfg->address < 0xFFFFFFFF)
 		return 0;
 
-	if (!strcmp(mcfg->header.oem_id, "SGI"))
+	if (!strcmp(mcfg->header.oem_id, "SGI") ||
+			!strcmp(mcfg->header.oem_id, "SGI2"))
 		return 0;
 
 	if (mcfg->header.revision >= 1) {
