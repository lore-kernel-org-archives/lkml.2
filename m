Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab1GPNEP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 09:04:15 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54894 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163Ab1GPNEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 09:04:09 -0400
Date: Sat, 16 Jul 2011 23:03:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Curtis McEnroe <programble@gmail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: linux-next: manual merge of the staging tree with the v4l-dvb tree
Message-Id: <20110716230358.49ad03a289ee0881eb2c8821@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/tm6000/tm6000-alsa.c between commit 58d73afffaac
("[media] tm6000: remove a check for NO_PCM_LOCK") from the v4l-dvb tree
and commit d684aee316ec ("tm6000: Cleaned up code style in
tm6000-alsa.c") from the staging tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/tm6000/tm6000-alsa.c
index 018ff73,ddfd7c3..0000000
--- a/drivers/staging/tm6000/tm6000-alsa.c
+++ b/drivers/staging/tm6000/tm6000-alsa.c
@@@ -254,7 -254,9 +254,7 @@@ static int tm6000_fillbuf(struct tm6000
  		memcpy(runtime->dma_area + buf_pos * stride, buf,
  			length * stride);
  
-        snd_pcm_stream_lock(substream);
 -#ifndef NO_PCM_LOCK
+ 	snd_pcm_stream_lock(substream);
 -#endif
  
  	chip->buf_pos += length;
  	if (chip->buf_pos >= runtime->buffer_size)
@@@ -266,7 -268,9 +266,7 @@@
  		period_elapsed = 1;
  	}
  
-        snd_pcm_stream_unlock(substream);
 -#ifndef NO_PCM_LOCK
+ 	snd_pcm_stream_unlock(substream);
 -#endif
  
  	if (period_elapsed)
  		snd_pcm_period_elapsed(substream);
