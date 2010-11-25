Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755Ab0KYHCM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 02:02:12 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:58467 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab0KYHCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 02:02:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=tGn3ijqQE+oBmg9xzl1rDMk/bqzdzAMfNL8gG8uNRmEAyTGfLsl2KwV9CGXh6d3+9u
         QoSVKFbgZ6JvOlqJcgqi9iwf0eYR5ZiIQLJR4p2tOxcbGcPeH/9imRVly0hydEJtPBlG
         CTLbQKAqdTQNb96By7zptghqZDVow2vGGO5J0=
Subject: [PATCH 1/8] ASoC: efika-audio-fabric: fix resource leak in
	efika_fabric_init error path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Jon Smirl <jonsmirl@gmail.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
In-Reply-To: <1290668785.30158.7.camel@mola>
References: <1290668785.30158.7.camel@mola>
Content-Type: text/plain
Date: Thu, 25 Nov 2010 15:07:25 +0800
Message-Id: <1290668845.30158.8.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing platform_device_put() if platform_device_add() failed.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/fsl/efika-audio-fabric.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/soc/fsl/efika-audio-fabric.c b/sound/soc/fsl/efika-audio-fabric.c
index 53251e6..108b5d8 100644
--- a/sound/soc/fsl/efika-audio-fabric.c
+++ b/sound/soc/fsl/efika-audio-fabric.c
@@ -76,6 +76,7 @@ static __init int efika_fabric_init(void)
 	rc = platform_device_add(pdev);
 	if (rc) {
 		pr_err("efika_fabric_init: platform_device_add() failed\n");
+		platform_device_put(pdev);
 		return -ENODEV;
 	}
 	return 0;
-- 
1.7.2



