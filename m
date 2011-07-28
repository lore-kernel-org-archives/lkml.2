Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab1G1MqQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 08:46:16 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:39723 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754958Ab1G1MqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 08:46:12 -0400
From: Julia Lawall <julia@diku.dk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] drivers/media/dvb/dvb-usb/usb-urb.c: adjust array index
Date: Thu, 28 Jul 2011 14:46:02 +0200
Message-Id: <1311857165-14780-3-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1311857165-14780-1-git-send-email-julia@diku.dk>
References: <1311857165-14780-1-git-send-email-julia@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Convert array index from the loop bound to the loop index.

A simplified version of the semantic patch that fixes this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e1,e2,ar;
@@

for(e1 = 0; e1 < e2; e1++) { <...
  ar[
- e2
+ e1
  ]
  ...> }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
Not tested.

 drivers/media/dvb/dvb-usb/usb-urb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -u -p a/drivers/media/dvb/dvb-usb/usb-urb.c b/drivers/media/dvb/dvb-usb/usb-urb.c
--- a/drivers/media/dvb/dvb-usb/usb-urb.c
+++ b/drivers/media/dvb/dvb-usb/usb-urb.c
@@ -148,7 +148,7 @@ static int usb_bulk_urb_init(struct usb_
 		if (!stream->urb_list[i]) {
 			deb_mem("not enough memory for urb_alloc_urb!.\n");
 			for (j = 0; j < i; j++)
-				usb_free_urb(stream->urb_list[i]);
+				usb_free_urb(stream->urb_list[j]);
 			return -ENOMEM;
 		}
 		usb_fill_bulk_urb( stream->urb_list[i], stream->udev,
@@ -181,7 +181,7 @@ static int usb_isoc_urb_init(struct usb_
 		if (!stream->urb_list[i]) {
 			deb_mem("not enough memory for urb_alloc_urb!\n");
 			for (j = 0; j < i; j++)
-				usb_free_urb(stream->urb_list[i]);
+				usb_free_urb(stream->urb_list[j]);
 			return -ENOMEM;
 		}
 

