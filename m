Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971Ab3AGLW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 06:22:26 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:34368 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab3AGLWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 06:22:24 -0500
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>, Linus Walleij <linus.walleij@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH v2 00/16] various fixes and updates for ste_dma40
Date: Mon,  7 Jan 2013 12:21:42 +0100
Message-Id: <1357557718-15676-1-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.7.12.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

this series contains many fixes and updates for the ste_dma40 driver.

The first patches of the series were originally sent weeks ago but did not
receive any feedback, so I'm also resending those, but I've rebased everything
on top of v3.8-rc2 to avoid a (trivial) file rename conflict.

Vinod, these should probably end up in the arm-soc tree so they can receive
some testing from drivers using it.  Can I have your Acked-by for this?

Thanks,
Fabio


Fabio Baltieri (7):
  dmaengine: ste_dma40: add a done queue for completed descriptors
  dmaengine: ste_dma40: add missing kernel-doc entry
  dmaengine: ste_dma40: minor cosmetic fixes
  dmaengine: ste_dma40: minor code readability fixes
  dmaengine: ste_dma40: add software lli support
  dmaengine: set_dma40: ignore spurious interrupts
  dmaengine: set_dma40: balance clock in probe fail code

Gerald Baeza (2):
  dmaengine: ste_dma40: support fixed physical channel allocation
  dmaengine: ste_dma40: physical channels number correction

Narayanan (1):
  dmaengine: ste_dma40: reset priority bit for logical channels

Narayanan G (1):
  dmaengine: ste_dma40: don't check for pm_runtime_suspended()

Per Forlin (3):
  dmaengine: ste_dma40: use writel_relaxed for lcxa
  dmaengine: ste_dma40: set dma max seg size
  dmaengine: ste_dma40: limit burst size to 16

Rabin Vincent (1):
  dmaengine: ste_dma40: don't allow high priority dest event lines

Tong Liu (1):
  dmaengine: ste_dma40: support more than 128 event lines

 drivers/dma/ste_dma40.c                     | 489 +++++++++++++++++++++-------
 drivers/dma/ste_dma40_ll.c                  |  29 +-
 drivers/dma/ste_dma40_ll.h                  | 130 +++++++-
 include/linux/platform_data/dma-ste-dma40.h |  13 +
 4 files changed, 518 insertions(+), 143 deletions(-)

-- 
1.7.12.1

