Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946187Ab2JYPTa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 11:19:30 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:56965 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933480Ab2JYPT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 11:19:28 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: [RESEND PATCH v3 0/6] watchdog: omap_wdt: convert to new watchdog core
Date: Thu, 25 Oct 2012 18:19:06 +0300
Message-Id: <1351178352-3989-1-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is a third version of the patch to convert omap_wdt to new watchdog
core. On OMAP boards, there are usually multiple watchdogs. Since the new
watchdog core supports multiple watchdogs, all watchdog drivers used on
OMAP should be converted. This is especially important on devices like
Nokia N9 or N800 where multiple watchdogs are present and watchdog HW
cannot be disabled on devices available to consumers/hobbyists.

I have also done additional cleanups to utilize devres. They are separate
patches to make reviewing easier.

Please review and consider applying/queueing these patches, perhaps
maybe for 3.8. Thanks.

Tested on top of current mainline
(4864ccbb5a6f99e4c44dc816304007547a268b9f) on Nokia N950.

Patch set history:

	v3 (https://lkml.org/lkml/2012/10/10/402): Patch 1 rebased on
	top of current mainline. Added received Tested by -tags. Added
	patches 2..6.

	v2 (https://lkml.org/lkml/2012/9/8/134): Fix a bug in the
	first version of the patch: __omap_wdt_disable() in probe was
	mistakenly moved outside PM runtime calls. This caused a crash
	as device was probably accessed with some clocks off. Thanks to
	Jarkko Nikula <jarkko.nikula@bitmer.com> for reporting this.

	v1 (https://lkml.org/lkml/2012/9/4/217): The initial version.

Aaro Koskinen (6):
  watchdog: omap_wdt: convert to new watchdog core
  watchdog: omap_wdt: convert kzalloc() to devm_kzalloc()
  watchdog: omap_wdt: convert request_mem_region() to
    devm_request_mem_region()
  watchdog: omap_wdt: convert ioremap() to devm_ioremap()
  watchdog: omap_wdt: delete redundant platform_set_drvdata() calls
  watchdog: omap_wdt: eliminate goto

 drivers/watchdog/Kconfig    |    1 +
 drivers/watchdog/omap_wdt.c |  329 +++++++++++++++++--------------------------
 2 files changed, 131 insertions(+), 199 deletions(-)

-- 
1.7.2.5

