Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283Ab1AIRYp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 12:24:45 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61851 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab1AIRYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 12:24:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=pccVipCipTVL6egQ0zUmzJG+WLL8AheCGcoiCCmihmbLgbECqf/6KyFPnx07SpMccp
         bvdHxelZRN19FIlbNk//oOh16uShnPXpTx5wYAVZcYUdnglFSBgj6/c5DmMN7zGoKSRK
         dze0M4ZhpQBBf/HOiVXz1oTlHDHsfzwFoXhGg=
From: Pierre Tardy <tardyp@gmail.com>
To: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Pierre Tardy <tardyp@gmail.com>
Subject: [PATCH 0/3] mmc: add quirks.c file and CLK_GATING users
Date: Sun,  9 Jan 2011 17:26:17 +0100
Message-Id: <cover.1294588491.git.tardyp@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, 
this is a followup patchset of discussion that happen before on linux-mmc mailing list
We add a mmc/core/quirk.c file holding list of quirks per devices or more generic quirks
e.g. all sdio devices have this quirk.

For now, only sdio card hook has been added. Hook for mmc or sd can be added in a followup patch.
Just call mmc_fixup_device() in the proper place, after deviceid and vendorid is known.

Pierre Tardy (3):
  mmc: add per device quirk placeholder
  mmc: add MMC_QUIRK_BROKEN_CLK_GATING
  mmc: remove anti clock gating quirk for wl1271

 drivers/mmc/core/Makefile |    3 +-
 drivers/mmc/core/core.h   |    2 +
 drivers/mmc/core/host.c   |    5 +--
 drivers/mmc/core/quirks.c |   83 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/mmc/core/sdio.c   |    1 +
 include/linux/mmc/card.h  |    3 ++
 6 files changed, 92 insertions(+), 5 deletions(-)
 create mode 100644 drivers/mmc/core/quirks.c

