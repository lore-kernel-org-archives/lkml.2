Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826Ab1KUKsr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 05:48:47 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35475 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab1KUKsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 05:48:46 -0500
From: Dave Martin <dave.martin@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: patches@linaro.org, linux-arm-kernel@lists.infradead.org,
        Dave Martin <dave.martin@linaro.org>
Subject: [PATCH 0/2 REPOST] ARM: amba: Enable module alias autogeneration for AMBA drivers
Date: Mon, 21 Nov 2011 10:48:28 +0000
Message-Id: <1321872510-2562-1-git-send-email-dave.martin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[This is a partial repost of a series previously posted to alkml.

This post contains the core changes.  The driver-specific changes
can be found on alkml.]

 --

There's no special reason why AMBA device drivers should not be
auto-loadable via udev, but udev currently has no way to map AMBA
device IDs to drivers.

As part of the effort to help enable the building of multiple
ARM platforms into a single kernel image in the future, it's desirable
to be able to build any non-critical platform-specific drivers as
modules.

A straightforward solution is to use modaliases to allow udev to
identify the correct driver module to load.

This series enables the general infrastructure for modalias generation
to work for AMBA devices, and enables it in the affected drivers.

Briefly tested on Versatile Express, including aaci, mmci and amba-clcd
(which appears to have the most interesting modalias match pattern).
For me, the appropiate modules now get loaded at udev trigger time.

Any comments and feedback are welcome.

Dave Martin (2):
  ARM: amba: Move definition of struct amba_id to mod_devicetable.h
  ARM: amba: Auto-generate AMBA driver module aliases during modpost

 drivers/amba/bus.c              |    9 ++++-
 include/linux/amba/bus.h        |    7 +---
 include/linux/mod_devicetable.h |   18 ++++++++++
 scripts/mod/file2alias.c        |   72 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 99 insertions(+), 7 deletions(-)

-- 
1.7.4.1

