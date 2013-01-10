Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023Ab3AJJYX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 04:24:23 -0500
Received: from mga09.intel.com ([134.134.136.24]:20043 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871Ab3AJJYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 04:24:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,443,1355126400"; 
   d="scan'208";a="244527978"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Cox <alan@linux.intel.com>, Jamie Iles <jamie@jamieiles.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv3 0/8] serial: 8250: 8250_dw changes and dmaengine support
Date: Thu, 10 Jan 2013 11:25:04 +0200
Message-Id: <1357809912-25790-1-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v2:
- ACPI support for 8250_dw.c
- dmaengine API support for 8250

It looks like there are a few UART drivers that are more or less
identical with 8250.c except they include DMA support, so if we had
DMA support in 8250.c there may be no need for them. Since dmaengine
is now supported on most platforms, I decided to suggest this
solution.

I tried to make the DMA support as simple as I could. Single transfers
with single descriptors. This should be sufficient in most cases.


Heikki Krogerus (8):
  serial: 8250: Allow drivers to deliver capabilities
  serial: 8250_dw: Don't use UPF_FIXED_TYPE
  serial: 8250_dw: Map IO memory
  serial: 8250_dw: Move device tree code to separate function
  serial: 8250_dw: Set FIFO size dynamically
  serial: 8250_dw: Add ACPI 5.0 support
  serial: 8250: Add support for dmaengine
  serial: 8250_dw: Enable DMA support with ACPI

 drivers/tty/serial/8250/8250.c     |   53 ++++++--
 drivers/tty/serial/8250/8250.h     |   50 ++++++++
 drivers/tty/serial/8250/8250_dma.c |  213 +++++++++++++++++++++++++++++++
 drivers/tty/serial/8250/8250_dw.c  |  248 ++++++++++++++++++++++++++++++------
 drivers/tty/serial/8250/Kconfig    |   10 +-
 drivers/tty/serial/8250/Makefile   |    1 +
 include/linux/serial_8250.h        |    4 +
 7 files changed, 532 insertions(+), 47 deletions(-)
 create mode 100644 drivers/tty/serial/8250/8250_dma.c

-- 
1.7.10.4

