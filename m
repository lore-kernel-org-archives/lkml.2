Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684Ab1HFD6P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 23:58:15 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50507 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754261Ab1HFD6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 23:58:14 -0400
Date: Sat, 6 Aug 2011 12:58:08 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: [PATCH 0/3] Add regmap support for WM831x and WM8994
Message-ID: <20110806035806.GA21557@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series converts the WM831x and WM8994 MFD drivers over to using the
regmap API (which was merged by Linus during this merge window).  As
these are my main devices for use when developing regmap it would be
very helpful if I could merge them via the regmap tree - does that seem
sensible to you?

The second patch (adding readback info to wm831x) depends on regmap API
updates that aren't in mainline yet.

Mark Brown (3):
      mfd: Convert WM831x to use regmap API
      mfd: Provide regmap register readback info from wm831x driver
      mfd: Convert WM8994 to use new register map API

 drivers/mfd/Kconfig             |    3 +
 drivers/mfd/wm831x-core.c       |  263 ++++++++++++++++++++++++++++++---------
 drivers/mfd/wm831x-i2c.c        |   68 ++--------
 drivers/mfd/wm831x-spi.c        |   60 ++-------
 drivers/mfd/wm8994-core.c       |  178 +++++---------------------
 include/linux/mfd/wm831x/core.h |    9 +-
 include/linux/mfd/wm8994/core.h |    9 +-
 7 files changed, 272 insertions(+), 318 deletions(-)
