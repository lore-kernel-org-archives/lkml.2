Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080Ab2FRQTY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 12:19:24 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646Ab2FRQTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 12:19:23 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com
Subject: UBI Fastmap updates
Date: Mon, 18 Jun 2012 18:18:43 +0200
Message-Id: <1340036345-96726-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the next round of UBI fastmap updates.
It contains mostly fixes.

The highlights are:
- ubi_wl_flush() is no longer needed before creating the fastmap
- It passes all tests (ubi-tests, my own tests) with bit flit emulation and UBI self checks enabled.
- If UBI self checks are enabled UBI is able to proof the correctness of an EBA created from by fastmap.
- Endianness has been successfully tested (using qemu-x86 and qemu-ppc)

If you want to test fastmap you can use my git repo:
git://git.kernel.org/pub/scm/linux/kernel/git/rw/ubi2.git ubi2/v11

Please don't get confused with the release number, v11 is the internal release.

Fastmap has been tested on PPC, ARM, x86 on both real hardware and emulation using qemu.
To catch race conditions lots of tests have been done on a very fast x86 multi core machine.
So far nothing exploded. :-)
I'll send my fastmap torture script plus a paranoia patch in a separate mail.

Enjoy!
//richard

[PATCH 01/22] UBI: Fastmap: Add EBA selfcheck
[PATCH 02/22] UBI: Fastmap: Fix NULL pointer bug
[PATCH 03/22] UBI: Fastmap: Keep fastmap after attaching
[PATCH 04/22] UBI: Fastmap: Store scrub list in fastmap
[PATCH 05/22] UBI: Fastmap: Rework ubi_wl_put_fm_peb()
[PATCH 06/22] UBI: Fastmap: Make EBA table self check depend on
[PATCH 07/22] UBI: Fastmap: Fix build (a left over from the ai->fm
[PATCH 08/22] Revert "UBI: Fastmap: Check for duplicated PEBs in
[PATCH 09/22] UBI: Fastmap: Fix PEB count assert
[PATCH 10/22] UBI: Fastmap: Remove more useless new lines
[PATCH 11/22] UBI: Fastmap: Get rid of ubi_wl_flush() in
[PATCH 12/22] UBI: Fastmap: Locking fixes
[PATCH 13/22] UBI: Fastmap: Fix EC values
[PATCH 14/22] UBI: Fastmap: Fix copy&paste error
[PATCH 15/22] UBI: Fastmap: Kill old fastmap in case of a failure
[PATCH 16/22] UBI: Fastmap: Fix loglevel
[PATCH 17/22] UBI: Fastmap: Add comments to new functions
[PATCH 18/22] UBI: Fastmap: Rename "early PEB" to "anchor PEB".
[PATCH 19/22] UBI: Fastmap: Init fm_sem
[PATCH 20/22] UBI: Fastmap: Use good_peb_count in assert
[PATCH 21/22] UBI: Fastmap: Fix and explain duplicated PEBs
[PATCH 22/22] UBI: Fastmap: Replace crc32_be() with crc32()
