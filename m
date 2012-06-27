Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421Ab2F0AFD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 20:05:03 -0400
Received: from na3sys009aog133.obsmtp.com ([74.125.149.82]:48279 "EHLO
	na3sys009aog133.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755258Ab2F0AEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 20:04:41 -0400
Date: Tue, 26 Jun 2012 17:04:30 -0700
From: Mike Turquette <mturquette@ti.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, arnd.bergmann@linaro.org, olof@lixom.net
Subject: [GIT PULL] clk: fixes for 3.5-rc5
Message-ID: <20120627000429.GA22738@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The tag below has some fixes for users of the common clk framework.
This is my first time sending you a pull request (and first time using a
signed tag) so please let me know if I screwed something up.

Thanks,
Mike

The following changes since commit 6b16351acbd415e66ba16bf7d473ece1574cf0bc:

  Linux 3.5-rc4 (2012-06-24 12:53:04 -0700)

are available in the git repository at:

  git://git.linaro.org/people/mturquette/linux.git tags/clk-fixes-for-linus

for you to fetch changes up to d03ac61daa8d4d17cd83a5ab98e85b616b90c7ac:

  clk: mxs: fix clock lookup after freeing init memory (2012-06-25 16:51:48 -0700)

----------------------------------------------------------------
clk-fixes-for-linus contains three NULL pointer fixes and two device
regression fixups.  Two NULL pointer dereferences were in the common clk
core due to lack of sanity checking and the third NPD was in the
mxs-specific clock code due to incorrect use of __initdata.  The device
regressions were the result of improper data: a wrong string name for
matching DT data broke the SPEAr ethernet controller and another string
matching problem in the mxs clock data resulted in a broken MMC
controller.

----------------------------------------------------------------
Marc Kleine-Budde (1):
      clk: mxs: fix clock lookup after freeing init memory

Pawel Moll (1):
      clk: Check parent for NULL in clk_change_rate

Rajendra Nayak (1):
      clk: Allow late cache allocation for clk->parents

Shawn Guo (1):
      clk: mxs: fix ref_io clock definition

Stefan Roese (1):
      clk: SPEAr600: Fix ethernet clock name for DT based probing

 drivers/clk/clk.c                  |   26 +++++++++++++++++---------
 drivers/clk/mxs/clk-imx23.c        |   12 ++++++------
 drivers/clk/mxs/clk-imx28.c        |   32 ++++++++++++++++----------------
 drivers/clk/spear/spear6xx_clock.c |    2 +-
 4 files changed, 40 insertions(+), 32 deletions(-)
