Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964802Ab1C3WLz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:11:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:9758 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933104Ab1C3VGC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:06:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621235702"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: hmh@hmh.eng.br, mjg@redhat.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [5/275] thinkpad-acpi: avoid keymap pitfall
Message-Id: <20110330210358.EE0253E1A06@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:03:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

[ upstream commit fc6e756894b703952fd277a1f98a5d93e7ba847a ]

Change the code so that it will use the correct size for keymap entries.
Do it in a way that makes it harder to screw it up in the future.

Reported-by: Jaime Velasco Juan <jsagarribay@gmail.com>
Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/platform/x86/thinkpad_acpi.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/drivers/platform/x86/thinkpad_acpi.c
===================================================================
--- linux-2.6.35.y.orig/drivers/platform/x86/thinkpad_acpi.c	2011-03-29 23:02:58.202346167 -0700
+++ linux-2.6.35.y/drivers/platform/x86/thinkpad_acpi.c	2011-03-29 23:02:58.223345630 -0700
@@ -3093,7 +3093,8 @@
 	TPACPI_Q_IBM('1', 'D', TPACPI_HK_Q_INIMASK), /* X22, X23, X24 */
 };
 
-typedef u16 tpacpi_keymap_t[TPACPI_HOTKEY_MAP_LEN];
+typedef u16 tpacpi_keymap_entry_t;
+typedef tpacpi_keymap_entry_t tpacpi_keymap_t[TPACPI_HOTKEY_MAP_LEN];
 
 static int __init hotkey_init(struct ibm_init_struct *iibm)
 {
@@ -3230,7 +3231,7 @@
 	};
 
 #define TPACPI_HOTKEY_MAP_SIZE		sizeof(tpacpi_keymap_t)
-#define TPACPI_HOTKEY_MAP_TYPESIZE	sizeof(tpacpi_keymap_t[0])
+#define TPACPI_HOTKEY_MAP_TYPESIZE	sizeof(tpacpi_keymap_entry_t)
 
 	int res, i;
 	int status;
