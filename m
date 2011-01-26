Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727Ab1AZSXn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 13:23:43 -0500
Received: from [123.122.106.155] ([123.122.106.155]:43810 "EHLO enigma.site"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752097Ab1AZSXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 13:23:41 -0500
From: Coly Li <bosong.ly@taobao.com>
To: linux-kernel@vger.kernel.org
Cc: Coly Li <bosong.ly@taobao.com>, Andrew Morton <akpm@linux-foundation.org>,
        Greg KH <gregkh@suse.de>
Subject: [PATCH 0/6] use BUG_ON correctly
Date: Thu, 27 Jan 2011 02:39:47 +0800
Message-Id: <1296067193-15879-1-git-send-email-bosong.ly@taobao.com>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BUG_ON() already uses unlikely() inside its definition if possible,
therefore code should not use BUG_ON() with explicit unlikely()
like BUG_ON(unlikely(...)), an explicit unlikely() doesn't make
things better.

This patch set fixes all incorrect usage of BUG_ON() as the above
line mentioned.

Signed-off-by: Coly Li <bosong.ly@taobao.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <gregkh@suse.de>
---
 drivers/dma/iop-adma.c                           |    6 +++---
 drivers/dma/mv_xor.c                             |    6 +++---
 drivers/dma/ppc4xx/adma.c                        |    8 ++++----
 drivers/scsi/scsi_lib.c                          |    4 ++--
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |   14 +++++++-------
 mm/nommu.c                                       |   10 +++++-----
 6 files changed, 24 insertions(+), 24 deletions(-)
