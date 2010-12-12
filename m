Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832Ab0LLXqW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:46:22 -0500
Received: from one.firstfloor.org ([213.235.205.2]:35942 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768Ab0LLXqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:46:16 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: g.liakhovetski@gmx.de, Larry.Finger@lwfinger.net, linville@tuxdriver.com,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] [76/223] wireless: b43: fix error path in SDIO
Message-Id: <20101212234615.0E9DCB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:46:15 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

commit e476a5a41ad67d0e2b4a652820c49a3923eb936b upstream.

Fix unbalanced call to sdio_release_host() on the error path.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/net/wireless/b43/sdio.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux/drivers/net/wireless/b43/sdio.c
===================================================================
--- linux.orig/drivers/net/wireless/b43/sdio.c
+++ linux/drivers/net/wireless/b43/sdio.c
@@ -163,6 +163,7 @@ static int b43_sdio_probe(struct sdio_fu
 err_free_ssb:
 	kfree(sdio);
 err_disable_func:
+	sdio_claim_host(func);
 	sdio_disable_func(func);
 err_release_host:
 	sdio_release_host(func);
