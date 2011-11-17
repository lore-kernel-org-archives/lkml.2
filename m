Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069Ab1KRJ10 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 04:27:26 -0500
Received: from www17.your-server.de ([213.133.104.17]:48413 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755535Ab1KRJ1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 04:27:22 -0500
Subject: [PATCH] x86, mrst: Casting (void *) value returned by kmalloc is
 useless
From: Thomas Meyer <thomas@m3y3r.de>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Thu, 17 Nov 2011 23:43:40 +0100
Message-ID: <1321569820.1624.244.camel@localhost.localdomain>
X-Mailer: Evolution 3.2.1 (3.2.1-2.fc16) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The semantic patch that makes this change is available
in scripts/coccinelle/api/alloc/drop_kmalloc_cast.cocci.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
--- a/arch/x86/platform/mrst/mrst.c 2011-11-07 19:37:40.283168752 +0100
+++ b/arch/x86/platform/mrst/mrst.c 2011-11-08 09:19:24.686513740 +0100
@@ -331,7 +331,7 @@ static int __init sfi_parse_gpio(struct
 	num = SFI_GET_NUM_ENTRIES(sb, struct sfi_gpio_table_entry);
 	pentry = (struct sfi_gpio_table_entry *)sb->pentry;
 
-	gpio_table = (struct sfi_gpio_table_entry *)
+	gpio_table =
 				kmalloc(num * sizeof(*pentry), GFP_KERNEL);
 	if (!gpio_table)
 		return -1;
