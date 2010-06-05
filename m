Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932887Ab0FER32 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 13:29:28 -0400
Received: from rere.qmqm.pl ([89.167.52.164]:35038 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932686Ab0FER30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 13:29:26 -0400
From: =?UTF-8?Q?Micha=C5=82=20Miros=C5=82aw=20?= 
	<mirq-linux@rere.qmqm.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
       Adrian Hunter <adrian.hunter@nokia.com>, Chris Ball <cjb@laptop.org>
Message-ID: <1-1000-17336-1275758964-1828@rere.qmqm.pl>
Date: Sat,  5 Jun 2010 19:29:24 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 46eda5101dd303feac7f8353023f78bf4f7fd2fe Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Date: Sat, 5 Jun 2010 19:04:01 +0200
Subject: [PATCH 0/2] mmc: Add support for SD combo cards
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This adds support for SD combo cards to MMC/SD driver stack.

SD combo consists of SD memory and SDIO parts in one package. Since
the parts have a separate SD command sets, after initialization, they
can be treated as independent cards on one bus.

Changes are divided into two patches. First is just moving initialization
code around so that SD memory part init can be called from SDIO init.
Second patch is a proper change enabling SD memory along SDIO.
I tried to move as much no-op changes to the first patch so that it's
easier to follow the required changes to initialization flow for SDIO cards.

This is based on Simplified SDIO spec v.2.00. The init sequence is slightly
modified to follow current SD memory init implementation. Command sequences,
assuming SD memory and SDIO indeed ignore unknown commands, are the same as
before for both parts.

Changes from v1:
 - more no-op changes moved to first patch
 - eliminated internal abuse of EOPNOTSUPP
 - fixed a bug in resume path (not tested)
 - eliminated unnecessary CID memcpy in SD combo init

Best Regards,
Michał Mirosław


Michał Mirosław (2):
  mmc: split mmc_sd_init_card()
  mmc: implement SD-combo (IO+mem) support

 drivers/mmc/core/bus.c   |    9 ++
 drivers/mmc/core/core.c  |   12 ++-
 drivers/mmc/core/sd.c    |  249 +++++++++++++++++++++++++++-------------------
 drivers/mmc/core/sd.h    |   17 +++
 drivers/mmc/core/sdio.c  |  174 +++++++++++++++++++++++++-------
 include/linux/mmc/card.h |    1 +
 6 files changed, 320 insertions(+), 142 deletions(-)
 create mode 100644 drivers/mmc/core/sd.h

