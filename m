Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161342Ab2JXWJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 18:09:38 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:64288 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161226Ab2JXWJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 18:09:35 -0400
From: Omar Ramirez Luna <omar.ramirez@copitl.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Victor Manuel Jaquez Leal <vjaquez@igalia.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Omar Ramirez Luna <omar.ramirez@copitl.com>
Subject: [PATCH 0/6] staging: tidspbridge fixes for 3.7
Date: Wed, 24 Oct 2012 17:09:14 -0500
Message-Id: <1351116560-6918-1-git-send-email-omar.ramirez@copitl.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With 3.7-rc1 changes:

- New irq numbering in OMAP3 broke the driver request for a mmu irq,
  until this is migrated to the common iommu framework we can only
  hardcode the new number.
- _raw_* accessors changed a type of one of their parameters with patch
  "195bbca ARM: 7500/1: io: avoid writeback addressing modes for
  __raw_ accessors", so the build system was filled with warnings from
  the old parameter usage.

Omar Ramirez Luna (6):
  staging: tidspbridge: request the right irq for mmu
  staging: tidspbridge: drop const from custom mmu implementation
  staging: tidspbridge: change type to __iomem for per and core
    addresses
  staging: tidspbridge: ioremap dsp sync addr
  staging: tidspbridge: ioremap physical address of the stack segment
    in shm
  staging: tidspbridge: delete unused mmu functions

 drivers/staging/tidspbridge/core/tiomap3430.c      |   37 +++++--
 drivers/staging/tidspbridge/hw/hw_mmu.c            |  115 ++++----------------
 drivers/staging/tidspbridge/hw/hw_mmu.h            |   31 +++---
 .../tidspbridge/include/dspbridge/cfgdefs.h        |    4 +-
 .../tidspbridge/include/dspbridge/host_os.h        |    4 +-
 drivers/staging/tidspbridge/rmgr/drv.c             |    8 +-
 drivers/staging/tidspbridge/rmgr/node.c            |   21 +++-
 7 files changed, 83 insertions(+), 137 deletions(-)

-- 
1.7.9.5

