Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640Ab1DGRpL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 13:45:11 -0400
Received: from hostingsmtp08.register.it ([81.88.50.249]:36975 "EHLO
	hostingsmtp.register.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751913Ab1DGRpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 13:45:10 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Apr 2011 13:45:09 EDT
Message-Id: <201104071738.p37HcSFX019185@vivaldi20.register.it>
From: "Guido Trentalancia" <guido@trentalancia.com>
Reply-To: "Guido Trentalancia" <guido@trentalancia.com>
To: linux-kernel@vger.kernel.org
Cc: kailang@realtek.com.tw, pshou@realtek.com.tw, tiwai@suse.de,
        jwoithe@physics.adelaide.edu.au
Subject: [PATCH] snd_hda_codec_realtek: enable ALC271 for Acer laptops
Date: Thu, 07 Apr 2011 19:38:27 +0200
X-RID: bStjJyU7Y24lKCV0biNydEArZDvoZw==|bStjJyU7Y24lKCV0biNydA==|MF5eJ/kw4CdeMF4n8uBe|TElBTUJFVw==
MIME-Version: 1.0
X-Priority: 3
X-Mailer: Webmail Client v1.5
Content-Type: text/plain;
	charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This quick fix to the Realtek HD Audio driver enables configurable support for the ALC271 type commonly found on some Acer laptops (e.g. Aspire 5745G).

Normally, the driver would fall back to BIOS auto-probing. However, the "model=acer" parameter can be passed on the boot command line to enable such support. Otherwise, it is quite common that the internal microphone does not work.

--- linux-2.6.38.2-original/sound/pci/hda/patch_realtek.c	2011-04-07 17:56:25.053046707 +0200
+++ linux-2.6.38.2/sound/pci/hda/patch_realtek.c	2011-04-07 19:03:00.975706888 +0200
@@ -15028,6 +15028,7 @@ static const char * const alc269_models[
 	[ALC269_DMIC]			= "laptop-dmic",
 	[ALC269_FUJITSU]		= "fujitsu",
 	[ALC269_LIFEBOOK]		= "lifebook",
+	[ALC271_ACER]			= "acer",
 	[ALC269_AUTO]			= "auto",
 };
  

