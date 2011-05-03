Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab1ECPKD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 11:10:03 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:16238 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab1ECPKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 11:10:00 -0400
Subject: Re: [PATCH] drivers/acpi/utils.c: Fixed coding style issues
From: Karthigan Srinivasan <karthigan.srinivasan@hp.com>
To: Joe Perches <joe@perches.com>, Len Brown <lenb@kernel.org>,
        Nicolas Kaiser <nikai@nikai.net>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1304382405.7792.53.camel@Joe-Laptop>
References: <1303341624.11397.2.camel@ks-ubuntu>
	 <20110421102815.5abf133e@absol.kitzblitz>
	 <1303402099.11855.9.camel@ks-ubuntu>  <1304374605.1619.4.camel@ks-ubuntu>
	 <1304382405.7792.53.camel@Joe-Laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 May 2011 10:09:57 -0500
Message-ID: <1304435397.2497.4.camel@ks-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > -		//kfree(list->handles);
> > +		/* kfree(list->handles); */

> Just delete the line instead.

Len, Joe, Nicolas - re-submitting patch with above recommended change. 

Best Regards,
Karthigan.

=========

Fixed brace, comment, and label coding style issues.

Signed-off-by: Karthigan Srinivasan <karthigan.srinivasan@hp.com>
---
 drivers/acpi/utils.c |   19 +++++++------------
 1 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/acpi/utils.c b/drivers/acpi/utils.c
index b002a47..91289d4 100644
--- a/drivers/acpi/utils.c
+++ b/drivers/acpi/utils.c
@@ -99,9 +99,8 @@ acpi_extract_package(union acpi_object *package,
 
 		union acpi_object *element = &(package->package.elements[i]);
 
-		if (!element) {
+		if (!element)
 			return AE_BAD_DATA;
-		}
 
 		switch (element->type) {
 
@@ -185,9 +184,8 @@ acpi_extract_package(union acpi_object *package,
 		u8 **pointer = NULL;
 		union acpi_object *element = &(package->package.elements[i]);
 
-		if (!element) {
+		if (!element)
 			return AE_BAD_DATA;
-		}
 
 		switch (element->type) {
 
@@ -303,9 +301,8 @@ acpi_evaluate_reference(acpi_handle handle,
 	u32 i = 0;
 
 
-	if (!list) {
+	if (!list)
 		return AE_BAD_PARAMETER;
-	}
 
 	/* Evaluate object. */
 
@@ -337,9 +334,9 @@ acpi_evaluate_reference(acpi_handle handle,
 		goto end;
 	}
 
-	if (package->package.count > ACPI_MAX_HANDLES) {
+	if (package->package.count > ACPI_MAX_HANDLES)
 		return AE_NO_MEMORY;
-	}
+
 	list->count = package->package.count;
 
 	/* Extract package data. */
@@ -370,11 +367,9 @@ acpi_evaluate_reference(acpi_handle handle,
 				  list->handles[i]));
 	}
 
-      end:
-	if (ACPI_FAILURE(status)) {
+end:
+	if (ACPI_FAILURE(status))
 		list->count = 0;
-		//kfree(list->handles);
-	}
 
 	kfree(buffer.pointer);
 
-- 
1.7.1





