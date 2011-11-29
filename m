Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932757Ab1LERbh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 12:31:37 -0500
Received: from www17.your-server.de ([213.133.104.17]:50069 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932728Ab1LERbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 12:31:00 -0500
Subject: [PATCH] uwb: Use kcalloc instead of kzalloc to allocate array
From: Thomas Meyer <thomas@m3y3r.de>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Tue, 29 Nov 2011 22:08:00 +0100
Message-ID: <1322600880.1534.340.camel@localhost.localdomain>
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

diff -u -p a/drivers/uwb/est.c b/drivers/uwb/est.c
--- a/drivers/uwb/est.c 2011-11-13 11:07:53.010573682 +0100
+++ b/drivers/uwb/est.c 2011-11-28 19:50:26.200518093 +0100
@@ -184,7 +184,7 @@ int uwb_est_create(void)
 
 	uwb_est_size = 2;
 	uwb_est_used = 0;
-	uwb_est = kzalloc(uwb_est_size * sizeof(uwb_est[0]), GFP_KERNEL);
+	uwb_est = kcalloc(uwb_est_size, sizeof(uwb_est[0]), GFP_KERNEL);
 	if (uwb_est == NULL)
 		return -ENOMEM;
 
