Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932693Ab1JFEny (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 00:43:54 -0400
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:48730 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751312Ab1JFEnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 00:43:53 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: [PATCH] ASoC: fix codec breakage caused by the volsw/volsw_2r merger
Date: Thu,  6 Oct 2011 07:43:21 +0300
Message-Id: <1317876201-7041-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <20111006132204.29c84ed7349daf8c4aa39c3b@canb.auug.org.au>
References: <20111006132204.29c84ed7349daf8c4aa39c3b@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By accident few places still uses the _2r calls from
the core.
This is a quick fix, the drivers using the old callbacks
going to be changed.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---

Hi Stephen, Mark,

I'm really sorry, I can not explain how it happened.
Please find a quick fox for the issue.
I'm going to fix the drivers meanwhile.

Regards,
Peter

 include/sound/soc.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/sound/soc.h b/include/sound/soc.h
index 88ba85a..858291d 100644
--- a/include/sound/soc.h
+++ b/include/sound/soc.h
@@ -393,6 +393,8 @@ int snd_soc_get_volsw(struct snd_kcontrol *kcontrol,
 	struct snd_ctl_elem_value *ucontrol);
 int snd_soc_put_volsw(struct snd_kcontrol *kcontrol,
 	struct snd_ctl_elem_value *ucontrol);
+#define snd_soc_get_volsw_2r snd_soc_get_volsw
+#define snd_soc_put_volsw_2r snd_soc_put_volsw
 int snd_soc_info_volsw_s8(struct snd_kcontrol *kcontrol,
 	struct snd_ctl_elem_info *uinfo);
 int snd_soc_get_volsw_s8(struct snd_kcontrol *kcontrol,
-- 
1.7.7

