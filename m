Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934175Ab2JYGcn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 02:32:43 -0400
Received: from alvesta.synopsys.com ([198.182.60.77]:53554 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932112Ab2JYGck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 02:32:40 -0400
From: <Vineet.Gupta1@synopsys.com>
To: <alan@linux.intel.com>, <gregkh@linuxfoundation.org>
CC: <arc-linux-dev@synopsys.com>, <linux-serial@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH v4] serial/arc-uart: Add New Driver
Date: Thu, 25 Oct 2012 12:00:07 +0530
Message-ID: <1351146608-21044-1-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.56]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vineet Gupta <vgupta@synopsys.com>

Hi Greg,

Rebased off of tty-next and verfied that it builds fine.
Please consider applying.

Thanks,
Vineet

v4:
* UAPI disintegration fallout for serial_core.h
* rebased off of tty-next

v3:
* Removed empty arc_serial_set_ldisc()
* More set_termios fixes - CSIZE forced to CS8 (for 8N1)
* global @running_on_iss replaced with platform data, saved in device
  specific port structure.

v2:
* ttyARC used as device name
* Dynamic assignment of major/minor numbers.
* Ref counting tty in rx routine to prevent it from disappearing in
  case of a hangup
* set_termios fixes:
  - hardware flow control/parity are marked as unsupported
  - baud written back to termios
* cosmetics such as commenting the need for @running_on_iss, empty lines
  etc

Vineet Gupta (1):
  serial/arc-uart: Add new driver

 drivers/tty/serial/Kconfig       |   25 ++
 drivers/tty/serial/Makefile      |    1 +
 drivers/tty/serial/arc_uart.c    |  747 ++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/serial_core.h |    2 +
 4 files changed, 775 insertions(+), 0 deletions(-)
 create mode 100644 drivers/tty/serial/arc_uart.c

-- 
1.7.4.1

