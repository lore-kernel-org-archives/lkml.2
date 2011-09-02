Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128Ab1IBD5a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 23:57:30 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:35020 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810Ab1IBD5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 23:57:25 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ruslan Pisarev <ruslan@rpisarev.org.ua>,
        Ilia Mirkin <imirkin@alum.mit.edu>, Joe Perches <joe@perches.com>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Arnd Bergmann <arnd@arndb.de>,
        Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH v4 02/19] Staging: cx25821: Rename member name in struct cx25821_dev
Date: Fri,  2 Sep 2011 11:55:30 +0800
Message-Id: <1314935747-6881-3-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1314935747-6881-1-git-send-email-leonidsbox@gmail.com>
References: <1314935747-6881-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename _audio_upstream_channel_select to _audio_upstream_channel in
in struct cx25821_dev in cx25821.h and all usages of that struct member
as well, because _audio_upstream_channel_select is seems to be too long
for a variable name.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-audio-upstream.c |   10 +++++-----
 drivers/staging/cx25821/cx25821.h                |    2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-audio-upstream.c b/drivers/staging/cx25821/cx25821-audio-upstream.c
index 0f9ca77..55df658 100644
--- a/drivers/staging/cx25821/cx25821-audio-upstream.c
+++ b/drivers/staging/cx25821/cx25821-audio-upstream.c
@@ -107,7 +107,7 @@ static __le32 *cx25821_risc_field_upstream_audio(struct cx25821_dev *dev,
 {
 	unsigned int line;
 	struct sram_channel *sram_ch =
-	   dev->channels[dev->_audio_upstream_channel_select].sram_channels;
+	   dev->channels[dev->_audio_upstream_channel].sram_channels;
 	int offset = 0;
 
 	/* scan lines */
@@ -351,7 +351,7 @@ static void cx25821_audioups_handler(struct work_struct *work)
 
 	cx25821_get_audio_data(dev,
 			      dev->channels[dev->
-				       _audio_upstream_channel_select].
+				       _audio_upstream_channel].
 				       sram_channels);
 }
 
@@ -604,7 +604,7 @@ static irqreturn_t cx25821_upstream_irq_audio(int irq, void *dev_id)
 	if (!dev)
 		return -1;
 
-	sram_ch = dev->channels[dev->_audio_upstream_channel_select].sram_channels;
+	sram_ch = dev->channels[dev->_audio_upstream_channel].sram_channels;
 
 	msk_stat = cx_read(sram_ch->int_mstat);
 	audio_status = cx_read(sram_ch->int_stat);
@@ -614,7 +614,7 @@ static irqreturn_t cx25821_upstream_irq_audio(int irq, void *dev_id)
 		handled =
 		    cx25821_audio_upstream_irq(dev,
 					       dev->
-					       _audio_upstream_channel_select,
+					       _audio_upstream_channel,
 					       audio_status);
 	}
 
@@ -726,7 +726,7 @@ int cx25821_audio_upstream_init(struct cx25821_dev *dev, int channel_select)
 		return 0;
 	}
 
-	dev->_audio_upstream_channel_select = channel_select;
+	dev->_audio_upstream_channel = channel_select;
 	sram_ch = dev->channels[channel_select].sram_channels;
 
 	/* Work queue */
diff --git a/drivers/staging/cx25821/cx25821.h b/drivers/staging/cx25821/cx25821.h
index a282592..db2615b 100644
--- a/drivers/staging/cx25821/cx25821.h
+++ b/drivers/staging/cx25821/cx25821.h
@@ -310,7 +310,7 @@ struct cx25821_dev {
 	int _audiofile_status;
 	int _audio_lines_count;
 	int _audioframe_count;
-	int _audio_upstream_channel_select;
+	int _audio_upstream_channel;
 	int _last_index_irq;    /* The last interrupt index processed. */
 
 	__le32 *_risc_audio_jmp_addr;
-- 
1.7.0.4

