Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614Ab2F1NMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 09:12:21 -0400
Received: from mail-lb0-f202.google.com ([209.85.217.202]:62123 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305Ab2F1NIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 09:08:30 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, Yufeng Shen <miletus@chromium.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Benson Leung <bleung@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 00/23 v6] cleanup atmel_mxt_ts
Date: Thu, 28 Jun 2012 21:08:01 +0800
Message-Id: <1340888904-15620-1-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset cleans up the atmel_mxt_ts touchscreen driver.

They were tested using an MXT224E, and apply cleanly to input/next.

Changes in v6:
 * Patches 1-8: No change
 * Patch 9: refactor per Henrik, and abort on error
 * Patch 10: rebased
 * Patch 11: kfree()
 * Patch 12-17: rebased
 * Patch 18: refactored per Henrik
 * Patch 19: Moved init spew from info -> debug & refactor kfree()
 * Patch 20, 23: refactored per Henrik
 * Patch 21-22: rebased
 * Patch 23: refactored per Henrik

Daniel Kurtz (23):
  Input: atmel_mxt_ts - derive phys from i2c client adapter
  Input: atmel_mxt_ts - use client name for irq
  Input: atmel_mxt_ts - detect OOM when creating mt slots
  Input: atmel_mxt_ts - warn if sysfs could not be created
  Input: atmel_mxt_ts - don't read T5 when dumping objects
  Input: atmel_mxt_ts - use scnprintf for object sysfs entry
  Input: atmel_mxt_ts - optimize reading objects in object sysfs entry
  Input: atmel_mxt_ts - print less overhead when dumping objects
  Input: atmel_mxt_ts - print all instances when dumping objects
  Input: atmel_mxt_ts - return errors from i2c layer
  Input: atmel_mxt_ts - add variable length __mxt_write_reg
  Input: atmel_mxt_ts - optimize writing of object table entries
  Input: atmel_mxt_ts - read ID information block in one i2c
    transaction
  Input: atmel_mxt_ts - update driver ID info logging
  Input: atmel_mxt_ts - add sysfs entries to read fw and hw version
  Input: atmel_mxt_ts - simplify event reporting
  Input: atmel_mxt_ts - add detail to touchevent debug message
  Input: atmel_mxt_ts - refactor when and how object table is freed
  Input: atmel_mxt_ts - cache T9 reportid range when reading object
    table
  Input: atmel_mxt_ts - refactor reportid checking in mxt_interrupt
  Input: atmel_mxt_ts - use T9 reportid range to init number of mt
    slots
  Input: atmel_mxt_ts - send all MT-B slots in one input report
  Input: atmel_mxt_ts - parse T6 reports

 drivers/input/touchscreen/atmel_mxt_ts.c |  468 +++++++++++++++--------------
 1 files changed, 242 insertions(+), 226 deletions(-)

-- 
1.7.7.3

