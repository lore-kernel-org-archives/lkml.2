Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758890Ab0JVSx7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:53:59 -0400
Received: from kroah.org ([198.145.64.141]:45614 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755940Ab0JVSiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:38:20 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:35:57 2010
Message-Id: <20101022183557.308463859@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:34:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, Chris Ball <cjb@laptop.org>
Subject: [12/66] mmc: sdhci-s3c: fix NULL ptr access in sdhci_s3c_remove
In-Reply-To: <20101022183711.GA23214@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Marek Szyprowski <m.szyprowski@samsung.com>

commit 9320f7cbbdd5febf013b0e91db29189724057738 upstream.

If not all clocks have been defined in platform data, the driver will
cause a null pointer dereference when it is removed. This patch fixes
this issue.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mmc/host/sdhci-s3c.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/mmc/host/sdhci-s3c.c
+++ b/drivers/mmc/host/sdhci-s3c.c
@@ -379,8 +379,10 @@ static int __devexit sdhci_s3c_remove(st
 	sdhci_remove_host(host, 1);
 
 	for (ptr = 0; ptr < 3; ptr++) {
-		clk_disable(sc->clk_bus[ptr]);
-		clk_put(sc->clk_bus[ptr]);
+		if (sc->clk_bus[ptr]) {
+			clk_disable(sc->clk_bus[ptr]);
+			clk_put(sc->clk_bus[ptr]);
+		}
 	}
 	clk_disable(sc->clk_io);
 	clk_put(sc->clk_io);


