Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965181Ab2CMAdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:33:18 -0400
Received: from mail.windriver.com ([147.11.1.11]:48788 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965139Ab2CMAYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:24:40 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        "John W. Linville" <linville@tuxdriver.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 165/196] wireless: b43: fix error path in SDIO
Date: Mon, 12 Mar 2012 20:21:18 -0400
Message-Id: <1331598109-31424-120-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit e476a5a41ad67d0e2b4a652820c49a3923eb936b upstream.

Fix unbalanced call to sdio_release_host() on the error path.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/wireless/b43/sdio.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/b43/sdio.c b/drivers/net/wireless/b43/sdio.c
index 8b18314..4808dc7 100644
--- a/drivers/net/wireless/b43/sdio.c
+++ b/drivers/net/wireless/b43/sdio.c
@@ -163,6 +163,7 @@ static int b43_sdio_probe(struct sdio_func *func,
 err_free_ssb:
 	kfree(sdio);
 err_disable_func:
+	sdio_claim_host(func);
 	sdio_disable_func(func);
 err_release_host:
 	sdio_release_host(func);
-- 
1.7.9.3

