Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180Ab2AJXP4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 18:15:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52479 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934067Ab2AJXBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 18:01:22 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan 10 13:50:22 2012
Message-Id: <20120110215022.798455157@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 10 Jan 2012 13:48:32 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Julia Lawall <julia@diku.dk>,
        Oliver Neukum <oneukum@suse.de>
Subject: [22/42] drivers/usb/class/cdc-acm.c: clear dangling pointer
In-Reply-To: <20120110215031.GA19398@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julia Lawall <julia@diku.dk>

commit e7c8e8605d0bafc705ff27f9da98a1668427cc0f upstream.

On some failures, the country_code field of an acm structure is freed
without freeing the acm structure itself.  Elsewhere, operations including
memcpy and kfree are performed on the country_code field.  The patch sets
the country_code field to NULL when it is freed, and likewise sets the
country_code_size field to 0.

Signed-off-by: Julia Lawall <julia@diku.dk>
Acked-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/class/cdc-acm.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1183,6 +1183,8 @@ made_compressed_probe:
 		i = device_create_file(&intf->dev, &dev_attr_wCountryCodes);
 		if (i < 0) {
 			kfree(acm->country_codes);
+			acm->country_codes = NULL;
+			acm->country_code_size = 0;
 			goto skip_countries;
 		}
 
@@ -1191,6 +1193,8 @@ made_compressed_probe:
 		if (i < 0) {
 			device_remove_file(&intf->dev, &dev_attr_wCountryCodes);
 			kfree(acm->country_codes);
+			acm->country_codes = NULL;
+			acm->country_code_size = 0;
 			goto skip_countries;
 		}
 	}


