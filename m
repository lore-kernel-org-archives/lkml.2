Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932369Ab1DYUZG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:25:06 -0400
Received: from 1wt.eu ([62.212.114.60]:34372 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932307Ab1DYUYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:55 -0400
Message-Id: <20110425200238.425405040@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:04:37 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 125/173] ASoC: Explicitly say registerless widgets have no register
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 0ca03cd7d0fa3bfbd56958136a10f19733c4ce12 upstream.

This stops code that handles widgets generically from attempting to access
registers for these widgets.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Liam Girdwood <lrg@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/sound/soc-dapm.h |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/include/sound/soc-dapm.h
+++ b/include/sound/soc-dapm.h
@@ -46,25 +46,25 @@
 /* platform domain */
 #define SND_SOC_DAPM_INPUT(wname) \
 {	.id = snd_soc_dapm_input, .name = wname, .kcontrols = NULL, \
-	.num_kcontrols = 0}
+	.num_kcontrols = 0, .reg = SND_SOC_NOPM }
 #define SND_SOC_DAPM_OUTPUT(wname) \
 {	.id = snd_soc_dapm_output, .name = wname, .kcontrols = NULL, \
-	.num_kcontrols = 0}
+	.num_kcontrols = 0, .reg = SND_SOC_NOPM }
 #define SND_SOC_DAPM_MIC(wname, wevent) \
 {	.id = snd_soc_dapm_mic, .name = wname, .kcontrols = NULL, \
-	.num_kcontrols = 0, .event = wevent, \
+	.num_kcontrols = 0, .reg = SND_SOC_NOPM, .event = wevent, \
 	.event_flags = SND_SOC_DAPM_PRE_PMU | SND_SOC_DAPM_POST_PMD}
 #define SND_SOC_DAPM_HP(wname, wevent) \
 {	.id = snd_soc_dapm_hp, .name = wname, .kcontrols = NULL, \
-	.num_kcontrols = 0, .event = wevent, \
+	.num_kcontrols = 0, .reg = SND_SOC_NOPM, .event = wevent, \
 	.event_flags = SND_SOC_DAPM_POST_PMU | SND_SOC_DAPM_PRE_PMD}
 #define SND_SOC_DAPM_SPK(wname, wevent) \
 {	.id = snd_soc_dapm_spk, .name = wname, .kcontrols = NULL, \
-	.num_kcontrols = 0, .event = wevent, \
+	.num_kcontrols = 0, .reg = SND_SOC_NOPM, .event = wevent, \
 	.event_flags = SND_SOC_DAPM_POST_PMU | SND_SOC_DAPM_PRE_PMD}
 #define SND_SOC_DAPM_LINE(wname, wevent) \
 {	.id = snd_soc_dapm_line, .name = wname, .kcontrols = NULL, \
-	.num_kcontrols = 0, .event = wevent, \
+	.num_kcontrols = 0, .reg = SND_SOC_NOPM, .event = wevent, \
 	.event_flags = SND_SOC_DAPM_POST_PMU | SND_SOC_DAPM_PRE_PMD}
 
 /* path domain */
@@ -129,11 +129,11 @@
 /* events that are pre and post DAPM */
 #define SND_SOC_DAPM_PRE(wname, wevent) \
 {	.id = snd_soc_dapm_pre, .name = wname, .kcontrols = NULL, \
-	.num_kcontrols = 0, .event = wevent, \
+	.num_kcontrols = 0, .reg = SND_SOC_NOPM, .event = wevent, \
 	.event_flags = SND_SOC_DAPM_PRE_PMU | SND_SOC_DAPM_PRE_PMD}
 #define SND_SOC_DAPM_POST(wname, wevent) \
 {	.id = snd_soc_dapm_post, .name = wname, .kcontrols = NULL, \
-	.num_kcontrols = 0, .event = wevent, \
+	.num_kcontrols = 0, .reg = SND_SOC_NOPM, .event = wevent, \
 	.event_flags = SND_SOC_DAPM_POST_PMU | SND_SOC_DAPM_POST_PMD}
 
 /* stream domain */


