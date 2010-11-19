Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932373Ab0KSVpn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 16:45:43 -0500
Received: from kroah.org ([198.145.64.141]:51866 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932318Ab0KSVpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:45:39 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:44:12 2010
Message-Id: <20101119214412.310478722@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:43:15 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: [35/45] USB: atmel_usba_udc: force vbus_pin at -EINVAL when gpio_request failled
In-Reply-To: <20101119214439.GA26350@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

commit 969affff54702785330de553b790372e261e93f9 upstream.

to ensure gpio_is_valid return false

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/gadget/atmel_usba_udc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/gadget/atmel_usba_udc.c
+++ b/drivers/usb/gadget/atmel_usba_udc.c
@@ -2013,6 +2013,9 @@ static int __init usba_udc_probe(struct
 			} else {
 				disable_irq(gpio_to_irq(udc->vbus_pin));
 			}
+		} else {
+			/* gpio_request fail so use -EINVAL for gpio_is_valid */
+			ubc->vbus_pin = -EINVAL;
 		}
 	}
 


