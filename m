Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170Ab2FKR37 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 13:29:59 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:38807 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab2FKR35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 13:29:57 -0400
From: sjur.brandeland@stericsson.com
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Loic PALLARDY <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjurbren@gmail.com>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [PATCHv2 0/5] remoteproc: Custom firmware handling.
Date: Mon, 11 Jun 2012 19:29:43 +0200
Message-Id: <1339435788-16283-1-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

Hi Ohad,
Here is a new patch series. I dropped the two bug-fix patches
since last time, as you already included these. I've tried to
address all of your review comments since last time, hope I
didn't miss any.

Status:
I have done a simple simulated test now with the STE firmware
loader and main-flow seems ok, but I haven't done any negative 
tests.

Changes since V1:
- Changed rproc_set_boot_addr to rproc_get_boot_addr avoiding
  firmware handlers to manipulate the rproc structure.
- Functions in remoteproc_elf_loader are now static and prefixed
   with _rproc to avoid any namespace issues.
- Added commit note about rproc_da_to_va() becoming non-static
  and moved it to remoteproc_internal.h
- Made the elf handler default.
- Moved pointer to rproc_fw_ops from the rproc_ops struct to
  the rproc struct.
- Fixed typos
- The fw_ops are no longer exported as symbols.
- The struct rproc_fw_ops is made const.
- The inline helper functions are moved from remoteproc.h to
  remoteproc_internal.h
- The latest patch is a bit odd. The ste_modem_remoteproc module
  contains only the firmware handler, and nothing else.

Regards,
Sjur

Sjur Brændeland (5):
  remoteproc: Pass struct fw to load_segments and find_rsc_table.
  remoteproc: Add function rproc_get_boot_addr
  remoteproc: Move Elf related functions to separate file
  remoteproc: Support custom firmware handlers
  remoteproc: Add custom STE-modem firmware loader.

 drivers/remoteproc/Kconfig                       |    9 +
 drivers/remoteproc/Makefile                      |    1 +
 drivers/remoteproc/remoteproc_core.c             |  251 +------------------
 drivers/remoteproc/remoteproc_elf_loader.c       |  289 ++++++++++++++++++++++
 drivers/remoteproc/remoteproc_internal.h         |   37 +++
 drivers/remoteproc/remoteproc_ste_modem_loader.c |  179 +++++++++++++
 include/linux/remoteproc.h                       |   23 ++-
 7 files changed, 546 insertions(+), 243 deletions(-)
 create mode 100644 drivers/remoteproc/remoteproc_elf_loader.c
 create mode 100644 drivers/remoteproc/remoteproc_ste_modem_loader.c

-- 
1.7.5.4

