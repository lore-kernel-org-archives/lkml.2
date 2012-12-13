Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab2LMNWX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 08:22:23 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:42116 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849Ab2LMNWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 08:22:22 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, ulf.hansson@linaro.org
Subject: [PATCH 1/8] Functionality add and bug-fixes related to MMCI regulators
Date: Thu, 13 Dec 2012 13:22:02 +0000
Message-Id: <1355404930-5691-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The main purpose of this patch-set is to move the MMCI's secondary
(platform specific) regulator implementation out of platform code
and into use the regulator frame-work. A few bugs were encountered
along the way, so we've fixed those too and bundled them in for
completeness.

 arch/arm/boot/dts/dbx5x0.dtsi                 |    5 ++-
 arch/arm/boot/dts/href.dtsi                   |    1 +
 arch/arm/boot/dts/hrefprev60.dts              |    2 +-
 arch/arm/mach-ux500/board-mop500-regulators.c |   14 +++++++
 arch/arm/mach-ux500/board-mop500-regulators.h |    1 +
 arch/arm/mach-ux500/board-mop500-sdi.c        |   52 -------------------------
 arch/arm/mach-ux500/board-mop500.c            |   44 +++++++++++++++++++++
 drivers/mmc/host/mmci.c                       |   22 +++++++++++
 drivers/mmc/host/mmci.h                       |    1 +
 9 files changed, 88 insertions(+), 54 deletions(-)

