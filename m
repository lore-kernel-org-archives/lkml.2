Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020Ab2ACHrh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 02:47:37 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:17504 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab2ACHrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 02:47:35 -0500
X-AuditID: cbfee61b-b7b95ae00000198b-19-4f02b296fbda
From: Chanho Park <chanho61.park@samsung.com>
To: linus.walleij@linaro.org, swarren@nvidia.com, Baohua.Song@csr.com
Cc: linux-kernel@vger.kernel.org, Chanho Park <chanho61.park@samsung.com>
Subject: [PATCH 0/2] add support for partial pin space
Date: Tue, 03 Jan 2012 16:47:49 +0900
Message-id: <1325576871-9397-1-git-send-email-chanho61.park@samsung.com>
X-Mailer: git-send-email 1.7.5.4
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A pin space of current pinctrl driver always start with zero-based pin
number. And pins are enumerated from 0 to a max pin number. If there are
two pins (one is 0, another is 1000), we always enumerate from 0 to 1000
for just only two pins. This patch enables to start non-zero based pin
number and to enumerate actually owned pins.

For example, there is a system which has huge(500 or 1000) pins. If muxing
or controlling pins are small, we just define such small pins instead of
whole pins.

Chanho Park (2):
  pinctrl: correct a offset while enumerating pins
  pinctrl: remove unnecessary max pin number

 drivers/pinctrl/core.c          |   19 ++++++++++---------
 drivers/pinctrl/pinconf.c       |    9 +++++----
 drivers/pinctrl/pinctrl-sirf.c  |    1 -
 drivers/pinctrl/pinctrl-u300.c  |    1 -
 drivers/pinctrl/pinmux.c        |    9 +++++----
 include/linux/pinctrl/pinctrl.h |    5 -----
 6 files changed, 20 insertions(+), 24 deletions(-)

-- 
1.7.5.4

