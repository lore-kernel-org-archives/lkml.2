Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027Ab0JJR2y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 13:28:54 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38797 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757968Ab0JJR2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 13:28:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Init9kOQJJxiYqJRlDSefq5dB5sfLAgtVFXuRwfkFGtJmq7UCmA6hRWeknfwavI5T8
         QCqkJGgm3974QUIiVNNelwHlvCKTdQSfBegh+uPzfG4qBtv9roxOO1syF9sYch02yCGQ
         UzLeYPa6r2ntqGWVxte7XP1e+wjrvIYUJDPus=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Harsha Priya <priya.harsha@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, Alan Cox <alan@linux.intel.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: intel_sst: fix signess error
Date: Sun, 10 Oct 2010 21:28:47 +0400
Message-Id: <1286731728-18039-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

str_id was unsigned, so check for (str_id <= 0) made no sense.
Made it signed.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 Compile tested.

 drivers/staging/intel_sst/intel_sst_stream.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/intel_sst/intel_sst_stream.c b/drivers/staging/intel_sst/intel_sst_stream.c
index ff46d5c..1ce3a9c 100644
--- a/drivers/staging/intel_sst/intel_sst_stream.c
+++ b/drivers/staging/intel_sst/intel_sst_stream.c
@@ -117,7 +117,8 @@ int sst_alloc_stream(char *params, unsigned int stream_ops,
 {
 	struct ipc_post *msg = NULL;
 	struct snd_sst_alloc_params alloc_param;
-	unsigned int pcm_slot = 0, num_ch, str_id;
+	unsigned int pcm_slot = 0, num_ch;
+	int str_id;
 	struct snd_sst_stream_params *sparams;
 	struct stream_info *str_info;
 
-- 
1.7.0.4

