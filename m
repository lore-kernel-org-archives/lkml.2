Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933272Ab2FVP0q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 11:26:46 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40750 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933196Ab2FVP0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 11:26:44 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 04/12] gpio-sch: Fix resource leak
To: greg@kroah.com, linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Date: Fri, 22 Jun 2012 16:42:40 +0100
Message-ID: <20120622154040.1405.28472.stgit@localhost.localdomain>
In-Reply-To: <20120622153600.1405.15575.stgit@localhost.localdomain>
References: <20120622153600.1405.15575.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/gpio/gpio-sch.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-sch.c b/drivers/gpio/gpio-sch.c
index 424dce8..8707d45 100644
--- a/drivers/gpio/gpio-sch.c
+++ b/drivers/gpio/gpio-sch.c
@@ -241,7 +241,8 @@ static int __devinit sch_gpio_probe(struct platform_device *pdev)
 			break;
 
 		default:
-			return -ENODEV;
+			err = -ENODEV;
+			goto err_sch_gpio_core;
 	}
 
 	sch_gpio_core.dev = &pdev->dev;

