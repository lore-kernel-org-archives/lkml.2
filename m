Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198Ab0H0F6J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 01:58:09 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:59078 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754050Ab0H0F5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 01:57:44 -0400
From: Julia Lawall <julia@diku.dk>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: kernel-janitors@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] drivers/staging/tm6000: Remove potential NULL dereference
Date: Fri, 27 Aug 2010 07:57:20 +0200
Message-Id: <1282888640-27042-4-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1282888640-27042-1-git-send-email-julia@diku.dk>
References: <1282888640-27042-1-git-send-email-julia@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the NULL test is necessary, the initialization involving a dereference of
the tested value should be moved after the NULL test.

The sematic patch that fixes this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
type T;
expression E;
identifier i,fld;
statement S;
@@

- T i = E->fld;
+ T i;
  ... when != E
      when != i
  if (E == NULL) S
+ i = E->fld;
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/staging/tm6000/tm6000-alsa.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/tm6000/tm6000-alsa.c b/drivers/staging/tm6000/tm6000-alsa.c
index 087137d..a06b3c6 100644
--- a/drivers/staging/tm6000/tm6000-alsa.c
+++ b/drivers/staging/tm6000/tm6000-alsa.c
@@ -426,11 +426,12 @@ error:
 
 static int tm6000_audio_fini(struct tm6000_core *dev)
 {
-	struct snd_tm6000_card	*chip = dev->adev;
+	struct snd_tm6000_card	*chip;
 
 	if (!dev)
 		return 0;
 
+	chip = dev->adev;
 	if (!chip)
 		return 0;
 

