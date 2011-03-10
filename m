Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084Ab1CJVCg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 16:02:36 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:50413 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab1CJVCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 16:02:35 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: [PATCH 00/22] staging: xgifb: more cleanups
Date: Thu, 10 Mar 2011 23:02:25 +0200
Message-Id: <1299790967-7135-1-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Here's another batch of cleanups. I hope the series is not too big,
most of the changes are just mechanical.

Testing:
	- compile-tested with GCC 4.5.2, no warnings
	- tested with Z9 (XG21) on ARM, framebuffer console works

Aaro Koskinen (22):
  staging: xgifb: vb_ext: move functions to avoid forward declarations
  staging: xgifb: vb_init: move functions to avoid forward declarations
  staging: xgifb: vb_setmode: move functions to avoid forward
    declarations
  staging: xgifb: delete unsupported chip types
  staging: xgifb: delete dead code for chip types < XG40
  staging: xgifb: eliminate redudant chip type >= XG40 checks
  staging: xgifb: delete unused LINUXBIOS code
  staging: xgifb: delete redundant extended register access enable
  staging: xgifb: delete incorrect I/O mapping
  staging: xgifb: use mdelay() for millisecond delays
  staging: xgifb: replace DelayUS() with udelay()
  staging: xgifb: vb_util: include the .h file
  staging: xgifb: vb_util: delete commented-out code
  staging: xgifb: replace XGINew_GetReg2() with inb()
  staging: xgifb: replace XGINew_GetReg3() with inl()
  staging: xgifb: replace XGINew_SetReg3() with outb()
  staging: xgifb: replace XGINew_SetReg4() with outl()
  staging: xgifb: rename XGINew_SetReg1() to xgifb_reg_set()
  staging: xgifb: rename XGINew_GetReg1() to xgifb_reg_get()
  staging: xgifb: rename XGINew_SetRegOR() to xgifb_reg_or()
  staging: xgifb: rename XGINew_SetRegANDOR() to xgifb_reg_and_or()
  staging: xgifb: rename XGINew_SetRegAND() to xgifb_reg_and()

 drivers/staging/xgifb/XGI_main.h    |    3 -
 drivers/staging/xgifb/XGI_main_26.c |   76 +-
 drivers/staging/xgifb/XGIfb.h       |   18 -
 drivers/staging/xgifb/vb_ext.c      |  354 +--
 drivers/staging/xgifb/vb_init.c     | 1507 +++++-----
 drivers/staging/xgifb/vb_setmode.c  | 5842 ++++++++++++++++-------------------
 drivers/staging/xgifb/vb_table.h    |   23 -
 drivers/staging/xgifb/vb_util.c     |  124 +-
 drivers/staging/xgifb/vb_util.h     |   16 +-
 9 files changed, 3680 insertions(+), 4283 deletions(-)

