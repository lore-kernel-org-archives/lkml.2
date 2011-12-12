Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466Ab1LLKOH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 05:14:07 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:16464 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161Ab1LLKOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 05:14:04 -0500
From: annie.li@oracle.com
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, jeremy@goop.org, paul.durrant@citrix.com,
        Ian.Campbell@citrix.com
Cc: kurt.hackel@oracle.com, annie.li@oracle.com
Subject: [PATCH V4 1/3] xen/granttable: Improve comments for function pointers
Date: Mon, 12 Dec 2011 18:13:57 +0800
Message-Id: <1323684837-5140-1-git-send-email-annie.li@oracle.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1323684792-5101-1-git-send-email-annie.li@oracle.com>
References: <1323684792-5101-1-git-send-email-annie.li@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090209.4EE5D3E8.0071,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Annie Li <annie.li@oracle.com>
---
 drivers/xen/grant-table.c |   48 ++++++++++++++++++++++----------------------
 1 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index bd325fd..1589ea1 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -76,50 +76,50 @@ static union {
 /*This is a structure of function pointers for grant table*/
 struct gnttab_ops {
 	/*
-	 * Mapping a list of frames for storing grant entries. First input
-	 * parameter is used to storing grant table address when grant table
-	 * being setup, second parameter is the number of frames to map grant
-	 * table. Returning GNTST_okay means success and negative value means
-	 * failure.
+	 * Mapping a list of frames for storing grant entries. Frames parameter
+	 * is used to store grant table address when grant table being setup,
+	 * nr_gframes is the number of frames to map grant table. Returning
+	 * GNTST_okay means success and negative value means failure.
 	 */
-	int (*map_frames)(unsigned long *, unsigned int);
+	int (*map_frames)(unsigned long *frames, unsigned int nr_gframes);
 	/*
 	 * Release a list of frames which are mapped in map_frames for grant
 	 * entry status.
 	 */
 	void (*unmap_frames)(void);
 	/*
-	 * Introducing a valid entry into the grant table, granting the frame
-	 * of this grant entry to domain for accessing, or transfering, or
-	 * transitively accessing. First input parameter is reference of this
-	 * introduced grant entry, second one is domid of granted domain, third
-	 * one is the frame to be granted, and the last one is status of the
-	 * grant entry to be updated.
+	 * Introducing a valid entry into the grant table, granting the frame of
+	 * this grant entry to domain for accessing or transfering. Ref
+	 * parameter is reference of this introduced grant entry, domid is id of
+	 * granted domain, frame is the page frame to be granted, and flags is
+	 * status of the grant entry to be updated.
 	 */
-	void (*update_entry)(grant_ref_t, domid_t, unsigned long, unsigned);
+	void (*update_entry)(grant_ref_t ref, domid_t domid,
+			     unsigned long frame, unsigned flags);
 	/*
-	 * Stop granting a grant entry to domain for accessing. First input
-	 * parameter is reference of a grant entry whose grant access will be
-	 * stopped, second one is not in use now. If the grant entry is
+	 * Stop granting a grant entry to domain for accessing. Ref parameter is
+	 * reference of a grant entry whose grant access will be stopped,
+	 * readonly is not in use in this function. If the grant entry is
 	 * currently mapped for reading or writing, just return failure(==0)
 	 * directly and don't tear down the grant access. Otherwise, stop grant
 	 * access for this entry and return success(==1).
 	 */
-	int (*end_foreign_access_ref)(grant_ref_t, int);
+	int (*end_foreign_access_ref)(grant_ref_t ref, int readonly);
 	/*
-	 * Stop granting a grant entry to domain for transfer. If tranfer has
-	 * not started, just reclaim the grant entry and return failure(==0).
-	 * Otherwise, wait for the transfer to complete and then return the
-	 * frame.
+	 * Stop granting a grant entry to domain for transfer. Ref parameter is
+	 * reference of a grant entry whose grant transfer will be stopped. If
+	 * tranfer has not started, just reclaim the grant entry and return
+	 * failure(==0). Otherwise, wait for the transfer to complete and then
+	 * return the frame.
 	 */
-	unsigned long (*end_foreign_transfer_ref)(grant_ref_t);
+	unsigned long (*end_foreign_transfer_ref)(grant_ref_t ref);
 	/*
-	 * Query the status of a grant entry. Input parameter is reference of
+	 * Query the status of a grant entry. Ref parameter is reference of
 	 * queried grant entry, return value is the status of queried entry.
 	 * Detailed status(writing/reading) can be gotten from the return value
 	 * by bit operations.
 	 */
-	int (*query_foreign_access)(grant_ref_t);
+	int (*query_foreign_access)(grant_ref_t ref);
 };
 
 static struct gnttab_ops *gnttab_interface;
-- 
1.7.6.4

