Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab1GHFF1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:05:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42506 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755237Ab1GHFFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:05:22 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:17:01 2011
Message-Id: <20110708001701.406081654@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:17:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?ISO-8859-15?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        David Airlie <airlied@linux.ie>
Subject: [089/107] drivers/base/platform.c: dont mark platform_device_register_resndata() as __init_or_module
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andrew Morton <akpm@linux-foundation.org>

commit bb2b43fefab723f4a0760146e7bed59d41a50e53 upstream.

This reverts 737a3bb9416ce2a7c7a4 ("Driver core: move platform device
creation helpers to .init.text (if MODULE=n)").  That patch assumed that
platform_device_register_resndata() is only ever called from __init code
but that isn't true in the case ioctl->drm_ioctl->radeon_cp_init().

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=35192

Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reported-by: Anthony Basile <blueness@gentoo.org>
Cc: Greg KH <gregkh@suse.de>
Cc: David Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/base/platform.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -367,7 +367,7 @@ EXPORT_SYMBOL_GPL(platform_device_unregi
  *
  * Returns &struct platform_device pointer on success, or ERR_PTR() on error.
  */
-struct platform_device *__init_or_module platform_device_register_resndata(
+struct platform_device *platform_device_register_resndata(
 		struct device *parent,
 		const char *name, int id,
 		const struct resource *res, unsigned int num,


