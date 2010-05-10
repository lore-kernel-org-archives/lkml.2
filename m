Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933291Ab0EJXaQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:30:16 -0400
Received: from kroah.org ([198.145.64.141]:33311 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932496Ab0EJWwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:52:42 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:33:24 2010
Message-Id: <20100510223324.872571700@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:32:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Torgny Johansson <torgny.johansson@ericsson.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [083/117] cdc_ether: fix autosuspend for mbm devices
In-Reply-To: <20100510223700.GA18404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Torgny Johansson <torgny.johansson@ericsson.com>

[ Upstream commit 55964d72d63b15df49a5df11ef91dc8601270815 ]

Autosuspend works until you bring the wwan interface up, then the
device does not enter autosuspend anymore.

The following patch fixes the problem by setting the .manage_power
field in the mbm_info struct to the same as in the cdc_info struct
(cdc_manager_power).

Signed-off-by: Torgny Johansson <torgny.johansson@ericsson.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/usb/cdc_ether.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -433,6 +433,7 @@ static const struct driver_info mbm_info
 	.bind = 	cdc_bind,
 	.unbind =	usbnet_cdc_unbind,
 	.status =	cdc_status,
+	.manage_power =	cdc_manage_power,
 };
 
 /*-------------------------------------------------------------------------*/


