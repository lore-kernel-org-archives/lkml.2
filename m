Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177Ab1LGDkN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 22:40:13 -0500
Received: from mail.windriver.com ([147.11.1.11]:49935 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754425Ab1LGDkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 22:40:11 -0500
Date: Tue, 6 Dec 2011 22:39:57 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <gregkh@suse.de>
CC: <alan@linux.intel.com>, <galak@kernel.crashing.org>,
        <linux-serial@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] tty-next: Fix Fsl 8250 BRK bug
Message-ID: <20111207033957.GB20556@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

This is the Freescale hardware bug fix which turned into a
six-pack of 8250 updates.  This is exactly what was posted
in the v2 review, with just Alan's ack added[1].  Since nobody
else has had any follow-on comments since then, I'm assuming
that it is now good to go.

[1] https://lkml.org/lkml/2011/12/5/156

Thanks,
Paul.
---

Please pull for tty-next to get:

The following changes since commit 5611cc4572e889b62a7b4c72a413536bf6a9c416:

  Linux 3.2-rc4 (2011-12-01 14:56:01 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/paulg/linux fsl-uart-fix

Paul Gortmaker (6):
      serial: move struct uart_8250_port from 8250.c to 8250.h
      serial: clean up parameter passing for 8250 Rx IRQ handling
      serial: export the key functions for an 8250 IRQ handler
      serial: make 8250 timeout use the specified IRQ handler
      serial: manually inline serial8250_handle_port
      serial: add irq handler for Freescale 16550 errata.

 arch/powerpc/kernel/legacy_serial.c |    3 +
 drivers/tty/serial/8250.c           |   92 ++++++++++++-----------------------
 drivers/tty/serial/8250.h           |   26 ++++++++++
 drivers/tty/serial/8250_fsl.c       |   63 ++++++++++++++++++++++++
 drivers/tty/serial/Kconfig          |    5 ++
 drivers/tty/serial/Makefile         |    1 +
 include/linux/serial_8250.h         |    5 ++
 7 files changed, 134 insertions(+), 61 deletions(-)
 create mode 100644 drivers/tty/serial/8250_fsl.c

