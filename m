Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408Ab2GBNDy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 09:03:54 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19517 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362Ab2GBNDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 09:03:51 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 02 Jul 2012 06:00:13 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <tiwai@suse.de>, <lrg@ti.com>, <broonie@opensource.wolfsonmicro.com>,
        <lars@metafoo.de>, <swarren@nvidia.com>, <perex@perex.cz>,
        <clemens@ladisch.de>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V3 0/2]  ASoC: Move pcm writecombine dma buffer allocation to core
Date: Mon, 2 Jul 2012 18:29:39 +0530
Message-ID: <1341233981-32412-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of the ARM based soc allocate the writecombine dma buffer for
pcm substreams. They have the same codes for managing this buffer.
Moving this to the core/pcm memory librray so that they can use that
directly.

Remove the code from Tegra PCM and use these new feature from library
function.

This is enabled only for ARM specific and can be extended to other
architecture if they support the writecombine dma buffer.

This patch is based on detail discussion on patch:
[PATCH] ASoC: snd_dmaengine: add common api for pcm_mmap
And suggestion from Lars and Takashi.

Changes from V1:
Takashi had send the sample code to integrate the writecombine with
dma coherant and this is based on that code.
Also change the tegra-pcm driver accordingly.

Changes from V2:
- Added some more comment for WAR for ARM specific.
- remove mmap initialization from tegra_pcm.
- Put back the dma mask initialisation in tegra_pcm.


Laxman Dewangan (2):
  ALSA: Support writecombine DMA buffer memory page alloc/free
  ASoC: tegra: use sound pcm library for substream dma buffer

 include/sound/memalloc.h    |    1 +
 sound/core/memalloc.c       |   70 ++++++++++++++++++++++++---
 sound/core/pcm_native.c     |   10 ++++
 sound/soc/tegra/tegra_pcm.c |  112 ++++++++++--------------------------------
 4 files changed, 100 insertions(+), 93 deletions(-)

