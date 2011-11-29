Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932770Ab1LERbo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 12:31:44 -0500
Received: from www17.your-server.de ([213.133.104.17]:50153 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932728Ab1LERbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 12:31:43 -0500
Subject: [PATCH] cifs: Use kcalloc instead of kzalloc to allocate array
From: Thomas Meyer <thomas@m3y3r.de>
To: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Tue, 29 Nov 2011 22:08:00 +0100
Message-ID: <1322600880.1534.344.camel@localhost.localdomain>
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The advantage of kcalloc is, that will prevent integer overflows which could
result from the multiplication of number of elements and size and it is also
a bit nicer to read.

The semantic patch that makes this change is available
in https://lkml.org/lkml/2011/11/25/107

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
--- a/fs/cifs/cifssmb.c 2011-11-13 11:07:56.343959560 +0100
+++ b/fs/cifs/cifssmb.c 2011-11-28 19:47:15.006997976 +0100
@@ -2140,7 +2140,7 @@ cifs_async_writev(struct cifs_writedata
 		goto async_writev_out;
 
 	/* 1 iov per page + 1 for header */
-	iov = kzalloc((wdata->nr_pages + 1) * sizeof(*iov), GFP_NOFS);
+	iov = kcalloc(wdata->nr_pages + 1, sizeof(*iov), GFP_NOFS);
 	if (iov == NULL) {
 		rc = -ENOMEM;
 		goto async_writev_out;
