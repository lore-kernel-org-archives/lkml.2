Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964867Ab1LPT7w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 14:59:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45363 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964791Ab1LPTwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:52:35 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Dec 16 11:42:07 2011
Message-Id: <20111216194207.357947659@clark.kroah.org>
User-Agent: quilt/0.50-24.1
Date: Fri, 16 Dec 2011 11:40:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "Manjunathappa, Prakash" <prakash.pm@ti.com>,
        Sekhar Nori <nsekhar@ti.com>
Subject: [04/45] ARM: davinci: da850 evm: change audio edma event queue to EVENTQ_0
In-Reply-To: <20111216194603.GA15028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Manjunathappa, Prakash" <prakash.pm@ti.com>

commit f1b21c525693b0159aed83b5871f2d0f077f208e upstream.

On OMAP-L138 platform, EDMA event queue 0 should be used for audio
transfers so that they are not starved by video data moving on event queue 1.

Commit 48519f0ae03bc7e86b3dc93e56f1334d53803770 (ASoC: davinci: let platform
data define edma queue numbers) had a side-effect of changing this behavior
by making the driver actually honor the platform data passed.

Fix this now by passing event queue 0 as the queue to be used for audio
transfers.

Signed-off-by: Manjunathappa, Prakash <prakash.pm@ti.com>
Signed-off-by: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/mach-davinci/board-da850-evm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -748,7 +748,7 @@ static struct snd_platform_data da850_ev
 	.num_serializer	= ARRAY_SIZE(da850_iis_serializer_direction),
 	.tdm_slots	= 2,
 	.serial_dir	= da850_iis_serializer_direction,
-	.asp_chan_q	= EVENTQ_1,
+	.asp_chan_q	= EVENTQ_0,
 	.version	= MCASP_VERSION_2,
 	.txnumevt	= 1,
 	.rxnumevt	= 1,


