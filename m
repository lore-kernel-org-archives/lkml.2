Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156Ab1IBPq0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 11:46:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35183 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752945Ab1IBPqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 11:46:23 -0400
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Graeme Gregory <gg@slimlogic.co.uk>,
        Samuel Oritz <sameo@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 0/8] Introduce caching support for regmap
Date: Fri,  2 Sep 2011 16:46:07 +0100
Message-Id: <1314978375-11539-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series introduces register caching support for regmap.
Some things have been left out, such as support for bulk read operations,
various optimizations, shared caches etc.
Most of this stuff will be implemented incrementally.

Dimitris Papastamos (8):
  regmap: Introduce caching support
  regmap: Add the indexed cache support
  regmap: Add the rbtree cache support
  regmap: Add the LZO cache support
  regmap: Add the regcache_sync trace event
  regmap: Incorporate the regcache core into regmap
  regmap: It is impossible to be given a NULL defaults cache
  regmap: Support NULL cache_defaults_raw

 drivers/base/regmap/Makefile           |    2 +-
 drivers/base/regmap/internal.h         |   56 +++++
 drivers/base/regmap/regcache-indexed.c |   65 +++++
 drivers/base/regmap/regcache-lzo.c     |  361 ++++++++++++++++++++++++++++
 drivers/base/regmap/regcache-rbtree.c  |  400 ++++++++++++++++++++++++++++++++
 drivers/base/regmap/regcache.c         |  287 +++++++++++++++++++++++
 drivers/base/regmap/regmap.c           |   55 +++++
 include/linux/regmap.h                 |   22 ++-
 include/trace/events/regmap.h          |   24 ++
 9 files changed, 1266 insertions(+), 6 deletions(-)
 create mode 100644 drivers/base/regmap/regcache-indexed.c
 create mode 100644 drivers/base/regmap/regcache-lzo.c
 create mode 100644 drivers/base/regmap/regcache-rbtree.c
 create mode 100644 drivers/base/regmap/regcache.c

-- 
1.7.6.1

