Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249Ab2ELBdT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 21:33:19 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:51564 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755328Ab2ELBdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 21:33:17 -0400
Message-ID: <4FADBDEB.402@xenotime.net>
Date: Fri, 11 May 2012 18:33:31 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Wim Van Sebroeck <wim@iguana.be>
Subject: [PATCH -next] watchdog: fix ie6xx_wdt.c printk format warning
References: <20120511162738.1d65b6efe099a54841be6313@canb.auug.org.au>
In-Reply-To: <20120511162738.1d65b6efe099a54841be6313@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix printk format warning; use cast to u64 since resource_size_t can
be either u32 or u64.

drivers/watchdog/ie6xx_wdt.c:261:4: warning: format '%x' expects type 'unsigned int', but argument 3 has type 'resource_size_t'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/watchdog/ie6xx_wdt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20120511.orig/drivers/watchdog/ie6xx_wdt.c
+++ linux-next-20120511/drivers/watchdog/ie6xx_wdt.c
@@ -257,8 +257,8 @@ static int __devinit ie6xx_wdt_probe(str
 		return -ENODEV;
 
 	if (!request_region(res->start, resource_size(res), pdev->name)) {
-		dev_err(&pdev->dev, "Watchdog region 0x%x already in use!\n",
-			res->start);
+		dev_err(&pdev->dev, "Watchdog region 0x%llx already in use!\n",
+			(u64)res->start);
 		return -EBUSY;
 	}
 
