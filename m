Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab2IQIFS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 04:05:18 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:62259 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515Ab2IQIFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 04:05:13 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: mchehab@infradead.org
Cc: leonidsbox@gmail.com, peter.senna@gmail.com, thomas@m3y3r.de,
        hans.verkuil@cisco.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] cx25821: Replace kmemdup for kstrdup and clean up
Date: Mon, 17 Sep 2012 10:04:57 +0200
Message-Id: <1347869098-2236-2-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1347869098-2236-1-git-send-email-peter.senna@gmail.com>
References: <1347869098-2236-1-git-send-email-peter.senna@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace kmemdup for kstrdup and cleanup related code.

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 drivers/media/pci/cx25821/cx25821-audio-upstream.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/media/pci/cx25821/cx25821-audio-upstream.c b/drivers/media/pci/cx25821/cx25821-audio-upstream.c
index 49a28ae..1cc797e 100644
--- a/drivers/media/pci/cx25821/cx25821-audio-upstream.c
+++ b/drivers/media/pci/cx25821/cx25821-audio-upstream.c
@@ -701,7 +701,6 @@ int cx25821_audio_upstream_init(struct cx25821_dev *dev, int channel_select)
 {
 	struct sram_channel *sram_ch;
 	int err = 0;
-	int str_length = 0;
 
 	if (dev->_audio_is_running) {
 		pr_warn("Audio Channel is still running so return!\n");
@@ -730,9 +729,8 @@ int cx25821_audio_upstream_init(struct cx25821_dev *dev, int channel_select)
 	_line_size = AUDIO_LINE_SIZE;
 
 	if (dev->input_audiofilename) {
-		str_length = strlen(dev->input_audiofilename);
-		dev->_audiofilename = kmemdup(dev->input_audiofilename,
-					      str_length + 1, GFP_KERNEL);
+		dev->_audiofilename = kstrdup(dev->input_audiofilename,
+					      GFP_KERNEL);
 
 		if (!dev->_audiofilename) {
 			err = -ENOMEM;
@@ -743,9 +741,8 @@ int cx25821_audio_upstream_init(struct cx25821_dev *dev, int channel_select)
 		if (strcmp(dev->input_audiofilename, "") == 0)
 			dev->_audiofilename = "/root/audioGOOD.wav";
 	} else {
-		str_length = strlen(_defaultAudioName);
-		dev->_audiofilename = kmemdup(_defaultAudioName,
-					      str_length + 1, GFP_KERNEL);
+		dev->_audiofilename = kstrdup(_defaultAudioName,
+					      GFP_KERNEL);
 
 		if (!dev->_audiofilename) {
 			err = -ENOMEM;
-- 
1.7.11.4

