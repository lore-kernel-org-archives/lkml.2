Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388Ab2CSKb7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 06:31:59 -0400
Received: from 85.52.197.2.static.abi.uni2.es ([85.52.197.2]:42003 "EHLO
	www.manty.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753832Ab2CSKb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 06:31:58 -0400
X-Greylist: delayed 600 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Mar 2012 06:31:57 EDT
Date: Mon, 19 Mar 2012 11:21:54 +0100
From: Santiago Garcia Mantinan <manty@debian.org>
To: linux-kernel@vger.kernel.org
Cc: 664605@bugs.debian.org
Subject: readd back NOVATELWIRELESS_PRODUCT_HSPA_HIGHSPEED to option.c
 [patch]
Message-ID: <20120319102154.GA16536@www.manty.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

It looks like there was a mistake on Dirk De Schepper's patch commited by
gregkh on 4 Sep 2010 00:33:40 +0000 which can be seen here:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=c7aa8f44b4d1dc73591894a2dd6909213612d299

He removed NOVATELWIRELESS_PRODUCT_HSPA_HIGHSPEED from the scruct while
moving things around, it was a bit difficult to see as the defines and the
struct are not on the same order.  We've carried this for a year and a half
and for what I've seen there have been some reports about this like:
https://bugs.launchpad.net/ubuntu/+source/usb-modeswitch/+bug/750362
but unfortunately it didn't get much attention.

I've looked at the strings and the only one missing was
NOVATELWIRELESS_PRODUCT_HSPA_HIGHSPEED, so here is the patch for it.

--- option.c.old	2012-03-19 10:16:31.046565765 +0100
+++ option.c	2012-03-19 10:55:34.348846327 +0100
@@ -538,6 +538,7 @@
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_EVDO_EMBEDDED_FULLSPEED) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_HSPA_EMBEDDED_FULLSPEED) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_EVDO_HIGHSPEED) },
+	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_HSPA_HIGHSPEED) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_HSPA_HIGHSPEED3) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_HSPA_HIGHSPEED4) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_HSPA_HIGHSPEED5) },

Regards.
-- 
Manty/BestiaTester -> http://manty.net
