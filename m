Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab2AZPwF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 10:52:05 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:62373 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229Ab2AZPwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 10:52:03 -0500
Date: Thu, 26 Jan 2012 16:51:50 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: giancarlo.asnaghi@st.com, alan@linux.intel.com, sameo@linux.intel.com,
        grant.likely@secretlab.ca, linus.walleij@stericsson.com
Subject: [RFC PATCH 0/2] MFD and GPIO for STA2X11
Message-ID: <cover.1327592191.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two patches introduce multi-function device and GPIO support for
the STA2X11 I/O Hub. It's an RFC for both as explained below.

- I think the MFD driver is ok. This MFD_STA2X11 config symbol is
  autoselected by CONFIG_STA2X11, which is pending in the
  "x86: initial support for sta2x11" patch, for which I need to send V2
  later today, with some minor fixes.  Similarly, <asm/sta2x11.h> is
  not upstream yet, so I'll need to resend later, I suppose.

- The GPIO patch has a quirk: I chose to register a single irq chip
  for 128 interrupts but the generic irq_chip only support 32 interrupts.
  I'm sure the hack I did (request the irq descs myself) is not good, but
  what is the best approach here?  Using 4 generic irq chips or defining
  my own, non-generic one?

Thanks a lot
/alessandro

Alessandro Rubini (2):
  mfd: Add driver for STA2X11 MFD block
  gpio: add STA2X11 GPIO block

 drivers/gpio/Kconfig            |    9 +
 drivers/gpio/Makefile           |    1 +
 drivers/gpio/gpio-sta2x11.c     |  380 +++++++++++++++++++++++++++++++
 drivers/mfd/Kconfig             |    6 +
 drivers/mfd/Makefile            |    1 +
 drivers/mfd/sta2x11-mfd.c       |  470 +++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/sta2x11-mfd.h |  186 +++++++++++++++
 7 files changed, 1053 insertions(+), 0 deletions(-)
 create mode 100644 drivers/gpio/gpio-sta2x11.c
 create mode 100644 drivers/mfd/sta2x11-mfd.c
 create mode 100644 include/linux/mfd/sta2x11-mfd.h

-- 
1.7.7.2
