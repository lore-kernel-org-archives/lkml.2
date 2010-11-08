Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128Ab0KHXWc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 18:22:32 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:19472 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755936Ab0KHXWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 18:22:30 -0500
Date: Tue, 9 Nov 2010 00:11:03 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: trivial@kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Roel Kluin <roel.kluin@gmail.com>,
        Dan Carpenter <error27@gmail.com>, alsa-devel@alsa-project.org
Subject: [PATCH 17/17][trivial] Sound, OSS:  Remove unnecessary casts of void
 ptr returning alloc function return values
Message-ID: <alpine.LNX.2.00.1011090003530.23697@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The [vk][cmz]alloc(_node) family of functions return void pointers which
it's completely unnecessary/pointless to cast to other pointer types since
that happens implicitly.

This patch removes such casts from sound/oss/


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 midibuf.c   |    4 ++--
 pss.c       |    6 +++---
 sequencer.c |    4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/sound/oss/midibuf.c b/sound/oss/midibuf.c
index 782b3b8..ceedb1e 100644
--- a/sound/oss/midibuf.c
+++ b/sound/oss/midibuf.c
@@ -178,7 +178,7 @@ int MIDIbuf_open(int dev, struct file *file)
 		return err;
 
 	parms[dev].prech_timeout = MAX_SCHEDULE_TIMEOUT;
-	midi_in_buf[dev] = (struct midi_buf *) vmalloc(sizeof(struct midi_buf));
+	midi_in_buf[dev] = vmalloc(sizeof(struct midi_buf));
 
 	if (midi_in_buf[dev] == NULL)
 	{
@@ -188,7 +188,7 @@ int MIDIbuf_open(int dev, struct file *file)
 	}
 	midi_in_buf[dev]->len = midi_in_buf[dev]->head = midi_in_buf[dev]->tail = 0;
 
-	midi_out_buf[dev] = (struct midi_buf *) vmalloc(sizeof(struct midi_buf));
+	midi_out_buf[dev] = vmalloc(sizeof(struct midi_buf));
 
 	if (midi_out_buf[dev] == NULL)
 	{
diff --git a/sound/oss/pss.c b/sound/oss/pss.c
index e19dd5d..9b800ce 100644
--- a/sound/oss/pss.c
+++ b/sound/oss/pss.c
@@ -859,7 +859,7 @@ static int pss_coproc_ioctl(void *dev_info, unsigned int cmd, void __user *arg,
 			return 0;
 
 		case SNDCTL_COPR_LOAD:
-			buf = (copr_buffer *) vmalloc(sizeof(copr_buffer));
+			buf = vmalloc(sizeof(copr_buffer));
 			if (buf == NULL)
 				return -ENOSPC;
 			if (copy_from_user(buf, arg, sizeof(copr_buffer))) {
@@ -871,7 +871,7 @@ static int pss_coproc_ioctl(void *dev_info, unsigned int cmd, void __user *arg,
 			return err;
 		
 		case SNDCTL_COPR_SENDMSG:
-			mbuf = (copr_msg *)vmalloc(sizeof(copr_msg));
+			mbuf = vmalloc(sizeof(copr_msg));
 			if (mbuf == NULL)
 				return -ENOSPC;
 			if (copy_from_user(mbuf, arg, sizeof(copr_msg))) {
@@ -895,7 +895,7 @@ static int pss_coproc_ioctl(void *dev_info, unsigned int cmd, void __user *arg,
 
 		case SNDCTL_COPR_RCVMSG:
 			err = 0;
-			mbuf = (copr_msg *)vmalloc(sizeof(copr_msg));
+			mbuf = vmalloc(sizeof(copr_msg));
 			if (mbuf == NULL)
 				return -ENOSPC;
 			data = (unsigned short *)mbuf->data;
diff --git a/sound/oss/sequencer.c b/sound/oss/sequencer.c
index e85789e..5ea1098 100644
--- a/sound/oss/sequencer.c
+++ b/sound/oss/sequencer.c
@@ -1646,13 +1646,13 @@ void sequencer_init(void)
 {
 	if (sequencer_ok)
 		return;
-	queue = (unsigned char *)vmalloc(SEQ_MAX_QUEUE * EV_SZ);
+	queue = vmalloc(SEQ_MAX_QUEUE * EV_SZ);
 	if (queue == NULL)
 	{
 		printk(KERN_ERR "sequencer: Can't allocate memory for sequencer output queue\n");
 		return;
 	}
-	iqueue = (unsigned char *)vmalloc(SEQ_MAX_QUEUE * IEV_SZ);
+	iqueue = vmalloc(SEQ_MAX_QUEUE * IEV_SZ);
 	if (iqueue == NULL)
 	{
 		printk(KERN_ERR "sequencer: Can't allocate memory for sequencer input queue\n");



-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

