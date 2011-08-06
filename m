Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab1HFJUr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 05:20:47 -0400
Received: from www17.your-server.de ([213.133.104.17]:33289 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab1HFJUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 05:20:45 -0400
Subject: [PATCH] ipmi: use kstrdup()
From: Thomas Meyer <thomas@m3y3r.de>
To: openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Date: Sat, 06 Aug 2011 11:20:13 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1312622416.5589.61.camel@localhost.localdomain>
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Meyer <thomas@m3y3r.de>

 Use kstrdup rather than duplicating its implementation

 The semantic patch that makes this output is available
 in scripts/coccinelle/api/kstrdup.cocci.

 More information about semantic patching is available at
 http://coccinelle.lip6.fr/

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
--- a/drivers/char/ipmi/ipmi_msghandler.c 2011-05-27 19:17:04.559520123 +0200
+++ b/drivers/char/ipmi/ipmi_msghandler.c 2011-08-01 21:10:43.970134537 +0200
@@ -2030,12 +2030,11 @@ int ipmi_smi_add_proc_entry(ipmi_smi_t s
 	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
 	if (!entry)
 		return -ENOMEM;
-	entry->name = kmalloc(strlen(name)+1, GFP_KERNEL);
+	entry->name = kstrdup(name, GFP_KERNEL);
 	if (!entry->name) {
 		kfree(entry);
 		return -ENOMEM;
 	}
-	strcpy(entry->name, name);
 
 	file = proc_create_data(name, 0, smi->proc_dir, proc_ops, data);
 	if (!file) {


