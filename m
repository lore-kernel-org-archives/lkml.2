Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab1JWGhB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 02:37:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40107 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754792Ab1JWGeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 02:34:15 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Sun Oct 23 08:25:38 2011
Message-Id: <20111023062538.713588404@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Sun, 23 Oct 2011 08:24:37 +0200
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: stable-review@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Thomas Courbon <thcourbon@gmail.com>, Matthew Garrett <mjg@redhat.com>,
        Josh Boyer <jwboyer@redhat.com>
Subject: [09/27] Platform: fix samsung-laptop DMI identification for N150/N210/220/N230
In-Reply-To: <20111023062833.GA8126@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thomas Courbon <thcourbon@gmail.com>

commit 78a7539b881eb557494a7c810625c0307b27296c upstream.

Some samsung latop of the N150/N2{10,20,30} serie are badly detected by the samsung-laptop platform driver, see bug # 36082.
It appears that N230 identifies itself as N150/N210/N220/N230 whereas the other identify themselves as N150/N210/220.
This patch attemtp fix #36082 allowing correct identification for all the said netbook model.

Reported-by: Daniel Eklöf <daniel@ekloef.se>
Signed-off-by: Thomas Courbon <thcourbon@gmail.com>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: Josh Boyer <jwboyer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/samsung-laptop.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/platform/x86/samsung-laptop.c
+++ b/drivers/platform/x86/samsung-laptop.c
@@ -601,6 +601,16 @@ static struct dmi_system_id __initdata s
 		.callback = dmi_check_cb,
 	},
 	{
+		.ident = "N150/N210/N220",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR,
+					"SAMSUNG ELECTRONICS CO., LTD."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "N150/N210/N220"),
+			DMI_MATCH(DMI_BOARD_NAME, "N150/N210/N220"),
+		},
+		.callback = dmi_check_cb,
+	},
+	{
 		.ident = "N150/N210/N220/N230",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR,


