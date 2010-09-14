Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639Ab0INWYg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 18:24:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56269 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753779Ab0INWYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 18:24:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 1/2] PM / Hibernate: Improve comments in hibernate_preallocate_memory()
Date: Wed, 15 Sep 2010 00:22:29 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc4-rjw+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>
References: <201009150021.45101.rjw@sisk.pl>
In-Reply-To: <201009150021.45101.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009150022.30031.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM / Hibernate: Improve comments in hibernate_preallocate_memory()

One comment in hibernate_preallocate_memory() is wrong, so fix it and
add one more comment to clarify the meaning of the fixed one.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/snapshot.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/power/snapshot.c
===================================================================
--- linux-2.6.orig/kernel/power/snapshot.c
+++ linux-2.6/kernel/power/snapshot.c
@@ -1318,12 +1318,14 @@ int hibernate_preallocate_memory(void)
 
 	/* Compute the maximum number of saveable pages to leave in memory. */
 	max_size = (count - (size + PAGES_FOR_IO)) / 2 - 2 * SPARE_PAGES;
+	/* Compute the desired number of image pages specified by image_size. */
 	size = DIV_ROUND_UP(image_size, PAGE_SIZE);
 	if (size > max_size)
 		size = max_size;
 	/*
-	 * If the maximum is not less than the current number of saveable pages
-	 * in memory, allocate page frames for the image and we're done.
+	 * If the desired number of image pages is at least as large as the
+	 * current number of saveable pages in memory, allocate page frames for
+	 * the image and we're done.
 	 */
 	if (size >= saveable) {
 		pages = preallocate_image_highmem(save_highmem);

