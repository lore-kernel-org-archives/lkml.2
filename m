Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955Ab1FLUCq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 16:02:46 -0400
Received: from mail.perches.com ([173.55.12.10]:2817 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904Ab1FLUCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 16:02:45 -0400
Subject: [PATCH] sound: Fix beep_device compilation warnings
From: Joe Perches <joe@perches.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Takashi Iwai <tiwai@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <20110612194037.GA26274@liondog.tnic>
References: <s5hlix7fpv5.wl%tiwai@suse.de>
	 <20110612155021.GA30023@liondog.tnic> <s5hhb7vf2zz.wl%tiwai@suse.de>
	 <s5hfwnff2fn.wl%tiwai@suse.de>  <20110612194037.GA26274@liondog.tnic>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 12 Jun 2011 13:02:43 -0700
Message-ID: <1307908963.29640.4.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using static inline functions can reduce compilation messages
and macro misuse.

Signed-off-by: Joe Perches <joe@perches.com>

---

Maybe this helps?

On Sun, 2011-06-12 at 21:40 +0200, Borislav Petkov wrote:
> Btw, I keep noticing those when building on 32bit:
> sound/pci/hda/patch_conexant.c: In function ‘patch_cxt5045’:
> sound/pci/hda/patch_conexant.c:1232:3: warning: statement with no effect
> sound/pci/hda/patch_conexant.c: In function ‘patch_cxt5051’:
> sound/pci/hda/patch_conexant.c:2067:3: warning: statement with no effect
> sound/pci/hda/patch_conexant.c: In function ‘patch_cxt5066’:
> sound/pci/hda/patch_conexant.c:3261:3: warning: statement with no effect
> sound/pci/hda/patch_conexant.c: In function ‘patch_conexant_auto’:
> sound/pci/hda/patch_conexant.c:4370:3: warning: statement with no effect

 sound/pci/hda/hda_beep.h |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/hda_beep.h b/sound/pci/hda/hda_beep.h
index f1de1ba..4967eab 100644
--- a/sound/pci/hda/hda_beep.h
+++ b/sound/pci/hda/hda_beep.h
@@ -50,7 +50,12 @@ int snd_hda_enable_beep_device(struct hda_codec *codec, int enable);
 int snd_hda_attach_beep_device(struct hda_codec *codec, int nid);
 void snd_hda_detach_beep_device(struct hda_codec *codec);
 #else
-#define snd_hda_attach_beep_device(...)		0
-#define snd_hda_detach_beep_device(...)
+static inline int snd_hda_attach_beep_device(struct hda_codec *codec, int nid)
+{
+	return 0;
+}
+void snd_hda_detach_beep_device(struct hda_codec *codec)
+{
+}
 #endif
 #endif


