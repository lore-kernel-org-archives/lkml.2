Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab1A2Jfu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 04:35:50 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:56716 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab1A2Jfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 04:35:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=jlgfVcl7wXQxlujHsPQbLOBvprw3E7rWF8W+5AszlktcB/LTF6yTpO9GZfoC4kOpy0
         qBFf+9uDpEG10LNMS3f05HXP8W/UhH7x12eHUpyauuY083NRsrdEGv8DaCjKnLON51Tq
         efNHCktIQwzhOrs2h2onAfXqDJjgJRjHE0R9U=
Subject: [PATCH 2/2] video: sh7760fb: use resource_size()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Manuel Lauss <mano@roarinelk.homelinux.net>,
        Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>,
        Paul Mundt <lethal@linux-sh.org>, linux-fbdev@vger.kernel.org
In-Reply-To: <1296293628.13797.2.camel@phoenix>
References: <1296293628.13797.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 29 Jan 2011 17:35:45 +0800
Message-ID: <1296293745.13797.4.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The size calculation is done incorrectly in request_mem_region because
it should include both the start and end (end - start + 1).

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/video/sh7760fb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/sh7760fb.c b/drivers/video/sh7760fb.c
index bea38fc..8fe1958 100644
--- a/drivers/video/sh7760fb.c
+++ b/drivers/video/sh7760fb.c
@@ -459,14 +459,14 @@ static int __devinit sh7760fb_probe(struct platform_device *pdev)
 	}
 
 	par->ioarea = request_mem_region(res->start,
-					 (res->end - res->start), pdev->name);
+					 resource_size(res), pdev->name);
 	if (!par->ioarea) {
 		dev_err(&pdev->dev, "mmio area busy\n");
 		ret = -EBUSY;
 		goto out_fb;
 	}
 
-	par->base = ioremap_nocache(res->start, res->end - res->start + 1);
+	par->base = ioremap_nocache(res->start, resource_size(res));
 	if (!par->base) {
 		dev_err(&pdev->dev, "cannot remap\n");
 		ret = -ENODEV;
-- 
1.7.0.4



