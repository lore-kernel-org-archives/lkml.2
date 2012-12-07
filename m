Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860Ab2LGWou (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 17:44:50 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:36367 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755835Ab2LGWot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 17:44:49 -0500
Date: Fri, 7 Dec 2012 15:44:46 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Wim Van Sebroeck <wim@iguana.be>
Subject: [PATCH] ARM: Orion: Fix possible null-deference in orion_wdt_probe
Message-ID: <20121207224446.GA29262@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the DT does not include a regs parameter then the null res
would be dereferenced.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
---
 drivers/watchdog/orion_wdt.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/watchdog/orion_wdt.c b/drivers/watchdog/orion_wdt.c
index c20f96b..140a1e3 100644
--- a/drivers/watchdog/orion_wdt.c
+++ b/drivers/watchdog/orion_wdt.c
@@ -156,6 +156,8 @@ static int __devinit orion_wdt_probe(struct platform_device *pdev)
 	wdt_tclk = clk_get_rate(clk);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENODEV;
 	wdt_reg = devm_ioremap(&pdev->dev, res->start, resource_size(res));
 	if (!wdt_reg)
 		return -ENOMEM;
-- 
1.7.5.4

