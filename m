Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873Ab0KYHDR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 02:03:17 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33187 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab0KYHDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 02:03:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=GRqqt1HEIFamBcMW9uhXc25lFoe8l6guSvfmD2Do4g7bImYtAJuX3VIvN2vy6ipCHu
         7wb+xPcORLeaWND+gBpxVChA0+6PpYpAfhc11eQJK6OXVq1V1ImC6bRIGL5RqEsb0wDE
         TG30ktKBCnx//QCsvlaqMZwQbpif8O47YNPmk=
Subject: [PATCH 2/8] ASoC: pcm030-audio-fabric: fix resource leak in
	pcm030_fabric_init error path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Jon Smirl <jonsmirl@gmail.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
In-Reply-To: <1290668785.30158.7.camel@mola>
References: <1290668785.30158.7.camel@mola>
Content-Type: text/plain
Date: Thu, 25 Nov 2010 15:08:31 +0800
Message-Id: <1290668911.30158.10.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing platform_device_put() if platform_device_add() failed.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/fsl/pcm030-audio-fabric.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/soc/fsl/pcm030-audio-fabric.c b/sound/soc/fsl/pcm030-audio-fabric.c
index 25f27ec..ba4d85e 100644
--- a/sound/soc/fsl/pcm030-audio-fabric.c
+++ b/sound/soc/fsl/pcm030-audio-fabric.c
@@ -76,6 +76,7 @@ static __init int pcm030_fabric_init(void)
 	rc = platform_device_add(pdev);
 	if (rc) {
 		pr_err("pcm030_fabric_init: platform_device_add() failed\n");
+		platform_device_put(pdev);
 		return -ENODEV;
 	}
 	return 0;
-- 
1.7.2



