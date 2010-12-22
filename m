Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab0LVADl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 19:03:41 -0500
Received: from mail-ey0-f171.google.com ([209.85.215.171]:50234 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923Ab0LVADj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 19:03:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nBZBhdWiCmrzpOJukMGNiV3umtaipMBfdrmWaUP1O4DyT+uTp/g404yLAV39E7cxzQ
         TQua3VzhMAauKDl6o1tJhZmL1ETDrkoy2eNwzEHqr1T+mAsUiUDVcoHSNPTJtPgNZbSZ
         zfbU1kl69mFFSRVapMiFIWHJfAr24aBhX27HY=
Date: Wed, 22 Dec 2010 03:03:34 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org, Vasiliy Kulikov <segoon@openwall.com>,
        Dan Carpenter <error27@gmail.com>
Subject: Re: [PATCH] POWER: gpio-charger: Check result of kzalloc
Message-ID: <20101222000334.GA23799@oksana.dev.rtsoft.ru>
References: <1290118119-16468-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1290118119-16468-1-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 11:08:37PM +0100, Lars-Peter Clausen wrote:
> Since kzalloc can return NULL we have to check its result.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---

Lars, Vasiliy, Dan,

Thanks for the patch! I applied the following:

commit 2e9ff5f5e4c6b034554f3539f29529265279102c
Author: Lars-Peter Clausen <lars@metafoo.de>
Date:   Thu Nov 18 23:08:37 2010 +0100

    gpio-charger: Check result of kzalloc
    
    Since kzalloc can return NULL we have to check its result.
    
    Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
    Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
    Signed-off-by: Dan Carpenter <error27@gmail.com>
    Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>

diff --git a/drivers/power/gpio-charger.c b/drivers/power/gpio-charger.c
index fccbe99..8458caf 100644
--- a/drivers/power/gpio-charger.c
+++ b/drivers/power/gpio-charger.c
@@ -87,6 +87,10 @@ static int __devinit gpio_charger_probe(struct platform_device *pdev)
 	}
 
 	gpio_charger = kzalloc(sizeof(*gpio_charger), GFP_KERNEL);
+	if (!gpio_charger) {
+		dev_err(&pdev->dev, "Failed to alloc driver structure\n");
+		return -ENOMEM;
+	}
 
 	charger = &gpio_charger->charger;
 
