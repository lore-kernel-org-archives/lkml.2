Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120Ab2JDKPU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 06:15:20 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:34187 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715Ab2JDKPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 06:15:17 -0400
From: Matt Porter <mporter@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>, gururaja.hebbar@ti.com,
        Sekhar Nori <nsekhar@ti.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alsa Devel List <alsa-devel@alsa-project.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Ben Gardiner <bengardiner@nanometrics.ca>,
        Daniel Mack <zonque@gmail.com>
Subject: [PATCH 0/2] Convert davinci ASoC to genalloc SRAM
Date: Thu,  4 Oct 2012 06:15:43 -0400
Message-Id: <1349345745-10584-1-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series converts davinci ASoC to use genalloc and enables
that support on DA850. It applies on top of the uio_pruss/genalloc
series [1] which allows DaVinci to provide a gen_pool via pdata
for driver use.

I've tested this on the AM180x EVM. Note that prior to this,
the SRAM paths in the driver were completely unused. I've only
enabled ping-pong buffering on the platform I can test as it's
best to allow those with DM644x and similar platforms to set the
playback/capture sram size to something that's known to work
for them.

[1] http://www.spinics.net/lists/arm-kernel/msg198854.html

Matt Porter (2):
  ASoC: davinci: replace private sram api with genalloc
  ARM: davinci: enable SRAM ping ping buffering on DA850

 arch/arm/mach-davinci/board-da850-evm.c   |   24 ++++++++++++++----------
 include/linux/platform_data/davinci_asp.h |    3 +++
 sound/soc/davinci/davinci-mcasp.c         |    2 ++
 sound/soc/davinci/davinci-pcm.c           |   18 ++++++++++++------
 sound/soc/davinci/davinci-pcm.h           |    2 ++
 5 files changed, 33 insertions(+), 16 deletions(-)

-- 
1.7.9.5

