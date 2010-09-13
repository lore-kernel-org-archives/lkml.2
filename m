Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab0IMTsp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 15:48:45 -0400
Received: from mail.perches.com ([173.55.12.10]:1925 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755353Ab0IMTso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 15:48:44 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org
Subject: [PATCH 24/25] sound: Use static const char arrays
Date: Mon, 13 Sep 2010 12:48:02 -0700
Message-Id: <d0ef4062f24ff95c6f7d44a9123e19c17e712744.1284406639.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.rc1
In-Reply-To: <cover.1284406638.git.joe@perches.com>
References: <cover.1284406638.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 sound/core/misc.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/sound/core/misc.c b/sound/core/misc.c
index 2c41825..0e5e77f 100644
--- a/sound/core/misc.c
+++ b/sound/core/misc.c
@@ -64,12 +64,15 @@ static int print_snd_pfx(unsigned int level, const char *path, int line,
 			 const char *format)
 {
 	const char *file = sanity_file_name(path);
-	char tmp[] = "<0>";
+	char tmp[sizeof("<0>")];
 	const char *pfx = level ? KERN_DEBUG : KERN_DEFAULT;
 	int ret = 0;
 
 	if (format[0] == '<' && format[2] == '>') {
+		tmp[0] = '<';
 		tmp[1] = format[1];
+		tmp[2] = '>';
+		tmp[3] = 0;
 		pfx = tmp;
 		ret = 1;
 	}
-- 
1.7.3.rc1

