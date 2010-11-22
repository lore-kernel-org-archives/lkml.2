Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609Ab0KVImx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 03:42:53 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51501 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab0KVImw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 03:42:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=OxlkgdshGV7FtRo3ZWe9ky8pisf+aAeHgJIGFLMzn6zOopsyHlWxHkDh+vbSbEI65V
         uZGHA0KEx2hS3cPU+lPPdNgIa7UWTxaDtvSxQIIkFCHYsZ4zdQyyow+LaImyOnI1gvA3
         jagii6FTMwW6bz0aLNNl7AjMcuV39pQ1mHY0Y=
Subject: [PATCH 4/4] [ARM] mxcmmc: remove a unnecessary release_resource()
	call
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Chris Ball <cjb@laptop.org>, Sascha Hauer <s.hauer@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mmc@vger.kernel.org
In-Reply-To: <1290415596.5471.10.camel@mola>
References: <1290415359.5471.4.camel@mola>  <1290415467.5471.7.camel@mola>
	 <1290415534.5471.8.camel@mola>  <1290415596.5471.10.camel@mola>
Content-Type: text/plain
Date: Mon, 22 Nov 2010 16:47:51 +0800
Message-Id: <1290415671.5471.13.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove release_resource() after release_mem_region().

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mmc/host/mxcmmc.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/mxcmmc.c b/drivers/mmc/host/mxcmmc.c
index 2b9f7c8..4428594 100644
--- a/drivers/mmc/host/mxcmmc.c
+++ b/drivers/mmc/host/mxcmmc.c
@@ -967,7 +967,6 @@ static int mxcmci_remove(struct platform_device *pdev)
 	clk_put(host->clk);
 
 	release_mem_region(host->res->start, resource_size(host->res));
-	release_resource(host->res);
 
 	mmc_free_host(mmc);
 
-- 
1.7.2



