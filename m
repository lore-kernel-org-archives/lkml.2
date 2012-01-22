Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275Ab2AVTD1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 14:03:27 -0500
Received: from www17.your-server.de ([213.133.104.17]:46619 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086Ab2AVTCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 14:02:47 -0500
Message-ID: <1327253413.1434.69.camel@localhost.localdomain>
Subject: [PATCH] crypto: Use ERR_CAST inlined function instead of
 ERR_PTR(PTR_ERR(..
From: Thomas Meyer <thomas@m3y3r.de>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 22 Jan 2012 18:30:13 +0100
Mime-Version: 1.0
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The semantic patch that makes this change is available
in scripts/coccinelle/api/err_cast.cocci.

More information about semantic patching is available at
http://coccinelle.lip6.fr/

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/lib/digsig.c b/lib/digsig.c
--- a/lib/digsig.c 2012-01-14 01:33:38.949800859 +0100
+++ b/lib/digsig.c 2012-01-22 10:01:23.096322034 +0100
@@ -224,7 +224,7 @@ int digsig_verify(struct key *keyring, c
 		kref = keyring_search(make_key_ref(keyring, 1UL),
 						&key_type_user, name);
 		if (IS_ERR(kref))
-			key = ERR_PTR(PTR_ERR(kref));
+			key = ERR_CAST(kref);
 		else
 			key = key_ref_to_ptr(kref);
 	} else {



