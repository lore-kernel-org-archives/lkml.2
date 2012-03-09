Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933Ab2CIRxg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 12:53:36 -0500
Received: from mga09.intel.com ([134.134.136.24]:24905 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752455Ab2CIRxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 12:53:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="116263136"
From: Darren Hart <dvhart@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Tomoya MORINAGA <tomoya.rohm@gmail.com>, Feng Tang <feng.tang@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org,
        Darren Hart <dvhart@linux.intel.com>
Subject: [PATCH 0/5 V3] pch_uart: Cleanups, board quirks, and user uartclk parameter
Date: Fri,  9 Mar 2012 09:51:46 -0800
Message-Id: <cover.1331315372.git.dvhart@linux.intel.com>
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

V2: Incorporates Alan Cox's feedback into 2/4: Add Fish River Island II uart
    clock quirks, refactoring the clock quirks into a new function and using
    a more appropriate name for a reused string variable.
    Add support for the two firmware variants for the FRI2.

V3: Rebase on linux-next.git/master rather than linux-2.6.git.
    Add module parameter descriptions.

The following changes since commit d5ba8c14a256799efb1048151fe3490f9cb989b9:

  Add linux-next specific files for 20120309 (2012-03-09 19:04:19 +1100)

are available in the git repository at:
  git://git.infradead.org/users/dvhart/linux-next.git pch_uart_v3
  http://git.infradead.org/users/dvhart/linux-next.git/shortlog/refs/heads/pch_uart_v3

Darren Hart (5):
  pch_uart: Use uartclk instead of base_baud
  pch_uart: Add Fish River Island II uart clock quirks
  pch_uart: Add user_uartclk parameter
  pch_uart: Use existing default_baud in setup_console
  pch_uart: Add module parameter descriptions

 drivers/tty/serial/pch_uart.c |   59 ++++++++++++++++++++++++++++------------
 1 files changed, 41 insertions(+), 18 deletions(-)

-- 
1.7.6.5

