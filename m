Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199Ab0D3Q7l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 12:59:41 -0400
Received: from smtp.nokia.com ([192.100.122.230]:59725 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757835Ab0D3Q7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 12:59:30 -0400
From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
       Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 10/10] drivers: acpi: don't use own implementation of hex_to_bin()
Date: Fri, 30 Apr 2010 12:34:09 +0300
Message-Id: <a12f097d2203c5b49a239ae33d4228ce6a652c2d.1272617852.git.ext-andriy.shevchenko@nokia.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <e1305499edede753c119de13fb1536387cb73532.1272617852.git.ext-andriy.shevchenko@nokia.com>
References: <cover.1272617852.git.ext-andriy.shevchenko@nokia.com>
 <d5c4e26cc74458dd77102c4274d3260149717328.1272617852.git.ext-andriy.shevchenko@nokia.com>
 <1a326db89859eec030859e4905c515e0817bd2ea.1272617852.git.ext-andriy.shevchenko@nokia.com>
 <d4a1df27bf2c83ee84c3d74bcff0f2768146eb7e.1272617852.git.ext-andriy.shevchenko@nokia.com>
 <c1ca828fb308042aa32428b345abcb43ccb02c39.1272617852.git.ext-andriy.shevchenko@nokia.com>
 <2eb558b7b0b20dfea0b61223db6146cb8fdbe52d.1272617852.git.ext-andriy.shevchenko@nokia.com>
 <7cd86c01ad4a376fb8a48ffe307ce7c0510cecc0.1272617852.git.ext-andriy.shevchenko@nokia.com>
 <d6886a8b94bf8726d7bde807b3ca19f65739ce4d.1272617852.git.ext-andriy.shevchenko@nokia.com>
 <ce5ee38b2d01568cd56ffc9598d7ceaa24738e65.1272617852.git.ext-andriy.shevchenko@nokia.com>
 <e1305499edede753c119de13fb1536387cb73532.1272617852.git.ext-andriy.shevchenko@nokia.com>
In-Reply-To: <cover.1272617852.git.ext-andriy.shevchenko@nokia.com>
References: <cover.1272617852.git.ext-andriy.shevchenko@nokia.com>
X-OriginalArrivalTime: 30 Apr 2010 09:34:10.0099 (UTC) FILETIME=[49723030:01CAE848]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of own implementation of hex_to_bin(). It requires to have hex_to_bin()
introduced by starter patch in the series.

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/acpi/bus.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 37132dc..f36ee6f 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -363,11 +363,6 @@ static void acpi_print_osc_error(acpi_handle handle,
 	printk("\n");
 }
 
-static u8 hex_val(unsigned char c)
-{
-	return isdigit(c) ? c - '0' : toupper(c) - 'A' + 10;
-}
-
 static acpi_status acpi_str_to_uuid(char *str, u8 *uuid)
 {
 	int i;
@@ -384,8 +379,8 @@ static acpi_status acpi_str_to_uuid(char *str, u8 *uuid)
 			return AE_BAD_PARAMETER;
 	}
 	for (i = 0; i < 16; i++) {
-		uuid[i] = hex_val(str[opc_map_to_uuid[i]]) << 4;
-		uuid[i] |= hex_val(str[opc_map_to_uuid[i] + 1]);
+		uuid[i] = hex_to_bin(str[opc_map_to_uuid[i]]) << 4;
+		uuid[i] |= hex_to_bin(str[opc_map_to_uuid[i] + 1]);
 	}
 	return AE_OK;
 }
-- 
1.6.3.3

