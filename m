Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509Ab1I1WnZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:43:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54188 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932469Ab1I1WnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:43:21 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:37 2011
Message-Id: <20110928220137.552445368@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:01:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Anand Gadiyar <gadiyar@ti.com>,
        Keshava Munegowda <keshava_mgowda@ti.com>, Felipe Balbi <balbi@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [116/244] mfd: Make omap-usb-host TLL mode work again
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Anand Gadiyar <gadiyar@ti.com>

commit e600cffe618ff0da29ae1f8b8d3824ce0e2409fc upstream.

This code section seems to have been accidentally copy pasted.
It causes incorrect bits to be set up in the TLL_CHANNEL_CONF
register and prevents the TLL mode from working correctly.

Signed-off-by: Anand Gadiyar <gadiyar@ti.com>
Cc: Keshava Munegowda <keshava_mgowda@ti.com>
Acked-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mfd/omap-usb-host.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -676,7 +676,6 @@ static void usbhs_omap_tll_init(struct d
 				| OMAP_TLL_CHANNEL_CONF_ULPINOBITSTUFF
 				| OMAP_TLL_CHANNEL_CONF_ULPIDDRMODE);
 
-			reg |= (1 << (i + 1));
 		} else
 			continue;
 


