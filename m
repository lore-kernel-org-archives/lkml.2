Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018Ab1FAWXf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 18:23:35 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:33018 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270Ab1FAWXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 18:23:34 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-160.messagelabs.com!1306967013!8858085!1
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.98]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] hw_random: timeriomem-rng: use resource_size
Date: Wed, 1 Jun 2011 15:23:13 -0700
User-Agent: KMail/1.9.9
CC: <mpm@selenic.com>, <herbert@gondor.hengli.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201106011523.13707.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>

---

diff --git a/drivers/char/hw_random/timeriomem-rng.c b/drivers/char/hw_random/timeriomem-rng.c
index a94e930..a8428e6 100644
--- a/drivers/char/hw_random/timeriomem-rng.c
+++ b/drivers/char/hw_random/timeriomem-rng.c
@@ -100,8 +100,7 @@ static int __devinit timeriomem_rng_probe(struct platform_device *pdev)
 
 	timeriomem_rng_data = pdev->dev.platform_data;
 
-	timeriomem_rng_data->address = ioremap(res->start,
-						res->end - res->start + 1);
+	timeriomem_rng_data->address = ioremap(res->start, resource_size(res));
 	if (!timeriomem_rng_data->address)
 		return -EIO;
 
