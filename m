Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105Ab1EFXNa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 19:13:30 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:32259 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab1EFXN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 19:13:28 -0400
Date: Fri, 6 May 2011 16:13:10 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] soc: fix wm8958-dsp2 printk format warnings
Message-Id: <20110506161310.54b22b9f.randy.dunlap@oracle.com>
In-Reply-To: <20110505134959.b3761297.sfr@canb.auug.org.au>
References: <20110505134959.b3761297.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4DC48091.024D:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warnings in wm8958-dsp2.c:

sound/soc/codecs/wm8958-dsp2.c:103: warning: format '%d' expects type 'int', but argument 4 has type 'size_t'
sound/soc/codecs/wm8958-dsp2.c:111: warning: format '%d' expects type 'int', but argument 3 has type 'size_t'
sound/soc/codecs/wm8958-dsp2.c:144: warning: format '%d' expects type 'int', but argument 5 has type 'size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 sound/soc/codecs/wm8958-dsp2.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-next-20110505.orig/sound/soc/codecs/wm8958-dsp2.c
+++ linux-next-20110505/sound/soc/codecs/wm8958-dsp2.c
@@ -99,7 +99,7 @@ static int wm8958_dsp2_fw(struct snd_soc
 	len = fw->size - len;
 	while (len) {
 		if (len < 12) {
-			dev_err(codec->dev, "%s short data block of %d\n",
+			dev_err(codec->dev, "%s short data block of %zd\n",
 				name, len);
 			goto err;
 		}
@@ -107,7 +107,7 @@ static int wm8958_dsp2_fw(struct snd_soc
 		memcpy(&data32, data + 4, sizeof(data32));
 		block_len = be32_to_cpu(data32);
 		if (block_len + 8 > len) {
-			dev_err(codec->dev, "%d byte block longer than file\n",
+			dev_err(codec->dev, "%zd byte block longer than file\n",
 				block_len);
 			goto err;
 		}
@@ -141,7 +141,7 @@ static int wm8958_dsp2_fw(struct snd_soc
 		case WM_FW_BLOCK_I:
 		case WM_FW_BLOCK_A:
 		case WM_FW_BLOCK_C:
-			dev_dbg(codec->dev, "%s: %d bytes of %x@%x\n", name,
+			dev_dbg(codec->dev, "%s: %zd bytes of %x@%x\n", name,
 				block_len, (data32 >> 24) & 0xff,
 				data32 & 0xffffff);
 
