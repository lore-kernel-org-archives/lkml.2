Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175Ab1DLRhN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 13:37:13 -0400
Received: from smtp-out-051.synserver.de ([212.40.185.51]:1097 "HELO
	smtp-out-049.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1753590Ab1DLRhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 13:37:12 -0400
X-Greylist: delayed 393 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Apr 2011 13:37:11 EDT
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 24502
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 1/5] ASoC: Make struct snd_soc_card's dapm_widgets and dapm_routes const
Date: Tue, 12 Apr 2011 19:31:01 +0200
Message-Id: <1302629465-21315-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Those should not be modified (and are not) by the core code, so make them const.
This also makes them consistent with the same members of snd_soc_codec.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 include/sound/soc.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/sound/soc.h b/include/sound/soc.h
index 435cb83..cb6b18b 100644
--- a/include/sound/soc.h
+++ b/include/sound/soc.h
@@ -755,9 +755,9 @@ struct snd_soc_card {
 	/*
 	 * Card-specific routes and widgets.
 	 */
-	struct snd_soc_dapm_widget *dapm_widgets;
+	const struct snd_soc_dapm_widget *dapm_widgets;
 	int num_dapm_widgets;
-	struct snd_soc_dapm_route *dapm_routes;
+	const struct snd_soc_dapm_route *dapm_routes;
 	int num_dapm_routes;
 
 	struct work_struct deferred_resume_work;
-- 
1.7.2.5

