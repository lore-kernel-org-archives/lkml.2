Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757629Ab0LTNJM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 08:09:12 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:42460 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413Ab0LTNJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 08:09:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=qF1hniXA+kW0zPp0px4eXhbBalehJzxmUonzzJCZN3KuBwsUaP52/yNgxOoUmlrWwM
         jlI5Sx3Jsp7nCydyCo92bykQ2r9PeLN9SdtV6/aGobhkzxhbr2nlRWgvHpWj/3BRegrx
         C1ekcXbqT+Vs3HMabl46oFnDTw5UtpPpvVQZk=
Date: Mon, 20 Dec 2010 16:08:56 +0300
From: Dan Carpenter <error27@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch -next] power/gpio-charger: check for kzalloc() failure
Message-ID: <20101220130856.GZ1936@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Anton Vorontsov <cbouatmailru@gmail.com>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return -ENOMEM if kzalloc() fails.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/power/gpio-charger.c b/drivers/power/gpio-charger.c
index fccbe99..06a74f0 100644
--- a/drivers/power/gpio-charger.c
+++ b/drivers/power/gpio-charger.c
@@ -87,6 +87,8 @@ static int __devinit gpio_charger_probe(struct platform_device *pdev)
 	}
 
 	gpio_charger = kzalloc(sizeof(*gpio_charger), GFP_KERNEL);
+	if (!gpio_charger)
+		return -ENOMEM;
 
 	charger = &gpio_charger->charger;
 
