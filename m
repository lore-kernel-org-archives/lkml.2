Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758336Ab2FZHCP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 03:02:15 -0400
Received: from mail-wi0-f202.google.com ([209.85.212.202]:51710 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756883Ab2FZG5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 02:57:19 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, linux-input@vger.kernel.org
Cc: Iiro Valkonen <iiro.valkonen@atmel.com>,
        Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Olof Johansson <olofj@chromium.org>, linux-kernel@vger.kernel.org,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 00/21 v5] cleanup atmel_mxt_ts
Date: Tue, 26 Jun 2012 14:56:48 +0800
Message-Id: <1340693829-18665-1-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset cleans up the atmel_mxt_ts touchscreen driver.

These patches mostly contain non-controversial changes that were previously
reviewed in previous versions of the patchset.  However, based on feedback from
Henrik, the individual patches are now all much smaller and easier to review.

They were tested using an MXT224E, and apply cleanly to input/next.

Whenever these patches (or their descendants) are accepted, there is a larger
patchset full of additional features and more significant changes that will
follow.

Changes in v5:
 * Fixed phys per Dmitry's comments
 * Removed "re-read matrix after applying pdata" per Nick
 * T6 spew changd to dev_dbg per Nick


Daniel Kurtz (21):
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
  Input: atmel_mxt_ts - cache T9 reportid range when reading object
    table
  Input: atmel_mxt_ts - use T9 reportid range to init number of mt
    slots
  Input: atmel_mxt_ts - send all MT-B slots in one input report
  Input: atmel_mxt_ts - parse T6 reports

 drivers/input/touchscreen/atmel_mxt_ts.c |  438 +++++++++++++++---------------
 1 files changed, 217 insertions(+), 221 deletions(-)

-- 
1.7.7.3

