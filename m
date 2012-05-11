Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946037Ab2EKTlD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 15:41:03 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38427 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933201Ab2EKTk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 15:40:58 -0400
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: horms@verge.net.au, linux@arm.linux.org.uk, arnd@arndb.de,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org, rjw@sisk.pl,
        lethal@linux-sh.org, olof@lixom.net,
        Magnus Damm <magnus.damm@gmail.com>
Date: Sat, 12 May 2012 04:41:51 +0900
Message-Id: <20120511194151.6567.53888.sendpatchset@w520>
Subject: [PATCH 00/06] mach-shmobile: Emma Mobile EV2 support V2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mach-shmobile: Emma Mobile EV2 support V2

[PATCH 01/06] mach-shmobile: Emma Mobile EV2 SoC base support V2
[PATCH 02/06] mach-shmobile: KZM9D board support V2
[PATCH 03/06] mach-shmobile: Emma Mobile EV2 SMP support V2
[PATCH 04/06] mach-shmobile: Emma Mobile EV2 GPIO support V2
[PATCH 05/06] mach-shmobile: KZM9D board Ethernet support V2
[PATCH 06/06] mach-shmobile: Emma Mobile EV2 DT support V2

This series are the second iteration of Emma Mobile EV2 support
for mach-shmobile. Yet another dual core Cortex-A9 SoC.

At this point serial, timer and gpio are supported as platform
devices. Serial and timer also come with DT bindings.

Basic SMP support is in place, but CPU hotplug and TWD needs
more work.

Clocks are enabled in the case of the KZM9D board support
via platform devices. In the DT case there are no clocks
enabled. SMP is also missing from DT. So anyone playing
around with DT will have to accept the fact that it is very
limited at tis point. All features with upstream support
can however be enabled via regular platform devices.

Many thanks to Arnd for his endless reviews and helpful
suggestions and a lot of patience!

To build this you also need whatever included in linux-next
as of 20120511 plus the following patches:

[PATCH 01/03] clockevents: Make clockevents_config() a global symbol
[PATCH 02/03] clocksource: em_sti: Emma Mobile STI driver V2
[PATCH 03/03] clocksource: em_sti: Add DT support
[PATCH] gpio: Emma Mobile GPIO driver

Also, the KZM9D mach-type entry seems gone in linux-next,
so I suppose we need to deal with that as well somehow.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 Applies to linux-next 20120511

 arch/arm/boot/dts/emev2-kzm9d.dts           |   66 +++
 arch/arm/mach-shmobile/Kconfig              |   10 
 arch/arm/mach-shmobile/Makefile             |    3 
 arch/arm/mach-shmobile/board-kzm9d.c        |   81 ++++
 arch/arm/mach-shmobile/clock-emev2.c        |  249 ++++++++++++++
 arch/arm/mach-shmobile/include/mach/emev2.h |   19 +
 arch/arm/mach-shmobile/platsmp.c            |   17 +
 arch/arm/mach-shmobile/setup-emev2.c        |  454 ++++++++++++++++++++++++++-
 arch/arm/mach-shmobile/smp-emev2.c          |   97 +++++
 9 files changed, 994 insertions(+), 2 deletions(-)
