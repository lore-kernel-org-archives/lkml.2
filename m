Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392Ab2E0BMv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:12:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36607 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756344Ab2E0BMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:12:45 -0400
Message-Id: <20120527010435.599243852@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 10:05:47 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Chris Ball <cjb@laptop.org>
Subject: [ 84/94] mmc: cd-gpio: protect against NULL context in mmc_cd_gpio_free()
In-Reply-To: <20120527010332.GA11170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

commit 0e9f480bb553d39ee06ccd45639ba7a5446a7b81 upstream.

Do not oops, even if mmc_cd_gpio_free() is mistakenly called on a driver
cleanup path, even though a previous call to mmc_cd_gpio_request() failed.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
[stable@: please apply to 3.3-stable]
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/core/cd-gpio.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/mmc/core/cd-gpio.c
+++ b/drivers/mmc/core/cd-gpio.c
@@ -67,6 +67,9 @@ void mmc_cd_gpio_free(struct mmc_host *h
 {
 	struct mmc_cd_gpio *cd = host->hotplug.handler_priv;
 
+	if (!cd)
+		return;
+
 	free_irq(host->hotplug.irq, host);
 	gpio_free(cd->gpio);
 	kfree(cd);


