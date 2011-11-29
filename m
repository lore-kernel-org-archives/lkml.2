Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab1LCIV0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 03:21:26 -0500
Received: from www17.your-server.de ([213.133.104.17]:58102 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab1LCIU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 03:20:58 -0500
Subject: [PATCH] enic: Use kcalloc instead of kzalloc to allocate array
From: Thomas Meyer <thomas@m3y3r.de>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Tue, 29 Nov 2011 22:08:00 +0100
Message-ID: <1322600880.1534.321.camel@localhost.localdomain>
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

diff -u -p a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethernet/cisco/enic/enic_main.c
--- a/drivers/net/ethernet/cisco/enic/enic_main.c 2011-11-13 11:07:34.306945516 +0100
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c 2011-11-28 19:53:11.983614560 +0100
@@ -2379,7 +2379,7 @@ static int __devinit enic_probe(struct p
 
 #endif
 	/* Allocate structure for port profiles */
-	enic->pp = kzalloc(num_pps * sizeof(*enic->pp), GFP_KERNEL);
+	enic->pp = kcalloc(num_pps, sizeof(*enic->pp), GFP_KERNEL);
 	if (!enic->pp) {
 		pr_err("port profile alloc failed, aborting\n");
 		err = -ENOMEM;
