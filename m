Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243Ab2KPPOs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 10:14:48 -0500
Received: from service87.mimecast.com ([91.220.42.44]:51006 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065Ab2KPPOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 10:14:46 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH] of/fdt: NULL-terminate the root node path
Date: Fri, 16 Nov 2012 15:14:38 +0000
Message-Id: <1353078878-13566-1-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.12.3
X-OriginalArrivalTime: 16 Nov 2012 15:14:44.0327 (UTC) FILETIME=[1BC72F70:01CDC40D]
X-MC-Unique: 112111615144503601
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id qAGFEpRK004808

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Commit 509b7455 (of/fdt: Don't copy garbage after "/" in root node path)
sets the path length to 0 to ignore any garbage after "/" in the root
node path. This has the side effect of also ignoring '\0' at the end of
the root node path. This patch sets the ignores the garbage by setting
the last character to '\0' and length to 1.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rob Herring <rob.herring@calxeda.com>
---

The patch is against linux-next, not sure whether mainline will get the
same commit number. Please feel free to fold it into the original patch,
whichever is easier. Without this I can't boot arm64, doesn't populate
the platform devices.

 drivers/of/fdt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 73fb8c0..d9b2207 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -186,7 +186,8 @@ static unsigned long unflatten_dt_node(struct boot_param_header *blob,
 			 */
 			fpsize = 1;
 			allocl = 2;
-			l = 0;
+			l = 1;
+			*pathp = '\0';
 		} else {
 			/* account for '/' and path size minus terminal 0
 			 * already in 'l'

