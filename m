Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932547Ab1EFA0P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:26:15 -0400
Received: from kroah.org ([198.145.64.141]:37394 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932526Ab1EFA0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:26:09 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:18 2011
Message-Id: <20110506002218.720237710@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:22:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: [137/143] wireless: b43: fix error path in SDIO
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

commit e476a5a41ad67d0e2b4a652820c49a3923eb936b upstream.

Fix unbalanced call to sdio_release_host() on the error path.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/wireless/b43/sdio.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/b43/sdio.c
+++ b/drivers/net/wireless/b43/sdio.c
@@ -162,6 +162,7 @@ static int b43_sdio_probe(struct sdio_fu
 err_free_ssb:
 	kfree(sdio);
 err_disable_func:
+	sdio_claim_host(func);
 	sdio_disable_func(func);
 err_release_host:
 	sdio_release_host(func);


