Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933640Ab1KJIGN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 03:06:13 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:43212 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755136Ab1KJIGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 03:06:09 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: dwmw2@infradead.org, dedekind1@gmail.com, mikedunn@newsguy.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH v2 00/16] DocG3 fixes and write support
Date: Thu, 10 Nov 2011 09:05:26 +0100
Message-Id: <1320912342-30147-1-git-send-email-robert.jarzmik@free.fr>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is aimed at :
 - fixing 5 glitches in the driver
 - add several new functions

The added functions are :
 - add block erase capability
 - add write page capability
 - add powerdown and powerup
 - add multiple floor support
 - add ECC support
 - add docg3 modes support
 - add protection support (DPS areas)

The ECC part should especially be reviewed by Ivan and Mike,
as this is their work (patch "add ECC correction code").

Since V1, Ivan's and Mike's comments have been taken into
account, and nandtest/nanddump/nandwrite testing has been
done, with and without bitflipped data.

Moreover, 3 new patches have been added:
 - fix reading oob+data without correction
   This was triggered by the bitflipped pages tests, and
   fixes cases where we want to read corrupted data.
 - add docg3 modes support
   This actually fixes the read part, as we now read in
   "normal" mode by default rather than in "reliable"
   mode. This is mandatory for nandtest to work, because of
   the "even/odd pages logical AND".
 - add protection support
   This is an evolution to be able to access the whole chip
   in protected chips, as they are in smartphones.

Happy review.

--
Robert

Robert Jarzmik (16):
  mtd/docg3: fix debug log verbosity
  mtd/docg3: fix tracing of IO in writeb
  mtd/docg3: fix protection areas reading
  mtd/docg3: fix BCH registers
  mtd/docg3: fix reading oob+data without correction
  mtd/docg3: add multiple floor support
  mtd/docg3: add OOB layout to mtdinfo
  mtd/docg3: add registers for erasing and writing
  mtd/docg3: add OOB buffer to device structure
  mtd/docg3: add write functions
  mtd/docg3: add erase functions
  mtd/docg3: map erase and write functions
  mtd/docg3: add ECC correction code
  mtd/docg3: add suspend and resume
  mtd/docg3: add fast mode
  mtd/docg3: add protection areas sysfs access

 drivers/mtd/devices/Kconfig |    9 +
 drivers/mtd/devices/docg3.c | 1451 ++++++++++++++++++++++++++++++++++++-------
 drivers/mtd/devices/docg3.h |   64 ++-
 3 files changed, 1299 insertions(+), 225 deletions(-)

-- 
1.7.5.4

