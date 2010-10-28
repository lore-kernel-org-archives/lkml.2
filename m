Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934045Ab0J1UC0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 16:02:26 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:51506 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761509Ab0J1UCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 16:02:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=VQJUV0rvTtbOizqKms0f3YqqOMJxh2heD11T+odo3yoHMG73TYMuWDvqz+10o7qifm
         InCsNzxS1TM8HCp0uegUrLni5isJcOWYb7kQ7rbIHl76A/qQnPZM1MsuiRbhPJsVFAVn
         290hmeUF3x3uwJiYc3MywFHsIt07L44w14O48=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Tejun Heo <tj@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] staging: dream: fix information leak to userland
Date: Fri, 29 Oct 2010 00:01:51 +0400
Message-Id: <1288296112-19113-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Structure msm_audio_stats is copied to userland with some fields unitialized.
It leads to leaking of contents of kernel stack memory.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 drivers/staging/dream/qdsp5/audio_in.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/dream/qdsp5/audio_in.c b/drivers/staging/dream/qdsp5/audio_in.c
index b51fa09..a14f7ce 100644
--- a/drivers/staging/dream/qdsp5/audio_in.c
+++ b/drivers/staging/dream/qdsp5/audio_in.c
@@ -612,6 +612,7 @@ static long audio_in_ioctl(struct file *file,
 
 	if (cmd == AUDIO_GET_STATS) {
 		struct msm_audio_stats stats;
+		memset(&stats, 0, sizeof(stats));
 		stats.byte_count = atomic_read(&audio->in_bytes);
 		if (copy_to_user((void *) arg, &stats, sizeof(stats)))
 			return -EFAULT;
-- 
1.7.0.4

