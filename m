Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757751Ab0GASXI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:23:08 -0400
Received: from kroah.org ([198.145.64.141]:35439 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757707Ab0GASW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:22:59 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:32:09 2010
Message-Id: <20100701173209.590356933@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:30:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Johan Hovold <jhovold@gmail.com>
Subject: [patch 033/149] USB: kl5usb105: fix memory leak
In-Reply-To: <20100701175144.GA2116@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 313b0d80c1717ffe8f64b455a4d323996748b91a upstream.

Private data was not freed on error path in startup.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/kl5kusb105.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/kl5kusb105.c
+++ b/drivers/usb/serial/kl5kusb105.c
@@ -310,6 +310,7 @@ err_cleanup:
 				usb_free_urb(priv->write_urb_pool[j]);
 			}
 		}
+		kfree(priv);
 		usb_set_serial_port_data(serial->port[i], NULL);
 	}
 	return -ENOMEM;


