Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab1HOFH7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 01:07:59 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:57750 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986Ab1HOFHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 01:07:55 -0400
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaud Lacombe <lacombar@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
        Rasesh Mody <rmody@brocade.com>, netdev@vger.kernel.org
Subject: [PATCH 06/11] drivers/net/bna: do not use EXTRA_CFLAGS
Date: Mon, 15 Aug 2011 01:07:09 -0400
Message-Id: <1313384834-24433-7-git-send-email-lacombar@gmail.com>
X-Mailer: git-send-email 1.7.6.153.g78432
In-Reply-To: <1313384834-24433-1-git-send-email-lacombar@gmail.com>
References: <1313384834-24433-1-git-send-email-lacombar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Usage of these flags has been deprecated for nearly 4 years by:

    commit f77bf01425b11947eeb3b5b54685212c302741b8
    Author: Sam Ravnborg <sam@neptun.(none)>
    Date:   Mon Oct 15 22:25:06 2007 +0200

        kbuild: introduce ccflags-y, asflags-y and ldflags-y

Moreover, these flags (at least EXTRA_CFLAGS) have been documented for command
line use. By default, gmake(1) do not override command line setting, so this is
likely to result in build failure or unexpected behavior.

Replace their usage by Kbuild's `{as,cc,ld}flags-y'.

Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Rasesh Mody <rmody@brocade.com>
Cc: netdev@vger.kernel.org
---
 drivers/net/bna/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/bna/Makefile b/drivers/net/bna/Makefile
index a5d604d..babc25f 100644
--- a/drivers/net/bna/Makefile
+++ b/drivers/net/bna/Makefile
@@ -8,4 +8,4 @@ obj-$(CONFIG_BNA) += bna.o
 bna-objs := bnad.o bnad_ethtool.o bna_ctrl.o bna_txrx.o
 bna-objs += bfa_ioc.o bfa_ioc_ct.o bfa_cee.o cna_fwimg.o
 
-EXTRA_CFLAGS := -Idrivers/net/bna
+ccflags-y := -Idrivers/net/bna
-- 
1.7.6.153.g78432

