Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291Ab1KHS7k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 13:59:40 -0500
Received: from www17.your-server.de ([213.133.104.17]:58060 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215Ab1KHS7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 13:59:38 -0500
Subject: [PATCH] PM / OPP: Use ERR_CAST inlined function
From: Thomas Meyer <thomas@m3y3r.de>
To: Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
Date: Tue, 08 Nov 2011 19:57:12 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1320778667.8062.137.camel@localhost.localdomain>
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Meyer <thomas@m3y3r.de>

 Use ERR_CAST inlined function instead of ERR_PTR(PTR_ERR(...))

 The semantic patch that makes this change is available
 in scripts/coccinelle/api/err_cast.cocci.

 More information about semantic patching is available at
 http://coccinelle.lip6.fr/

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/base/power/opp.c b/drivers/base/power/opp.c
--- a/drivers/base/power/opp.c 2011-11-07 19:37:43.009876832 +0100
+++ b/drivers/base/power/opp.c 2011-11-08 09:55:51.808539048 +0100
@@ -669,7 +669,7 @@ struct srcu_notifier_head *opp_get_notif
 	struct device_opp *dev_opp = find_device_opp(dev);
 
 	if (IS_ERR(dev_opp))
-		return ERR_PTR(PTR_ERR(dev_opp)); /* matching type */
+		return ERR_CAST(dev_opp); /* matching type */
 
 	return &dev_opp->head;
 }


