Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622Ab0I2VOa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 17:14:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54556 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860Ab0I2VO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 17:14:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH] PM / Hibernate: Modify signature used to mark swap
Date: Wed, 29 Sep 2010 23:13:23 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc6-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Nigel Cunningham <nigel@tuxonice.net>, LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009292313.23601.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM / Hibernate: Modify signature used to mark swap

Since we are adding compression to the kernel's hibernate code,
change signature used by it to mark swap spaces, so that earlier
kernels don't attempt to restore compressed images they cannot
handle.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/swap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/kernel/power/swap.c
===================================================================
--- linux-2.6.orig/kernel/power/swap.c
+++ linux-2.6/kernel/power/swap.c
@@ -29,7 +29,7 @@
 
 #include "power.h"
 
-#define SWSUSP_SIG	"S1SUSPEND"
+#define HIBERNATE_SIG	"LINHIB0001"
 
 /*
  *	The swap map is a data structure used for keeping track of each page
@@ -195,7 +195,7 @@ static int mark_swapfiles(struct swap_ma
 	if (!memcmp("SWAP-SPACE",swsusp_header->sig, 10) ||
 	    !memcmp("SWAPSPACE2",swsusp_header->sig, 10)) {
 		memcpy(swsusp_header->orig_sig,swsusp_header->sig, 10);
-		memcpy(swsusp_header->sig,SWSUSP_SIG, 10);
+		memcpy(swsusp_header->sig, HIBERNATE_SIG, 10);
 		swsusp_header->image = handle->first_sector;
 		swsusp_header->flags = flags;
 		error = hib_bio_write_page(swsusp_resume_block,
@@ -916,7 +916,7 @@ int swsusp_check(void)
 		if (error)
 			goto put;
 
-		if (!memcmp(SWSUSP_SIG, swsusp_header->sig, 10)) {
+		if (!memcmp(HIBERNATE_SIG, swsusp_header->sig, 10)) {
 			memcpy(swsusp_header->sig, swsusp_header->orig_sig, 10);
 			/* Reset swap signature now */
 			error = hib_bio_write_page(swsusp_resume_block,
