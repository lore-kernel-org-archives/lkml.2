Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331Ab1JNKFH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 06:05:07 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:58403 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755282Ab1JNKFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 06:05:05 -0400
From: Dave Martin <dave.martin@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: patches@linaro.org, linux-arm-kernel@lists.infradead.org,
        Dave Martin <dave.martin@linaro.org>
Subject: [PATCH 0/2] ARM: amba: Enable module alias autogeneration for AMBA drivers
Date: Fri, 14 Oct 2011 11:04:49 +0100
Message-Id: <1318586691-3833-1-git-send-email-dave.martin@linaro.org>
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

