Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab1HFJRx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 05:17:53 -0400
Received: from www17.your-server.de ([213.133.104.17]:52669 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262Ab1HFJRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 05:17:52 -0400
Subject: [PATCH] staging: brcm80211: use kstrdup()
From: Thomas Meyer <thomas@m3y3r.de>
To: gregkh@suse.de, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 06 Aug 2011 11:17:20 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1312622244.5589.58.camel@localhost.localdomain>
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

diff -u -p a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c 2011-07-28 15:32:17.849920483 +0200
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c 2011-08-01 21:13:55.222431768 +0200
@@ -944,7 +944,7 @@ void brcmf_c_pktfilter_offload_set(struc
 	int i = 0;
 	char *arg_save = 0, *arg_org = 0;
 
-	arg_save = kmalloc(strlen(arg) + 1, GFP_ATOMIC);
+	arg_save = kstrdup(arg, GFP_ATOMIC);
 	if (!arg_save) {
 		BRCMF_ERROR(("%s: kmalloc failed\n", __func__));
 		goto fail;
@@ -958,8 +958,6 @@ void brcmf_c_pktfilter_offload_set(struc
 		goto fail;
 	}
 
-	strcpy(arg_save, arg);
-
 	argv[i] = strsep(&arg_save, " ");
 	while (argv[i++])
 		argv[i] = strsep(&arg_save, " ");


