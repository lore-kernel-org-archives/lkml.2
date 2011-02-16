Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933251Ab1BPBCe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:02:34 -0500
Received: from kroah.org ([198.145.64.141]:45978 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933260Ab1BPAuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:50:37 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:11 2011
Message-Id: <20110216002111.245284155@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:21:30 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sonic Zhang <sonic.zhang@analog.com>,
        Mike Frysinger <vapier@gentoo.org>, Chris Ball <cjb@laptop.org>
Subject: [patch 122/176] mmc: bfin_sdh: fix alloc size for private data
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sonic Zhang <sonic.zhang@analog.com>

commit a34650f0f1ca589cda09c48cb62baf15e680a247 upstream.

The bfin_sdh driver allocates the wrong size for the private data
in the mmc_host.  The first parameter of mmc_alloc_host should be
the size of the local driver struct rather than the common mmc_host.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mmc/host/bfin_sdh.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/bfin_sdh.c
+++ b/drivers/mmc/host/bfin_sdh.c
@@ -462,7 +462,7 @@ static int __devinit sdh_probe(struct pl
 		goto out;
 	}
 
-	mmc = mmc_alloc_host(sizeof(*mmc), &pdev->dev);
+	mmc = mmc_alloc_host(sizeof(struct sdh_host), &pdev->dev);
 	if (!mmc) {
 		ret = -ENOMEM;
 		goto out;


