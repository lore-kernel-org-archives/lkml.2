Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441Ab1GXJkx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 05:40:53 -0400
Received: from nm9-vm0.bullet.mail.ukl.yahoo.com ([217.146.183.240]:38155 "HELO
	nm9-vm0.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752423Ab1GXJkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 05:40:40 -0400
X-Yahoo-Newman-Id: 864644.10923.bm@omp1022.mail.ukl.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=DKIM-Signature:Message-ID:X-Yahoo-Newman-Property:X-YMail-OSG:X-Yahoo-SMTP:Received:Received:Date:From:To:Cc:Subject;
  b=QmnLnOSlIziClGkc29w81efVOTA9YfW2GwukmL+t0RM2lL7CqT6XEgBuOczj1aAne9c0PFCfhgMLOY+yQrWulw+OoKS+ih0OniFYJO/BGDdxlOWZVckMmQfQwlCr8EGyLC8vbDYf0t0L2RzCMAK5pQNxDaWs80yMAUz4VMlL8Es=  ;
Message-ID: <788178.91280.qm@smtp129.mail.ukl.yahoo.com>
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 3lEXMqUVM1m33CQ7VpLqeonLTNi_ZbQvTvyZXmtMh6kuE9F
 dK3yA3U2vfW1nbzwtd2dKM7h7y98tl1S0GJrz3Tb6SB3EWb6krp_odphyLF.
 uEEKYh71_l007MS1nsTu4WOsBYKuflDf_ScweoboB_v5WYr0uML5twr7qsq7
 luQ8UuQeJQD1VA.uOZwW2HJeoJIe8yTbQSFjp3xtH0GD0T0GeJ1rEmrV8KlL
 xgXHkeAViNDbsvQVtDd19PCHT_WEaaPbD__T06.oWdQElTpOMbJcpMZwzBrV
 BDbxC9zYuWgkN1nCYt8IKeDJJanVvNIh_hxgDyIlD37GkuaXLciW8fgs-
X-Yahoo-SMTP: zgdcvJ6swBBcTOk5fgveL37ak9AQxYCP7GdO
Date: Sun, 24 Jul 2011 11:40:56 +0200
From: Lionel Debroux <lionel_debroux@yahoo.fr>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Cc: Kees Cook <kees.cook@canonical.com>, Emese Revfy <re.emese@gmail.com>,
        kernel-janitors@vger.kernel.org
Subject: ac97: quiet make W=1 noise by initializing all fields of snd_ac97_codec_id_vendors and snd_ac97_codec_ids.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

make W=1 bitterly complains about missing initializations in
snd_ac97_codec_id_vendors and snd_ac97_codec_ids.
Initialize the last field, to make the output of make W=1 more readable.

Patch against current Linus tree.

---

>From 23898c57b997010ea25568a29f1f196bd6c58135 Mon Sep 17 00:00:00 2001
From: Lionel Debroux <lionel_debroux@yahoo.fr>
Date: Sun, 24 Jul 2011 10:26:51 +0200
Subject: ac97: quiet make W=1 noise by initializing all fields of
 snd_ac97_codec_id_vendors and snd_ac97_codec_ids.

Signed-off-by: Lionel Debroux <lionel_debroux@yahoo.fr>
---
 sound/pci/ac97/ac97_codec.c |  250 +++++++++++++++++++++---------------------
 1 files changed, 125 insertions(+), 125 deletions(-)

diff --git a/sound/pci/ac97/ac97_codec.c b/sound/pci/ac97/ac97_codec.c
index 53dbe2d..cbff9d2 100644
--- a/sound/pci/ac97/ac97_codec.c
+++ b/sound/pci/ac97/ac97_codec.c
@@ -67,141 +67,141 @@ struct ac97_codec_id {
 };
 
 static const struct ac97_codec_id snd_ac97_codec_id_vendors[] = {
-{ 0x41445300, 0xffffff00, "Analog Devices",	NULL,	NULL },
-{ 0x414b4d00, 0xffffff00, "Asahi Kasei",	NULL,	NULL },
-{ 0x414c4300, 0xffffff00, "Realtek",		NULL,	NULL },
-{ 0x414c4700, 0xffffff00, "Realtek",		NULL,	NULL },
+{ 0x41445300, 0xffffff00, "Analog Devices",	NULL,	NULL, 0 },
+{ 0x414b4d00, 0xffffff00, "Asahi Kasei",	NULL,	NULL, 0 },
+{ 0x414c4300, 0xffffff00, "Realtek",		NULL,	NULL, 0 },
+{ 0x414c4700, 0xffffff00, "Realtek",		NULL,	NULL, 0 },
 /*
  * This is an _inofficial_ Aztech Labs entry
  * (value might differ from unknown official Aztech ID),
  * currently used by the AC97 emulation of the almost-AC97 PCI168 card.
  */
-{ 0x415a5400, 0xffffff00, "Aztech Labs (emulated)",	NULL,	NULL },
-{ 0x434d4900, 0xffffff00, "C-Media Electronics", NULL,	NULL },
-{ 0x43525900, 0xffffff00, "Cirrus Logic",	NULL,	NULL },
-{ 0x43585400, 0xffffff00, "Conexant",           NULL,	NULL },
-{ 0x44543000, 0xffffff00, "Diamond Technology", NULL,	NULL },
-{ 0x454d4300, 0xffffff00, "eMicro",		NULL,	NULL },
-{ 0x45838300, 0xffffff00, "ESS Technology",	NULL,	NULL },
-{ 0x48525300, 0xffffff00, "Intersil",		NULL,	NULL },
-{ 0x49434500, 0xffffff00, "ICEnsemble",		NULL,	NULL },
-{ 0x49544500, 0xffffff00, "ITE Tech.Inc",	NULL,	NULL },
-{ 0x4e534300, 0xffffff00, "National Semiconductor", NULL, NULL },
-{ 0x50534300, 0xffffff00, "Philips",		NULL,	NULL },
-{ 0x53494c00, 0xffffff00, "Silicon Laboratory",	NULL,	NULL },
-{ 0x53544d00, 0xffffff00, "STMicroelectronics",	NULL,	NULL },
-{ 0x54524100, 0xffffff00, "TriTech",		NULL,	NULL },
-{ 0x54584e00, 0xffffff00, "Texas Instruments",	NULL,	NULL },
-{ 0x56494100, 0xffffff00, "VIA Technologies",   NULL,	NULL },
-{ 0x57454300, 0xffffff00, "Winbond",		NULL,	NULL },
-{ 0x574d4c00, 0xffffff00, "Wolfson",		NULL,	NULL },
-{ 0x594d4800, 0xffffff00, "Yamaha",		NULL,	NULL },
-{ 0x83847600, 0xffffff00, "SigmaTel",		NULL,	NULL },
-{ 0,	      0, 	  NULL,			NULL,	NULL }
+{ 0x415a5400, 0xffffff00, "Aztech Labs (emulated)",	NULL,	NULL, 0 },
+{ 0x434d4900, 0xffffff00, "C-Media Electronics", NULL,	NULL, 0 },
+{ 0x43525900, 0xffffff00, "Cirrus Logic",	NULL,	NULL, 0 },
+{ 0x43585400, 0xffffff00, "Conexant",           NULL,	NULL, 0 },
+{ 0x44543000, 0xffffff00, "Diamond Technology", NULL,	NULL, 0 },
+{ 0x454d4300, 0xffffff00, "eMicro",		NULL,	NULL, 0 },
+{ 0x45838300, 0xffffff00, "ESS Technology",	NULL,	NULL, 0 },
+{ 0x48525300, 0xffffff00, "Intersil",		NULL,	NULL, 0 },
+{ 0x49434500, 0xffffff00, "ICEnsemble",		NULL,	NULL, 0 },
+{ 0x49544500, 0xffffff00, "ITE Tech.Inc",	NULL,	NULL, 0 },
+{ 0x4e534300, 0xffffff00, "National Semiconductor", NULL, NULL, 0 },
+{ 0x50534300, 0xffffff00, "Philips",		NULL,	NULL, 0 },
+{ 0x53494c00, 0xffffff00, "Silicon Laboratory",	NULL,	NULL, 0 },
+{ 0x53544d00, 0xffffff00, "STMicroelectronics",	NULL,	NULL, 0 },
+{ 0x54524100, 0xffffff00, "TriTech",		NULL,	NULL, 0 },
+{ 0x54584e00, 0xffffff00, "Texas Instruments",	NULL,	NULL, 0 },
+{ 0x56494100, 0xffffff00, "VIA Technologies",   NULL,	NULL, 0 },
+{ 0x57454300, 0xffffff00, "Winbond",		NULL,	NULL, 0 },
+{ 0x574d4c00, 0xffffff00, "Wolfson",		NULL,	NULL, 0 },
+{ 0x594d4800, 0xffffff00, "Yamaha",		NULL,	NULL, 0 },
+{ 0x83847600, 0xffffff00, "SigmaTel",		NULL,	NULL, 0 },
+{ 0,	      0, 	  NULL,			NULL,	NULL, 0 }
 };
 
 static const struct ac97_codec_id snd_ac97_codec_ids[] = {
-{ 0x41445303, 0xffffffff, "AD1819",		patch_ad1819,	NULL },
-{ 0x41445340, 0xffffffff, "AD1881",		patch_ad1881,	NULL },
-{ 0x41445348, 0xffffffff, "AD1881A",		patch_ad1881,	NULL },
-{ 0x41445360, 0xffffffff, "AD1885",		patch_ad1885,	NULL },
-{ 0x41445361, 0xffffffff, "AD1886",		patch_ad1886,	NULL },
-{ 0x41445362, 0xffffffff, "AD1887",		patch_ad1881,	NULL },
-{ 0x41445363, 0xffffffff, "AD1886A",		patch_ad1881,	NULL },
-{ 0x41445368, 0xffffffff, "AD1888",		patch_ad1888,	NULL },
-{ 0x41445370, 0xffffffff, "AD1980",		patch_ad1980,	NULL },
-{ 0x41445372, 0xffffffff, "AD1981A",		patch_ad1981a,	NULL },
-{ 0x41445374, 0xffffffff, "AD1981B",		patch_ad1981b,	NULL },
-{ 0x41445375, 0xffffffff, "AD1985",		patch_ad1985,	NULL },
-{ 0x41445378, 0xffffffff, "AD1986",		patch_ad1986,	NULL },
-{ 0x414b4d00, 0xffffffff, "AK4540",		NULL,		NULL },
-{ 0x414b4d01, 0xffffffff, "AK4542",		NULL,		NULL },
-{ 0x414b4d02, 0xffffffff, "AK4543",		NULL,		NULL },
-{ 0x414b4d06, 0xffffffff, "AK4544A",		NULL,		NULL },
-{ 0x414b4d07, 0xffffffff, "AK4545",		NULL,		NULL },
-{ 0x414c4300, 0xffffff00, "ALC100,100P", 	NULL,		NULL },
-{ 0x414c4710, 0xfffffff0, "ALC200,200P",	NULL,		NULL },
-{ 0x414c4721, 0xffffffff, "ALC650D",		NULL,	NULL }, /* already patched */
-{ 0x414c4722, 0xffffffff, "ALC650E",		NULL,	NULL }, /* already patched */
-{ 0x414c4723, 0xffffffff, "ALC650F",		NULL,	NULL }, /* already patched */
-{ 0x414c4720, 0xfffffff0, "ALC650",		patch_alc650,	NULL },
-{ 0x414c4730, 0xffffffff, "ALC101",		NULL,		NULL },
-{ 0x414c4740, 0xfffffff0, "ALC202",		NULL,		NULL },
-{ 0x414c4750, 0xfffffff0, "ALC250",		NULL,		NULL },
-{ 0x414c4760, 0xfffffff0, "ALC655",		patch_alc655,	NULL },
-{ 0x414c4770, 0xfffffff0, "ALC203",		patch_alc203,	NULL },
-{ 0x414c4781, 0xffffffff, "ALC658D",		NULL,	NULL }, /* already patched */
-{ 0x414c4780, 0xfffffff0, "ALC658",		patch_alc655,	NULL },
-{ 0x414c4790, 0xfffffff0, "ALC850",		patch_alc850,	NULL },
-{ 0x415a5401, 0xffffffff, "AZF3328",		patch_aztech_azf3328,	NULL },
-{ 0x434d4941, 0xffffffff, "CMI9738",		patch_cm9738,	NULL },
-{ 0x434d4961, 0xffffffff, "CMI9739",		patch_cm9739,	NULL },
-{ 0x434d4969, 0xffffffff, "CMI9780",		patch_cm9780,	NULL },
-{ 0x434d4978, 0xffffffff, "CMI9761A",		patch_cm9761,	NULL },
-{ 0x434d4982, 0xffffffff, "CMI9761B",		patch_cm9761,	NULL },
-{ 0x434d4983, 0xffffffff, "CMI9761A+",		patch_cm9761,	NULL },
-{ 0x43525900, 0xfffffff8, "CS4297",		NULL,		NULL },
-{ 0x43525910, 0xfffffff8, "CS4297A",		patch_cirrus_spdif,	NULL },
-{ 0x43525920, 0xfffffff8, "CS4298",		patch_cirrus_spdif,		NULL },
-{ 0x43525928, 0xfffffff8, "CS4294",		NULL,		NULL },
-{ 0x43525930, 0xfffffff8, "CS4299",		patch_cirrus_cs4299,	NULL },
-{ 0x43525948, 0xfffffff8, "CS4201",		NULL,		NULL },
-{ 0x43525958, 0xfffffff8, "CS4205",		patch_cirrus_spdif,	NULL },
-{ 0x43525960, 0xfffffff8, "CS4291",		NULL,		NULL },
-{ 0x43525970, 0xfffffff8, "CS4202",		NULL,		NULL },
-{ 0x43585421, 0xffffffff, "HSD11246",		NULL,		NULL },	// SmartMC II
-{ 0x43585428, 0xfffffff8, "Cx20468",		patch_conexant,	NULL }, // SmartAMC fixme: the mask might be different
-{ 0x43585430, 0xffffffff, "Cx20468-31",		patch_conexant, NULL },
-{ 0x43585431, 0xffffffff, "Cx20551",           patch_cx20551,  NULL },
-{ 0x44543031, 0xfffffff0, "DT0398",		NULL,		NULL },
-{ 0x454d4328, 0xffffffff, "EM28028",		NULL,		NULL },  // same as TR28028?
-{ 0x45838308, 0xffffffff, "ESS1988",		NULL,		NULL },
-{ 0x48525300, 0xffffff00, "HMP9701",		NULL,		NULL },
-{ 0x49434501, 0xffffffff, "ICE1230",		NULL,		NULL },
-{ 0x49434511, 0xffffffff, "ICE1232",		NULL,		NULL }, // alias VIA VT1611A?
-{ 0x49434514, 0xffffffff, "ICE1232A",		NULL,		NULL },
-{ 0x49434551, 0xffffffff, "VT1616", 		patch_vt1616,	NULL }, 
-{ 0x49434552, 0xffffffff, "VT1616i",		patch_vt1616,	NULL }, // VT1616 compatible (chipset integrated)
-{ 0x49544520, 0xffffffff, "IT2226E",		NULL,		NULL },
-{ 0x49544561, 0xffffffff, "IT2646E",		patch_it2646,	NULL },
-{ 0x4e534300, 0xffffffff, "LM4540,43,45,46,48",	NULL,		NULL }, // only guess --jk
-{ 0x4e534331, 0xffffffff, "LM4549",		NULL,		NULL },
-{ 0x4e534350, 0xffffffff, "LM4550",		patch_lm4550,  	NULL }, // volume wrap fix 
-{ 0x50534304, 0xffffffff, "UCB1400",		patch_ucb1400,	NULL },
+{ 0x41445303, 0xffffffff, "AD1819",		patch_ad1819,	NULL, 0 },
+{ 0x41445340, 0xffffffff, "AD1881",		patch_ad1881,	NULL, 0 },
+{ 0x41445348, 0xffffffff, "AD1881A",		patch_ad1881,	NULL, 0 },
+{ 0x41445360, 0xffffffff, "AD1885",		patch_ad1885,	NULL, 0 },
+{ 0x41445361, 0xffffffff, "AD1886",		patch_ad1886,	NULL, 0 },
+{ 0x41445362, 0xffffffff, "AD1887",		patch_ad1881,	NULL, 0 },
+{ 0x41445363, 0xffffffff, "AD1886A",		patch_ad1881,	NULL, 0 },
+{ 0x41445368, 0xffffffff, "AD1888",		patch_ad1888,	NULL, 0 },
+{ 0x41445370, 0xffffffff, "AD1980",		patch_ad1980,	NULL, 0 },
+{ 0x41445372, 0xffffffff, "AD1981A",		patch_ad1981a,	NULL, 0 },
+{ 0x41445374, 0xffffffff, "AD1981B",		patch_ad1981b,	NULL, 0 },
+{ 0x41445375, 0xffffffff, "AD1985",		patch_ad1985,	NULL, 0 },
+{ 0x41445378, 0xffffffff, "AD1986",		patch_ad1986,	NULL, 0 },
+{ 0x414b4d00, 0xffffffff, "AK4540",		NULL,		NULL, 0 },
+{ 0x414b4d01, 0xffffffff, "AK4542",		NULL,		NULL, 0 },
+{ 0x414b4d02, 0xffffffff, "AK4543",		NULL,		NULL, 0 },
+{ 0x414b4d06, 0xffffffff, "AK4544A",		NULL,		NULL, 0 },
+{ 0x414b4d07, 0xffffffff, "AK4545",		NULL,		NULL, 0 },
+{ 0x414c4300, 0xffffff00, "ALC100,100P", 	NULL,		NULL, 0 },
+{ 0x414c4710, 0xfffffff0, "ALC200,200P",	NULL,		NULL, 0 },
+{ 0x414c4721, 0xffffffff, "ALC650D",		NULL,	NULL, 0 }, /* already patched */
+{ 0x414c4722, 0xffffffff, "ALC650E",		NULL,	NULL, 0 }, /* already patched */
+{ 0x414c4723, 0xffffffff, "ALC650F",		NULL,	NULL, 0 }, /* already patched */
+{ 0x414c4720, 0xfffffff0, "ALC650",		patch_alc650,	NULL, 0 },
+{ 0x414c4730, 0xffffffff, "ALC101",		NULL,		NULL, 0 },
+{ 0x414c4740, 0xfffffff0, "ALC202",		NULL,		NULL, 0 },
+{ 0x414c4750, 0xfffffff0, "ALC250",		NULL,		NULL, 0 },
+{ 0x414c4760, 0xfffffff0, "ALC655",		patch_alc655,	NULL, 0 },
+{ 0x414c4770, 0xfffffff0, "ALC203",		patch_alc203,	NULL, 0 },
+{ 0x414c4781, 0xffffffff, "ALC658D",		NULL,	NULL, 0 }, /* already patched */
+{ 0x414c4780, 0xfffffff0, "ALC658",		patch_alc655,	NULL, 0 },
+{ 0x414c4790, 0xfffffff0, "ALC850",		patch_alc850,	NULL, 0 },
+{ 0x415a5401, 0xffffffff, "AZF3328",		patch_aztech_azf3328,	NULL, 0 },
+{ 0x434d4941, 0xffffffff, "CMI9738",		patch_cm9738,	NULL, 0 },
+{ 0x434d4961, 0xffffffff, "CMI9739",		patch_cm9739,	NULL, 0 },
+{ 0x434d4969, 0xffffffff, "CMI9780",		patch_cm9780,	NULL, 0 },
+{ 0x434d4978, 0xffffffff, "CMI9761A",		patch_cm9761,	NULL, 0 },
+{ 0x434d4982, 0xffffffff, "CMI9761B",		patch_cm9761,	NULL, 0 },
+{ 0x434d4983, 0xffffffff, "CMI9761A+",		patch_cm9761,	NULL, 0 },
+{ 0x43525900, 0xfffffff8, "CS4297",		NULL,		NULL, 0 },
+{ 0x43525910, 0xfffffff8, "CS4297A",		patch_cirrus_spdif,	NULL, 0 },
+{ 0x43525920, 0xfffffff8, "CS4298",		patch_cirrus_spdif,		NULL, 0 },
+{ 0x43525928, 0xfffffff8, "CS4294",		NULL,		NULL, 0 },
+{ 0x43525930, 0xfffffff8, "CS4299",		patch_cirrus_cs4299,	NULL, 0 },
+{ 0x43525948, 0xfffffff8, "CS4201",		NULL,		NULL, 0 },
+{ 0x43525958, 0xfffffff8, "CS4205",		patch_cirrus_spdif,	NULL, 0 },
+{ 0x43525960, 0xfffffff8, "CS4291",		NULL,		NULL, 0 },
+{ 0x43525970, 0xfffffff8, "CS4202",		NULL,		NULL, 0 },
+{ 0x43585421, 0xffffffff, "HSD11246",		NULL,		NULL, 0 },	// SmartMC II
+{ 0x43585428, 0xfffffff8, "Cx20468",		patch_conexant,	NULL, 0 }, // SmartAMC fixme: the mask might be different
+{ 0x43585430, 0xffffffff, "Cx20468-31",		patch_conexant, NULL, 0 },
+{ 0x43585431, 0xffffffff, "Cx20551",           patch_cx20551,  NULL, 0 },
+{ 0x44543031, 0xfffffff0, "DT0398",		NULL,		NULL, 0 },
+{ 0x454d4328, 0xffffffff, "EM28028",		NULL,		NULL, 0 },  // same as TR28028?
+{ 0x45838308, 0xffffffff, "ESS1988",		NULL,		NULL, 0 },
+{ 0x48525300, 0xffffff00, "HMP9701",		NULL,		NULL, 0 },
+{ 0x49434501, 0xffffffff, "ICE1230",		NULL,		NULL, 0 },
+{ 0x49434511, 0xffffffff, "ICE1232",		NULL,		NULL, 0 }, // alias VIA VT1611A?
+{ 0x49434514, 0xffffffff, "ICE1232A",		NULL,		NULL, 0 },
+{ 0x49434551, 0xffffffff, "VT1616", 		patch_vt1616,	NULL, 0 },
+{ 0x49434552, 0xffffffff, "VT1616i",		patch_vt1616,	NULL, 0 }, // VT1616 compatible (chipset integrated)
+{ 0x49544520, 0xffffffff, "IT2226E",		NULL,		NULL, 0 },
+{ 0x49544561, 0xffffffff, "IT2646E",		patch_it2646,	NULL, 0 },
+{ 0x4e534300, 0xffffffff, "LM4540,43,45,46,48",	NULL,		NULL, 0 }, // only guess --jk
+{ 0x4e534331, 0xffffffff, "LM4549",		NULL,		NULL, 0 },
+{ 0x4e534350, 0xffffffff, "LM4550",		patch_lm4550,  	NULL, 0 }, // volume wrap fix
+{ 0x50534304, 0xffffffff, "UCB1400",		patch_ucb1400,	NULL, 0 },
 { 0x53494c20, 0xffffffe0, "Si3036,8",		mpatch_si3036,	mpatch_si3036, AC97_MODEM_PATCH },
-{ 0x53544d02, 0xffffffff, "ST7597",		NULL,		NULL },
-{ 0x54524102, 0xffffffff, "TR28022",		NULL,		NULL },
-{ 0x54524103, 0xffffffff, "TR28023",		NULL,		NULL },
-{ 0x54524106, 0xffffffff, "TR28026",		NULL,		NULL },
-{ 0x54524108, 0xffffffff, "TR28028",		patch_tritech_tr28028,	NULL }, // added by xin jin [07/09/99]
-{ 0x54524123, 0xffffffff, "TR28602",		NULL,		NULL }, // only guess --jk [TR28023 = eMicro EM28023 (new CT1297)]
-{ 0x54584e20, 0xffffffff, "TLC320AD9xC",	NULL,		NULL },
-{ 0x56494161, 0xffffffff, "VIA1612A",		NULL,		NULL }, // modified ICE1232 with S/PDIF
-{ 0x56494170, 0xffffffff, "VIA1617A",		patch_vt1617a,	NULL }, // modified VT1616 with S/PDIF
-{ 0x56494182, 0xffffffff, "VIA1618",		patch_vt1618,   NULL },
-{ 0x57454301, 0xffffffff, "W83971D",		NULL,		NULL },
-{ 0x574d4c00, 0xffffffff, "WM9701,WM9701A",	NULL,		NULL },
-{ 0x574d4C03, 0xffffffff, "WM9703,WM9707,WM9708,WM9717", patch_wolfson03, NULL},
-{ 0x574d4C04, 0xffffffff, "WM9704M,WM9704Q",	patch_wolfson04, NULL},
-{ 0x574d4C05, 0xffffffff, "WM9705,WM9710",	patch_wolfson05, NULL},
-{ 0x574d4C09, 0xffffffff, "WM9709",		NULL,		NULL},
-{ 0x574d4C12, 0xffffffff, "WM9711,WM9712,WM9715",	patch_wolfson11, NULL},
+{ 0x53544d02, 0xffffffff, "ST7597",		NULL,		NULL, 0 },
+{ 0x54524102, 0xffffffff, "TR28022",		NULL,		NULL, 0 },
+{ 0x54524103, 0xffffffff, "TR28023",		NULL,		NULL, 0 },
+{ 0x54524106, 0xffffffff, "TR28026",		NULL,		NULL, 0 },
+{ 0x54524108, 0xffffffff, "TR28028",		patch_tritech_tr28028,	NULL, 0 }, // added by xin jin [07/09/99]
+{ 0x54524123, 0xffffffff, "TR28602",		NULL,		NULL, 0 }, // only guess --jk [TR28023 = eMicro EM28023 (new CT1297)]
+{ 0x54584e20, 0xffffffff, "TLC320AD9xC",	NULL,		NULL, 0 },
+{ 0x56494161, 0xffffffff, "VIA1612A",		NULL,		NULL, 0 }, // modified ICE1232 with S/PDIF
+{ 0x56494170, 0xffffffff, "VIA1617A",		patch_vt1617a,	NULL, 0 }, // modified VT1616 with S/PDIF
+{ 0x56494182, 0xffffffff, "VIA1618",		patch_vt1618,   NULL, 0 },
+{ 0x57454301, 0xffffffff, "W83971D",		NULL,		NULL, 0 },
+{ 0x574d4c00, 0xffffffff, "WM9701,WM9701A",	NULL,		NULL, 0 },
+{ 0x574d4C03, 0xffffffff, "WM9703,WM9707,WM9708,WM9717", patch_wolfson03, NULL, 0 },
+{ 0x574d4C04, 0xffffffff, "WM9704M,WM9704Q",	patch_wolfson04, NULL, 0 },
+{ 0x574d4C05, 0xffffffff, "WM9705,WM9710",	patch_wolfson05, NULL, 0 },
+{ 0x574d4C09, 0xffffffff, "WM9709",		NULL,		NULL, 0 },
+{ 0x574d4C12, 0xffffffff, "WM9711,WM9712,WM9715",	patch_wolfson11, NULL, 0 },
 { 0x574d4c13, 0xffffffff, "WM9713,WM9714",	patch_wolfson13, NULL, AC97_DEFAULT_POWER_OFF},
-{ 0x594d4800, 0xffffffff, "YMF743",		patch_yamaha_ymf743,	NULL },
-{ 0x594d4802, 0xffffffff, "YMF752",		NULL,		NULL },
-{ 0x594d4803, 0xffffffff, "YMF753",		patch_yamaha_ymf753,	NULL },
-{ 0x83847600, 0xffffffff, "STAC9700,83,84",	patch_sigmatel_stac9700,	NULL },
-{ 0x83847604, 0xffffffff, "STAC9701,3,4,5",	NULL,		NULL },
-{ 0x83847605, 0xffffffff, "STAC9704",		NULL,		NULL },
-{ 0x83847608, 0xffffffff, "STAC9708,11",	patch_sigmatel_stac9708,	NULL },
-{ 0x83847609, 0xffffffff, "STAC9721,23",	patch_sigmatel_stac9721,	NULL },
-{ 0x83847644, 0xffffffff, "STAC9744",		patch_sigmatel_stac9744,	NULL },
-{ 0x83847650, 0xffffffff, "STAC9750,51",	NULL,		NULL },	// patch?
-{ 0x83847652, 0xffffffff, "STAC9752,53",	NULL,		NULL }, // patch?
-{ 0x83847656, 0xffffffff, "STAC9756,57",	patch_sigmatel_stac9756,	NULL },
-{ 0x83847658, 0xffffffff, "STAC9758,59",	patch_sigmatel_stac9758,	NULL },
-{ 0x83847666, 0xffffffff, "STAC9766,67",	NULL,		NULL }, // patch?
-{ 0, 	      0,	  NULL,			NULL,		NULL }
+{ 0x594d4800, 0xffffffff, "YMF743",		patch_yamaha_ymf743,	NULL, 0 },
+{ 0x594d4802, 0xffffffff, "YMF752",		NULL,		NULL, 0 },
+{ 0x594d4803, 0xffffffff, "YMF753",		patch_yamaha_ymf753,	NULL, 0 },
+{ 0x83847600, 0xffffffff, "STAC9700,83,84",	patch_sigmatel_stac9700,	NULL, 0 },
+{ 0x83847604, 0xffffffff, "STAC9701,3,4,5",	NULL,		NULL, 0 },
+{ 0x83847605, 0xffffffff, "STAC9704",		NULL,		NULL, 0 },
+{ 0x83847608, 0xffffffff, "STAC9708,11",	patch_sigmatel_stac9708,	NULL, 0 },
+{ 0x83847609, 0xffffffff, "STAC9721,23",	patch_sigmatel_stac9721,	NULL, 0 },
+{ 0x83847644, 0xffffffff, "STAC9744",		patch_sigmatel_stac9744,	NULL, 0 },
+{ 0x83847650, 0xffffffff, "STAC9750,51",	NULL,		NULL, 0 },	// patch?
+{ 0x83847652, 0xffffffff, "STAC9752,53",	NULL,		NULL, 0 }, // patch?
+{ 0x83847656, 0xffffffff, "STAC9756,57",	patch_sigmatel_stac9756,	NULL, 0 },
+{ 0x83847658, 0xffffffff, "STAC9758,59",	patch_sigmatel_stac9758,	NULL, 0 },
+{ 0x83847666, 0xffffffff, "STAC9766,67",	NULL,		NULL, 0 }, // patch?
+{ 0, 	      0,	  NULL,			NULL,		NULL, 0 }
 };
 
 
-- 
1.7.6.345.g5c2f8

