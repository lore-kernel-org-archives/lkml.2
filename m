Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab0H0CbI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 22:31:08 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48509 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669Ab0H0CbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 22:31:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=qRoifBUQEzCTpR+URfSMW0m8nZif4G5qqUU5g1E0nneoovDsVDVb/YNIE9/mWU8BDa
         oN+nsv5PBrhYbFEMZWDhy6bJdTVrTnyHEKwSHBYB1FpE8xIU7fzTCGyE1l3WM254VglH
         B7AeguxLa3YZhHXM52bqr5Y+2UW9QiR3aCpN4=
Subject: [PATCH] ASoC: soc-core: fix debugfs_pop_time file permissions
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Fri, 27 Aug 2010 10:34:27 +0800
Message-Id: <1282876467.9142.2.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think this is a typo, debugfs_pop_time should not be executable.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/soc-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index 65352c7..42542e0 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -249,7 +249,7 @@ static void soc_init_codec_debugfs(struct snd_soc_codec *codec)
 		printk(KERN_WARNING
 		       "ASoC: Failed to create codec register debugfs file\n");
 
-	codec->debugfs_pop_time = debugfs_create_u32("dapm_pop_time", 0744,
+	codec->debugfs_pop_time = debugfs_create_u32("dapm_pop_time", 0644,
 						     codec->debugfs_codec_root,
 						     &codec->pop_time);
 	if (!codec->debugfs_pop_time)
-- 
1.7.2



