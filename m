Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab1HLDfs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 23:35:48 -0400
Received: from hapkido.dreamhost.com ([66.33.216.122]:39695 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171Ab1HLDfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 23:35:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=kylemanna.com; h=from:to:cc
	:subject:date:message-id:in-reply-to:references; q=dns; s=
	kylemanna.com; b=M7P85c/0BkbGPXvVABnoN+XASXG6HM2i9pAwKaKQ1vSlHJR
	XpgfP6j3gQIabEk4jHuN2gB0LPtYWg8bwgwYUpLUWw9wJx/jdRsKqOsMN5p+jthy
	KSN5I545yImPs2AOrIA/cbG9Y9ODTt2wuMI9HO2R+wDSonUz+eGjxR+yEBVo=
From: Kyle Manna <kyle@kylemanna.com>
To: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: Keerthy <j-keerthy@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kyle Manna <kyle@kylemanna.com>
Subject: [PATCH v2 1/4] mfd: twl4030-madc: copy the device pointer
Date: Thu, 11 Aug 2011 22:33:12 -0500
Message-Id: <1313119995-15382-2-git-send-email-kyle@kylemanna.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1313119995-15382-1-git-send-email-kyle@kylemanna.com>
References: <CANOLnOPB=wFMPwqGbu9ufh__iM7TquUx3-o95R=gyJcae+gENg@mail.gmail.com>
 <1313119995-15382-1-git-send-email-kyle@kylemanna.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Worst case this fixes the following error:
[   72.086212] (NULL device *): conversion timeout!

Best case it prevents a crash

Signed-off-by: Kyle Manna <kyle@kylemanna.com>
---
 drivers/mfd/twl4030-madc.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/twl4030-madc.c b/drivers/mfd/twl4030-madc.c
index b5d598c..cb44b53 100644
--- a/drivers/mfd/twl4030-madc.c
+++ b/drivers/mfd/twl4030-madc.c
@@ -706,6 +706,8 @@ static int __devinit twl4030_madc_probe(struct platform_device *pdev)
 	if (!madc)
 		return -ENOMEM;
 
+	madc->dev = &pdev->dev;
+
 	/*
 	 * Phoenix provides 2 interrupt lines. The first one is connected to
 	 * the OMAP. The other one can be connected to the other processor such
-- 
1.7.4.1

