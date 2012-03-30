Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965596Ab2C3VSI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:18:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54199 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965583Ab2C3VSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:18:00 -0400
Message-Id: <20120330194828.834996080@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:48:46 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Gerard Snitselaar <dev@snitselaar.org>
Subject: [ 021/175] staging: vme: fix section mismatches in linux-next 20120314
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gerard Snitselaar <dev@snitselaar.org>

commit bf3a85be67068a0f55804349e6e1dce80008c45c upstream.

pio2_gpio_init() annotated with __init, but called by pio2_probe()
which is annotated __devinit. pio2_gpio_exit() is annotated __exit,
but is called by pio2_probe() and by pio2_remove() which is annotated
__devexit.

Signed-off-by: Gerard Snitselaar <dev@snitselaar.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/vme/devices/vme_pio2.h      |    4 ++--
 drivers/staging/vme/devices/vme_pio2_gpio.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/staging/vme/devices/vme_pio2.h
+++ b/drivers/staging/vme/devices/vme_pio2.h
@@ -243,7 +243,7 @@ struct pio2_card {
 int pio2_cntr_reset(struct pio2_card *);
 
 int pio2_gpio_reset(struct pio2_card *);
-int __init pio2_gpio_init(struct pio2_card *);
-void __exit pio2_gpio_exit(struct pio2_card *);
+int __devinit pio2_gpio_init(struct pio2_card *);
+void pio2_gpio_exit(struct pio2_card *);
 
 #endif /* _VME_PIO2_H_ */
--- a/drivers/staging/vme/devices/vme_pio2_gpio.c
+++ b/drivers/staging/vme/devices/vme_pio2_gpio.c
@@ -187,7 +187,7 @@ int pio2_gpio_reset(struct pio2_card *ca
 	return 0;
 }
 
-int __init pio2_gpio_init(struct pio2_card *card)
+int __devinit pio2_gpio_init(struct pio2_card *card)
 {
 	int retval = 0;
 	char *label;
@@ -220,7 +220,7 @@ int __init pio2_gpio_init(struct pio2_ca
 	return retval;
 };
 
-void __exit pio2_gpio_exit(struct pio2_card *card)
+void pio2_gpio_exit(struct pio2_card *card)
 {
 	const char *label = card->gc.label;
 


