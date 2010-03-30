Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab0C3Rqm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 13:46:42 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:31540 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160Ab0C3Rqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 13:46:39 -0400
Message-ID: <4BB238ED.9040909@oracle.com>
Date: Tue, 30 Mar 2010 10:46:21 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH -next] sound: fix patch_realtek printk format
References: <20100330191834.f2009292.sfr@canb.auug.org.au>
In-Reply-To: <20100330191834.f2009292.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4BB238F6.0048:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warnings in patch_realtek.c:

ound/pci/hda/patch_realtek.c:5120: warning: format '%s' expects type 'char *', but argument 2 has type 'int'
sound/pci/hda/patch_realtek.c:5120: warning: too few arguments for format

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc:	Jaroslav Kysela <perex@perex.cz>
Cc:	Takashi Iwai <tiwai@suse.de>
---
 sound/pci/hda/patch_realtek.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-next-20100330.orig/sound/pci/hda/patch_realtek.c
+++ linux-next-20100330/sound/pci/hda/patch_realtek.c
@@ -5117,7 +5117,8 @@ static void fillup_priv_adc_nids(struct 
 	}
 	if (!spec->num_adc_nids) {
 		printk(KERN_WARNING "hda_codec: %s: no valid ADC found;"
-		       " using fallback 0x%x\n", fallback_adc);
+		       " using fallback 0x%x\n",
+		       codec->chip_name, fallback_adc);
 		spec->private_adc_nids[0] = fallback_adc;
 		spec->adc_nids = spec->private_adc_nids;
 		if (fallback_adc != fallback_cap) {
