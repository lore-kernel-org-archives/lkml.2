Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab1GUSe2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 14:34:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:56922 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753271Ab1GUSe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 14:34:26 -0400
Date: Thu, 21 Jul 2011 18:34:19 GMT
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-d5492b2cd2127339d5b8509b3531f3f8b430a210@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        daniel.blueman@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        daniel.blueman@gmail.com, tglx@linutronix.de
In-Reply-To: <CAM9Y=f4fGkzhzYmzsDqDiDVtj_ox18+uSYR9Oc-Wb7eyX=dKBw@mail.gmail.com>
References: <CAM9Y=f4fGkzhzYmzsDqDiDVtj_ox18+uSYR9Oc-Wb7eyX=dKBw@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Make Dell Latitude E6420 use reboot=pci
Git-Commit-ID: d5492b2cd2127339d5b8509b3531f3f8b430a210
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Jul 2011 18:34:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d5492b2cd2127339d5b8509b3531f3f8b430a210
Gitweb:     http://git.kernel.org/tip/d5492b2cd2127339d5b8509b3531f3f8b430a210
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Thu, 21 Jul 2011 11:22:21 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 21 Jul 2011 11:22:21 -0700

x86: Make Dell Latitude E6420 use reboot=pci

Yet another variant of the Dell Latitude series which requires
reboot=pci.

Reported-by: Daniel J Blueman <daniel.blueman@gmail.com>
Link: http://lkml.kernel.org/r/CAM9Y%3Df4fGkzhzYmzsDqDiDVtj_ox18%2BuSYR9Oc-Wb7eyX%3DdKBw@mail.gmail.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/reboot.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 3dfd38f..9242436 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -435,6 +435,14 @@ static struct dmi_system_id __initdata pci_reboot_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude E5420"),
 		},
 	},
+	{	/* Handle problems with rebooting on the Latitude E6420. */
+		.callback = set_pci_reboot,
+		.ident = "Dell Latitude E6420",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude E6420"),
+		},
+	},
 	{ }
 };
 
