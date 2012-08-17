Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758892Ab2HQXzy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 19:55:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65137 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756655Ab2HQXzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 19:55:44 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: ralf@linux-mips.org, linux-ide@vger.kernel.org,
        Jeff Garzik <jgarzik@pobox.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Subject: [PATCH 0/2] ata: Updates for pata_octeon_cf driver.
Date: Fri, 17 Aug 2012 16:54:31 -0700
Message-Id: <1345247673-25086-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

The main update is conversion to device tree.  Now the the OCTEON
device tree prerequisites are upstream, we can convert the
pata_octeon_cf driver.

The second change allows the driver to function when the kernel is
built for little-endian operation.

The only real change in the MIPS portion of the tree is deletion of
crap.

There is a dependence on patches Ralf has queued in linux-next so it
may be best to merge via the MIPS tree (as pata_octeon_cf only exists
in MIPS based OCTEON SOCs).  But the ata tree would be fine by me too.
In any even we may need some cross sub-system Acked-bys.

David Daney (2):
  MIPS/OCTEON/ata: Convert pata_octeon_cf.c to use device tree.
  ata: pata_octeon_cf: Use correct byte order for DMA in when built
    little-endian.

 arch/mips/cavium-octeon/octeon-irq.c           |   1 -
 arch/mips/cavium-octeon/octeon-platform.c      | 102 ------
 arch/mips/include/asm/mach-cavium-octeon/irq.h |   1 -
 arch/mips/include/asm/octeon/octeon.h          |   7 -
 drivers/ata/pata_octeon_cf.c                   | 423 +++++++++++++++++--------
 5 files changed, 288 insertions(+), 246 deletions(-)

-- 
1.7.11.2

