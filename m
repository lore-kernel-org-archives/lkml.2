Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169Ab1FPS5H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 14:57:07 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:59645 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab1FPS5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 14:57:05 -0400
Date: Thu, 16 Jun 2011 11:56:46 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org
Subject: [PATCH] sound: fix lola section mismatch warnings
Message-Id: <20110616115646.7526c8af.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090201.4DFA51FB.00E3:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix section mismatch warnings in lola sound driver:

WARNING: sound/pci/lola/snd-lola.o(.text+0xda4): Section mismatch in reference from the function lola_parse_tree() to the function .devinit.text:lola_init_pcm()
The function lola_parse_tree() references
the function __devinit lola_init_pcm().
This is often because lola_parse_tree lacks a __devinit 
annotation or the annotation of lola_init_pcm is wrong.

WARNING: sound/pci/lola/snd-lola.o(.text+0xdf5): Section mismatch in reference from the function lola_parse_tree() to the function .devinit.text:lola_init_pins()
The function lola_parse_tree() references
the function __devinit lola_init_pins().
This is often because lola_parse_tree lacks a __devinit 
annotation or the annotation of lola_init_pins is wrong.

WARNING: sound/pci/lola/snd-lola.o(.text+0xe52): Section mismatch in reference from the function lola_parse_tree() to the function .devinit.text:lola_init_clock_widget()
The function lola_parse_tree() references
the function __devinit lola_init_clock_widget().
This is often because lola_parse_tree lacks a __devinit 
annotation or the annotation of lola_init_clock_widget is wrong.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Takashi Iwai <tiwai@suse.de>
---
 sound/pci/lola/lola.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-30-rc3.orig/sound/pci/lola/lola.c
+++ lnx-30-rc3/sound/pci/lola/lola.c
@@ -445,7 +445,7 @@ static void lola_reset_setups(struct lol
 	lola_setup_all_analog_gains(chip, PLAY, false); /* output, update */
 }
 
-static int lola_parse_tree(struct lola *chip)
+static int __devinit lola_parse_tree(struct lola *chip)
 {
 	unsigned int val;
 	int nid, err;
