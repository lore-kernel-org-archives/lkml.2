Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068Ab0LFIlz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 03:41:55 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38301 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031Ab0LFIly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 03:41:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=VTnwxZApc9hsDhzx13cdh7ETfSDqWA4s06tsyfwagjxpib2qxP6NTEPLTub6zFkwKg
         kkgj2AlkUGmjez/9pdvdb35fVkYnOzRhrw+zbw3ZkmDLWRgvvuAv4K8ndIc+P8wgwZt3
         ACeGWBG3Bn/q19/SwlayPoMTTA8lYmHl6HXkk=
Subject: [PATCH] ASoC: Hold client_mutex while calling
	snd_soc_instantiate_cards()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain
Date: Mon, 06 Dec 2010 16:48:03 +0800
Message-Id: <1291625283.11404.2.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the comments of snd_soc_instantiate_cards() said,
snd_soc_instantiate_cards() must be called with client_mutex.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/soc-core.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index eb950f7..0d69b91 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -3299,7 +3299,9 @@ int snd_soc_register_dais(struct device *dev,
 		pr_debug("Registered DAI '%s'\n", dai->name);
 	}
 
+	mutex_lock(&client_mutex);
 	snd_soc_instantiate_cards();
+	mutex_unlock(&client_mutex);
 	return 0;
 
 err:
-- 
1.7.2



