Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758761Ab0EXXIJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 19:08:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:55360 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758378Ab0EXXIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 19:08:06 -0400
Date: Mon, 24 May 2010 23:07:45 GMT
From: tip-bot for Gabor Gombas <gombasg@digikabel.hu>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       akpm@linux-foundation.org, stable@kernel.org, tglx@linutronix.de,
       hpa@linux.intel.com, gombasg@digikabel.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, stable@kernel.org, tglx@linutronix.de,
       hpa@linux.intel.com, gombasg@digikabel.hu
In-Reply-To: <201005241913.o4OJDIMM010877@imap1.linux-foundation.org>
References: <201005241913.o4OJDIMM010877@imap1.linux-foundation.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, setup: Phoenix BIOS fixup is needed on Dell Inspiron Mini 1012
Message-ID: <tip-3d6e77a3ddb8e4156b89f4273ff8c7d37abaf781@git.kernel.org>
Git-Commit-ID: 3d6e77a3ddb8e4156b89f4273ff8c7d37abaf781
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 24 May 2010 23:07:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3d6e77a3ddb8e4156b89f4273ff8c7d37abaf781
Gitweb:     http://git.kernel.org/tip/3d6e77a3ddb8e4156b89f4273ff8c7d37abaf781
Author:     Gabor Gombas <gombasg@digikabel.hu>
AuthorDate: Mon, 24 May 2010 12:13:18 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 24 May 2010 13:33:14 -0700

x86, setup: Phoenix BIOS fixup is needed on Dell Inspiron Mini 1012

The low-memory corruption checker triggers during suspend/resume, so we
need to reserve the low 64k.  Don't be fooled that the BIOS identifies
itself as "Dell Inc.", it's still Phoenix BIOS.

[ hpa: I think we blacklist almost every BIOS in existence.  We should
either change this to a whitelist or just make it unconditional. ]

Signed-off-by: Gabor Gombas <gombasg@digikabel.hu>
LKML-Reference: <201005241913.o4OJDIMM010877@imap1.linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: <stable@kernel.org>
---
 arch/x86/kernel/setup.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index e802989..b4ae4ac 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -676,6 +676,17 @@ static struct dmi_system_id __initdata bad_bios_dmi_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "DG45FC"),
 		},
 	},
+	/*
+	 * The Dell Inspiron Mini 1012 has DMI_BIOS_VENDOR = "Dell Inc.", so
+	 * match on the product name.
+	 */
+	{
+		.callback = dmi_low_memory_corruption,
+		.ident = "Phoenix BIOS",
+		.matches = {
+			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 1012"),
+		},
+	},
 #endif
 	{}
 };
