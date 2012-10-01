Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273Ab2JAK3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 06:29:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42670 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753163Ab2JAK3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 06:29:17 -0400
Date: Mon, 1 Oct 2012 11:29:15 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] regmap updates for v3.7
Message-ID: <20121001102914.GG4360@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Cookie: You look tired.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 5698bd757d55b1bb87edd1a9744ab09c142abfc2:

  Linux 3.6-rc6 (2012-09-16 14:58:51 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git tags/regmap-3.7

for you to fetch changes up to 613dac31a612f9417bd1b1438acebbc3b8f9073e:

  Merge remote-tracking branches 'regmap/topic/cache' and 'regmap/topic/irq' into regmap-next (2012-09-22 12:02:05 -0400)

----------------------------------------------------------------

regmap: Updates for v3.7

A quiet release for the regmap core, essentially all the activity is in
the shared interrupt controller which is being more and more widely
used and has been enhanced to support a wider range of masking types and
wake handling methods, plus integration with runtime PM for devices
making aggressive use of that.

----------------------------------------------------------------
Dimitris Papastamos (1):
      regmap: Don't lock in regmap_reinit_cache()

Mark Brown (4):
      regmap: irq: Only update mask bits when doing initial mask
      regmap: irq: Enable devices for runtime PM while handling interrupts
      mfd: wm8994: Flag the interrupt block as requiring runtime PM be enabled
      Merge remote-tracking branches 'regmap/topic/cache' and 'regmap/topic/irq' into regmap-next

Stephen Warren (5):
      regmap: fix some error messages to take account of irq_reg_stride
      regmap: store irq_chip inside regmap_irq_chip_data
      regmap: name irq_chip based on regmap_irq_chip's name
      regmap: set MASK_ON_SUSPEND/SKIP_SET_WAKE if no wake_base
      regmap: irq: initialize all irqs to wake disabled

Xiaofan Tian (1):
      regmap: irq: Add mask invert flag for enable register

Yunfan Zhang (1):
      regmap: no need primary handler for nested irq

 drivers/base/regmap/regmap-irq.c |   92 +++++++++++++++++++++++++++++++-------
 drivers/base/regmap/regmap.c     |   13 ++----
 drivers/mfd/wm8994-irq.c         |    1 +
 include/linux/regmap.h           |    3 ++
 4 files changed, 83 insertions(+), 26 deletions(-)
