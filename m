Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030307Ab2B2S0c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 13:26:32 -0500
Received: from mga09.intel.com ([134.134.136.24]:58226 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965971Ab2B2S0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 13:26:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="116195297"
From: Darren Hart <dvhart@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Tomoya MORINAGA <tomoya.rohm@gmail.com>, Feng Tang <feng.tang@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org,
        Darren Hart <dvhart@linux.intel.com>
Subject: [PATCH 0/4 V2] pch_uart: Cleanups, board quirks, and user uartclk parameter
Date: Wed, 29 Feb 2012 10:24:39 -0800
Message-Id: <cover.1330539597.git.dvhart@linux.intel.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series does some minor clean-up to the pch_uart driver, adds support
for the Fish River Island II UART clock quirks, and introduces a user_uartclk
parameter to aid in developing for early and changing hardware.

In order to support an early serial console, we cannot rely on the pch_phub
probe function to setup the CFGCLK register. This series relies on the board
quirks and does not force the setting of the CLKREG in the pch_phub code.
Instead, it aligns with what is the default configuration (defined by firmware)
for a given board. The user_uartclk parameter provides a mechanism to force a
specific uartclk if necessary.

I looked at the PCI code briefly to see about forcing the clock to 192MHz on
all boards early on to avoid having to use quirks, but it was not clear to me
if this could be done before PCI was initialized as the IO base is derived
from pci_iomap(pdev...). Perhaps this can be done, and I would be happy to
revisit this as a follow-up patch. As this current patch series follows existing
precedent to support a specific board and it does not impact the existing boards
or the default behavior, I'd like to see this merged as is, rather than hold out
for a much more invasive change forcing the clock to 192MHz. Is this acceptable? 

V2: Incorporates Alan Cox's feedback into 2/4: Add Fish River Island II uart
    clock quirks, refactoring the clock quirks into a new function and using
    a more appropriate name for a reused string variable.
    Add support for the two firmware variants for the FRI2.

--
Darren

The following changes since commit 164974a8f2a482f1abcb027c6d1a89dd79b14297:

  ecryptfs: fix printk format warning for size_t (2012-02-28 16:55:30 -0800)

are available in the git repository at:
  git://git.infradead.org/users/dvhart/linux-2.6.git pch_uart_v2
  http://git.infradead.org/users/dvhart/linux-2.6.git/shortlog/refs/heads/pch_uart_v2

Darren Hart (4):
  pch_uart: Use uartclk instead of base_baud
  pch_uart: Add Fish River Island II uart clock quirks
  pch_uart: Add user_uartclk parameter
  pch_uart: Use existing default_baud in setup_console

 drivers/tty/serial/pch_uart.c |   59 +++++++++++++++++++++++++++--------------
 1 files changed, 39 insertions(+), 20 deletions(-)

-- 
1.7.6.5

