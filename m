Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757090Ab1ESOmr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 10:42:47 -0400
Received: from postkast.cyber.ee ([195.50.202.7]:39253 "EHLO postkast.cyber.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662Ab1ESOmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 10:42:46 -0400
X-Greylist: delayed 626 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 May 2011 10:42:46 EDT
Date: Thu, 19 May 2011 17:32:19 +0300 (EEST)
From: Madis Janson <madis@cyber.ee>
X-X-Sender: madis@paabel.itsise
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Enable Realtek ALC269 codec input layer beep
Message-ID: <alpine.DEB.2.00.1105191717530.2046@paabel.itsise>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-Respect: HAZ NONE
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This fixes the input layer beep not working on some EeePC 1000 models by 
adding the subsystem id into whitelist. Otherwise the corresponding ALSA 
mixer is not enabled and stays muted, resulting in no console beep.

diff -u linux-2.6.39/sound/pci/hda/patch_realtek.c lohe-2.6.39/sound/pci/hda/patch_realtek.c 
--- linux-2.6.39/sound/pci/hda/patch_realtek.c	2011-05-19 07:06:34.000000000 +0300
+++ lohe-2.6.39/sound/pci/hda/patch_realtek.c	2011-05-19 11:58:28.415669828 +0300
@@ -5646,6 +5646,7 @@
  	SND_PCI_QUIRK(0x1043, 0x829f, "ASUS", 1),
  	SND_PCI_QUIRK(0x1043, 0x83ce, "EeePC", 1),
  	SND_PCI_QUIRK(0x1043, 0x831a, "EeePC", 1),
+	SND_PCI_QUIRK(0x1043, 0x834a, "EeePC", 1),
  	SND_PCI_QUIRK(0x8086, 0xd613, "Intel", 1),
  	{}
  };

