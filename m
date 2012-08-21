Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab2HUSpW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 14:45:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36392 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab2HUSpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 14:45:19 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH 0/8] netdev/MIPS: Improvements to octeon_mgmt Ethernet driver.
Date: Tue, 21 Aug 2012 11:45:04 -0700
Message-Id: <1345574712-21444-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

Recent additions to the OCTEON SoC family have included enhancements
to the MIX (octeon_mgmt) Ethernet hardware.  These include:

o 1Gig support (up from 100M).

o Hardware timestamping for PTP.

Here we add support for these two features as well as some ethtool
improvements and cleanup of the MAC address handling.

Patch 1/8 is a prerequisite for the rest, and lives in the MIPS
architecture part of the tree.  Since octeon_mgmt devices are only
found in OCTEON SoCs we could merge the whole set via Ralf's tree, or
get Ralf to affix his Acked-by and have it go via the netdev tree.


Chad Reese (1):
  netdev: octeon_mgmt: Add hardware timestamp support.

David Daney (7):
  MIPS: Octeon: Add octeon_io_clk_delay() function.
  netdev: octeon_mgmt: Add support for 1Gig ports.
  netdev: octeon_mgmt: Improve ethtool_ops.
  netdev: octeon_mgmt: Set the parent device.
  netdev: octeon_mgmt: Cleanup and modernize MAC address handling.
  netdev: octeon_mgmt: Remove some useless 'inline'
  netdev: octeon_mgmt: Make multi-line comment style consistent.

 arch/mips/cavium-octeon/csrc-octeon.c     |  93 +++--
 arch/mips/cavium-octeon/setup.c           |   3 +-
 arch/mips/include/asm/octeon/octeon.h     |   1 +
 drivers/net/ethernet/octeon/octeon_mgmt.c | 554 ++++++++++++++++++++++++------
 4 files changed, 512 insertions(+), 139 deletions(-)

-- 
1.7.11.4

