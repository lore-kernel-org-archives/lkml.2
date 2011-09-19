Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083Ab1ISLfD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 07:35:03 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55443 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754664Ab1ISLfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 07:35:02 -0400
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Graeme Gregory <gg@slimlogic.co.uk>,
        Samuel Oritz <sameo@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 0/6 v4] Introduce caching support for regmap
Date: Mon, 19 Sep 2011 12:34:54 +0100
Message-Id: <1316432100-30740-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series introduces register caching support for regmap.  I've
mostly implemented all the suggestions, except the use of a dedicated
init function for each of the compress types.

Some things have been left out, such as support for bulk read operations,
various optimizations, shared caches etc.
Most of this stuff will be implemented incrementally.

This version has only been build tested, so any testing would be
highly appreciated.  The changes though since v3 are trivial so it should
work.

Thanks to Lars-Peter Clausen and Mark Brown for all the constructive
comments.

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
 drivers/base/regmap/regcache.c         |  311 +++++++++++++++++++++++++
 drivers/base/regmap/regmap.c           |   28 +++
 include/linux/regmap.h                 |   27 ++-
 include/trace/events/regmap.h          |   24 ++
 10 files changed, 1269 insertions(+), 6 deletions(-)
 create mode 100644 drivers/base/regmap/regcache-indexed.c
 create mode 100644 drivers/base/regmap/regcache-lzo.c
 create mode 100644 drivers/base/regmap/regcache-rbtree.c
 create mode 100644 drivers/base/regmap/regcache.c

-- 
1.7.6.1

