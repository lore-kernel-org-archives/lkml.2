Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab2GXNGA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 09:06:00 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:16304 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753726Ab2GXNF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 09:05:59 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhgFAGGdDlBbdWOb/2dsb2JhbABFhSxEs3uBB4IhAQUjDwFGECUCJgICVwcSiBGoLZMggSCKM4VZgRIDlUmQDYJhgVQ
X-IronPort-AV: E=Sophos;i="4.77,646,1336341600"; 
   d="scan'208";a="933905257"
From: =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
To: cascardo@holoscopio.com, don@syst.com.br, mjg@redhat.com
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
Subject: [PATCH] classmate-laptop: Fix extra keys hardware id.
Date: Tue, 24 Jul 2012 15:05:25 +0200
Message-Id: <1343135125-18733-1-git-send-email-magomez@igalia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20120724030946.GA2742@nautilus.holoscopio.com>
References: <20120724030946.GA2742@nautilus.holoscopio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since ACPI devices ids were changed to use always upper-case letters, the ACPI
id of the extra keys (FNBT0000) was not maching the one defined in the driver
(FnBT0000), causing the extra keys not to work.

The patch replaces the driver id with the one reported by ACPI, fixing the
problem.

Signed-off-by: Miguel Gómez <magomez@igalia.com>
---
 drivers/platform/x86/classmate-laptop.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/classmate-laptop.c b/drivers/platform/x86/classmate-laptop.c
index e2230a2..43e6e54 100644
--- a/drivers/platform/x86/classmate-laptop.c
+++ b/drivers/platform/x86/classmate-laptop.c
@@ -39,7 +39,7 @@ struct cmpc_accel {
 #define CMPC_ACCEL_HID		"ACCE0000"
 #define CMPC_TABLET_HID		"TBLT0000"
 #define CMPC_IPML_HID	"IPML200"
-#define CMPC_KEYS_HID		"FnBT0000"
+#define CMPC_KEYS_HID		"FNBT0000"
 
 /*
  * Generic input device code.
-- 
1.7.9.5

