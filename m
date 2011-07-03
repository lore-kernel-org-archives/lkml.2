Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771Ab1GCOOv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 10:14:51 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:52951 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478Ab1GCOOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 10:14:50 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 0/7] notifier error injection
Date: Sun,  3 Jul 2011 23:16:14 +0900
Message-Id: <1309702581-16863-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This provides the ability to inject artifical errors to the following
notifier chain callbacks. It is useful to test the error handling of
notifier call chain failures.

 * CPU notifier
 * PM notifier
 * memory hotplug notifier
 * powerpc pSeries reconfig notifier

We already have cpu-notifier-error-inject.ko module providing such
functionality for the CPU notifier.  However, this patch set adds
common basic functions and consistent debugfs interface for them.

Akinobu Mita (7):
  pm: improve error code of pm_notifier_call_chain()
  debugfs: add debugfs_create_int
  fault-injection: notifier error injection
  cpu: CPU notifier error injection
  PM: PM notifier error injection
  memory: memory notifier error injection
  powerpc: pSeries reconfig notifier error injection

 Documentation/feature-removal-schedule.txt |    8 ++++
 arch/powerpc/platforms/pseries/reconfig.c  |   31 +++++++++++++++
 drivers/base/memory.c                      |   29 ++++++++++++++
 drivers/char/apm-emulation.c               |    2 +-
 drivers/s390/char/vmwatchdog.c             |    4 +-
 drivers/s390/cio/css.c                     |    8 ++--
 fs/debugfs/file.c                          |   56 +++++++++++++++++++++++++++
 include/linux/debugfs.h                    |    9 ++++
 include/linux/notifier.h                   |   25 ++++++++++++
 kernel/cpu.c                               |   31 +++++++++++++++
 kernel/notifier.c                          |   57 ++++++++++++++++++++++++++++
 kernel/power/main.c                        |   35 ++++++++++++++++-
 lib/Kconfig.debug                          |   50 ++++++++++++++++++++++++
 13 files changed, 336 insertions(+), 9 deletions(-)

-- 
1.7.4.4

