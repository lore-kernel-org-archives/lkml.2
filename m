Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933150Ab2JZOBP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 10:01:15 -0400
Received: from vaxjo.synopsys.com ([198.182.60.75]:45140 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933042Ab2JZOBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 10:01:10 -0400
From: <Vineet.Gupta1@synopsys.com>
To: <gregkh@linuxfoundation.org>, <alan@linux.intel.com>, <balbi@ti.com>
CC: <arc-linux-dev@synopsys.com>, <linux-serial@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH v6] serial/arc-uart: Add new driver
Date: Fri, 26 Oct 2012 19:29:32 +0530
Message-ID: <1351259973-16989-1-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.56]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vineet Gupta <vgupta@synopsys.com>

Hi,

Here's the updated revision with fixes per Greg and Felipe' review comments.
-Rebased off tty-next tip.
-Build tested for x86, both as builtin and as module
-Same driver (as module) verified on ARCAngel4 Board.

Please consider applying.

Thanks,
Vineet

v6:
* syntactical changes per comments by Felipe
* Empty (request|release)_port removed

v5:
* Driver now builds as module; default !y
* Fixed some build wreckage due to SERIAL_ARC && !SERIAL_ARC_CONSOLE
* Fixed a sparse warning due to forced cast, hence reg offsets now in bytes

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

 drivers/tty/serial/Kconfig       |   23 ++
 drivers/tty/serial/Makefile      |    1 +
 drivers/tty/serial/arc_uart.c    |  754 ++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/serial_core.h |    2 +
 4 files changed, 780 insertions(+), 0 deletions(-)
 create mode 100644 drivers/tty/serial/arc_uart.c

-- 
1.7.4.1

