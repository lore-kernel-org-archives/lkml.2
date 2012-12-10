Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab2LJTMw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 14:12:52 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55652 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751845Ab2LJTMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 14:12:50 -0500
From: Will Deacon <will.deacon@arm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, benh@kernel.crashing.org, arnd@arndb.de,
        james.hogan@imgtec.com, Will Deacon <will.deacon@arm.com>
Subject: [PATCH v2 00/10] Fix endianness of generic I/O accessors
Date: Mon, 10 Dec 2012 19:12:32 +0000
Message-Id: <1355166762-15133-1-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello again,

This is version 2 of the patches originally posted here:

  http://lkml.indiana.edu/hypermail/linux/kernel/1210.2/00952.html

Changes since then:
	- Reordered the series to put the string function removal at the
	  end.
	- Matthew's had a crack at fixing up all the other drivers which
	  rely on the generic I/O accessors after a request from James
	  Hogan.

Note that the mmc and smc changes are required in order to build their
respective drivers for arm64, regardless of endianness and/or the rest
of this series.

Comments welcome, particularly regarding how on Earth this gets merged
in a sane manner.

Will


Matthew Leach (6):
  net: smc911x: use io{read,write}*_rep accessors
  net: dm9000: use io{read,write}*_rep accessors
  net: 8390: use io{read,write}*_rep accessors
  mtd: nand/gpio: use io{read,write}*_rep accessors
  musb: tusb6010: use io{read,write}*_rep accessors
  usb: musb: use io{read,write}*_rep accessors

Will Deacon (4):
  asm-generic: io: don't perform swab during {in,out} string functions
  mmc: mmci: use io{read,write}*_rep accessors instead of string
    functions
  net: smc91x: use io{read,write}*_rep accessors instead of string
    functions
  asm-generic: io: remove {read,write} string functions

 drivers/mmc/host/mmci.c               |  8 +++----
 drivers/mtd/nand/gpio.c               |  8 +++----
 drivers/net/ethernet/8390/ax88796.c   | 16 ++++++-------
 drivers/net/ethernet/davicom/dm9000.c | 12 +++++-----
 drivers/net/ethernet/smsc/smc911x.h   | 16 ++++++-------
 drivers/net/ethernet/smsc/smc91x.h    | 20 ++++++++---------
 drivers/usb/musb/musb_core.c          | 12 +++++-----
 drivers/usb/musb/musb_io.h            | 21 ------------------
 drivers/usb/musb/tusb6010.c           |  5 +++--
 include/asm-generic/io.h              | 42 +++++------------------------------
 10 files changed, 55 insertions(+), 105 deletions(-)

-- 
1.8.0

