Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755Ab1K0V01 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 16:26:27 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:44007 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755414Ab1K0V0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 16:26:25 -0500
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Date: Sun, 27 Nov 2011 22:26:20 +0100
From: "Witold Szczeponik" <Witold.Szczeponik@gmx.net>
Message-ID: <20111127212620.268500@gmx.net>
MIME-Version: 1.0
Subject: [PATCH, trivial] PNP: Use constant PNP_ID_LEN instead of literal
 number
To: linux-acpi@vger.kernel.org
X-Authenticated: #787645
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX18R6aRHwNgRFdOtvxcdEoNZTwGWi1PT7qZpE5PlP/
 ci9r9t035b5thFrh/dCiGV1415Wi6sr3IShA== 
Content-Transfer-Encoding: 8bit
X-GMX-UID: y5LneqkiRkkNSsl+f2Rq+cpudWkvKJOo
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The attached patch uses the constant PNP_ID_LEN instead of using a 
literal number for the length of a PNP ID in the scope of PNP quirks.

As a consequence, all IDs used in PNP quirks (c.f. "drivers/pnp/quirks.c") 
are now zero-terminated and standard functions that depend on the IDs 
to be zero-terminated now work reliably (c.f. "strlen" in "drivers/pnp/driver.c", 
function "compare_pnp_id"). 


The patch is applied against 3.1. 


Signed-off-by: Witold Szczeponik <Witold.Szczeponik@gmx.net>



Index: linux/include/linux/pnp.h
===================================================================
--- linux.orig/include/linux/pnp.h
+++ linux/include/linux/pnp.h
@@ -295,7 +295,7 @@ static inline void pnp_set_drvdata(struc
 }
 
 struct pnp_fixup {
-	char id[7];
+	char id[PNP_ID_LEN];
 	void (*quirk_function) (struct pnp_dev * dev);	/* fixup function */
 };
 

-- 
NEU: FreePhone - 0ct/min Handyspartarif mit Geld-zurück-Garantie!		
Jetzt informieren: http://www.gmx.net/de/go/freephone
