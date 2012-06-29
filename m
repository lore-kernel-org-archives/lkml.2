Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab2F2K0t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 06:26:49 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14236 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab2F2K0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 06:26:47 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 29 Jun 2012 03:23:16 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <tiwai@suse.de>, <lrg@ti.com>, <broonie@opensource.wolfsonmicro.com>,
        <lars@metafoo.de>, <swarren@nvidia.com>, <perex@perex.cz>,
        <clemens@ladisch.de>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 0/3] ASoC: Move pcm writecombine dma buffer allocation to core
Date: Fri, 29 Jun 2012 15:53:15 +0530
Message-ID: <1340965398-20872-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of the ARM based soc allocate the writecombine dma buffer for
pcm substreams. They have the same codes for managing this buffer.
Moving this to the core/pcm files so that they can use that directly.

Remove the code from Tegra PCM and use these new library function.

This is enabled only for ARM specific and can be extended to other
architecture if they support the writecombine dma buffer.

This patch is based on detail discussion on patch:
[PATCH] ASoC: snd_dmaengine: add common api for pcm_mmap
And suggestion from Lars and Takashi.


Laxman Dewangan (3):
  ALSA: pcm: add apis for writecombine dma buffer allocation
  ASoC: add apis for creating/free pcm dma buffer
  ASoC: tegra: use core/pcm library for pcm buffer allocation

 include/sound/pcm.h         |   17 ++++++++
 include/sound/soc.h         |   13 ++++++
 sound/core/pcm_native.c     |   53 +++++++++++++++++++++++++
 sound/soc/soc-core.c        |   50 +++++++++++++++++++++++
 sound/soc/tegra/tegra_pcm.c |   92 ++-----------------------------------------
 5 files changed, 137 insertions(+), 88 deletions(-)

