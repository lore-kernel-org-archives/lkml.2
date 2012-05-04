Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932858Ab2EDVC0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 17:02:26 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:45099 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932711Ab2EDUsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:48:20 -0400
Message-Id: <20120504204245.554405815@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 04 May 2012 13:42:52 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 08/47] ASoC: dapm: Ensure power gets managed for line widgets
In-Reply-To: <20120504204307.GA13761@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 7e1f7c8a6e517900cd84da1b8ae020f08f286c3b upstream.

Line widgets had not been included in either the power up or power down
sequences so if a widget had an event associated with it that event would
never be run. Fix this minimally by adding them to the sequences, we
should probably be doing away with the specific widget types as they all
have the same priority anyway.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/soc-dapm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -67,6 +67,7 @@ static int dapm_up_seq[] = {
 	[snd_soc_dapm_out_drv] = 10,
 	[snd_soc_dapm_hp] = 10,
 	[snd_soc_dapm_spk] = 10,
+	[snd_soc_dapm_line] = 10,
 	[snd_soc_dapm_post] = 11,
 };
 
@@ -75,6 +76,7 @@ static int dapm_down_seq[] = {
 	[snd_soc_dapm_adc] = 1,
 	[snd_soc_dapm_hp] = 2,
 	[snd_soc_dapm_spk] = 2,
+	[snd_soc_dapm_line] = 2,
 	[snd_soc_dapm_out_drv] = 2,
 	[snd_soc_dapm_pga] = 4,
 	[snd_soc_dapm_mixer_named_ctl] = 5,


