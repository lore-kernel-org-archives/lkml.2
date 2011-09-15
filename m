Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932641Ab1IOKer (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 06:34:47 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55166 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932312Ab1IOKeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 06:34:46 -0400
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Graeme Gregory <gg@slimlogic.co.uk>,
        Samuel Oritz <sameo@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 0/6 v3] Introduce caching support for regmap
Date: Thu, 15 Sep 2011 11:34:33 +0100
Message-Id: <1316082879-21810-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series introduces register caching support for regmap.  I've
mostly implemented the suggestions since v2, except the use of a dedicated
init function for each of the compress types.

Some things have been left out, such as support for bulk read operations,
various optimizations, shared caches etc.
Most of this stuff will be implemented incrementally.

Dimitris Papastamos (6):
  regmap: Introduce caching support
  regmap: Add the indexed cache support
  regmap: Add the rbtree cache support
  regmap: Add the LZO cache support
  regmap: Add the regcache_sync trace event
  regmap: Incorporate the regcache core into regmap

 drivers/base/regmap/Kconfig            |    2 +
 drivers/base/regmap/Makefile           |    2 +-
 drivers/base/regmap/internal.h         |   56 +++++
 drivers/base/regmap/regcache-indexed.c |   65 +++++
 drivers/base/regmap/regcache-lzo.c     |  361 +++++++++++++++++++++++++++++
 drivers/base/regmap/regcache-rbtree.c  |  399 ++++++++++++++++++++++++++++++++
 drivers/base/regmap/regcache.c         |  322 ++++++++++++++++++++++++++
 drivers/base/regmap/regmap.c           |   46 ++++
 include/linux/regmap.h                 |   27 ++-
 include/trace/events/regmap.h          |   24 ++
 10 files changed, 1298 insertions(+), 6 deletions(-)
 create mode 100644 drivers/base/regmap/regcache-indexed.c
 create mode 100644 drivers/base/regmap/regcache-lzo.c
 create mode 100644 drivers/base/regmap/regcache-rbtree.c
 create mode 100644 drivers/base/regmap/regcache.c

-- 
1.7.6.1

