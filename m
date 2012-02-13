Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394Ab2BMGbs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 01:31:48 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14990 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab2BMGbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 01:31:46 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 12 Feb 2012 22:31:46 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        dunlap@xenotime.net, lrg@ti.com, broonie@opensource.wolfsonmicro.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-tegra@vger.kernel.org, ldewangan@nvidia.com
Subject: [PATCH V1 0/3] Support for open drain gpios in gpilib/fixed regulators.
Date: Mon, 13 Feb 2012 11:59:45 +0530
Message-Id: <1329114588-15430-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is as per discussion on the patch
[PATCH V1] regulator: fixed: Support for open-drain gpio 
where it was suggested to push the handling of open drain gpios
into the gpio libray.
Also gpio documentation says the possibility of open-drain gpio support.

This is series of patches  to add support of the open drain gpios
in standard gpio library and using this in fixed regulators.
- Added GPIOF_OD flag so that client can request the gpio with this flag.
- Added support for the sysfs interface for open-drain.
- Handle open drain gpio configuration properly.
- Use this flag in fixed regualtor to tell that gpio is open drain.
- Gpio documentation changes to have support for open-drain.

Laxman Dewangan (3):
  gpio: gpiolib: Support for open drain gpios
  Documentation: gpio: Add details of open-drain configuration
  regulator: fixed: Support for open-drain gpio

 Documentation/gpio.txt          |   21 +++++-
 drivers/gpio/gpiolib.c          |  144 ++++++++++++++++++++++++++++++++++++++-
 drivers/regulator/fixed.c       |   29 ++++----
 include/linux/gpio.h            |    3 +
 include/linux/regulator/fixed.h |    7 ++
 5 files changed, 184 insertions(+), 20 deletions(-)

