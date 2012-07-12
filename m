Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161631Ab2GLWY5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:24:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55669 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759279Ab2GLWYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:24:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 004/187] ALSA: hda - Fix memory leaks at module unload
Date: Thu, 12 Jul 2012 15:23:32 -0700
Message-Id: <20120712191522.644647872@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.378465973@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.378465973@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 59cad16bc6deb85bd2a464da92bbaae289f0286f upstream.

Some caches aren't released properly at module unloading time.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_codec.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -1192,6 +1192,7 @@ static void snd_hda_codec_free(struct hd
 {
 	if (!codec)
 		return;
+	snd_hda_jack_tbl_clear(codec);
 	restore_init_pincfgs(codec);
 #ifdef CONFIG_SND_HDA_POWER_SAVE
 	cancel_delayed_work(&codec->power_work);
@@ -1200,6 +1201,7 @@ static void snd_hda_codec_free(struct hd
 	list_del(&codec->list);
 	snd_array_free(&codec->mixers);
 	snd_array_free(&codec->nids);
+	snd_array_free(&codec->cvt_setups);
 	snd_array_free(&codec->conn_lists);
 	snd_array_free(&codec->spdif_out);
 	codec->bus->caddr_tbl[codec->addr] = NULL;


