Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401Ab1CYROv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 13:14:51 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37607 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263Ab1CYROu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 13:14:50 -0400
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: vapier@gentoo.org, gregkh@suse.de, Jamie Iles <jamie@jamieiles.com>
Subject: [RFC PATCHv3 0/4] Support for OTP memory
Date: Fri, 25 Mar 2011 17:14:39 +0000
Message-Id: <1301073283-30821-1-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've updated this series following some great feedback from Greg and
Mike, and aside from the code quality improvements, the main changes
since v2 are:

    - The OTP regions don't live directly in /sys/bus/otp/devices
    anymore but just as a child device of the OTP device.
    - CONFIG_OTP_WRITE_ENABLE has been created that replaces the
    bfin-otp specific option and this disables all OTP writing at the
    higher levels.  The PC3X3 OTP driver has also been converted to use
    this.
    - Multiple OTP devices can now be registered at the same time.
    - The bfin-otp driver has been converted to a platform_driver and
    the relevant Blackfin platforms have had a bfin-otp device added.
    - The Blackfin OTP is now represented as a single region that does
    not include the ECC or control bits.  This prevents users from
    accidentally scribbling over those bits.

Greg, Mike, thanks again for taking the time to review, it's much
appreciated.

Thanks,

Jamie Iles (4):
  drivers/otp: add initial support for OTP memory
  drivers/otp: add support for Picoxcell PC3X3 OTP
  drivers/otp: convert bfin otp to generic OTP
  Blackfin: add the OTP device as a platform device

 Documentation/ABI/testing/sysfs-bus-otp      |   93 +++
 arch/blackfin/mach-bf518/boards/ezbrd.c      |   10 +
 arch/blackfin/mach-bf518/boards/tcm-bf518.c  |   10 +
 arch/blackfin/mach-bf527/boards/ad7160eval.c |   10 +
 arch/blackfin/mach-bf527/boards/cm_bf527.c   |   10 +
 arch/blackfin/mach-bf527/boards/ezbrd.c      |   10 +
 arch/blackfin/mach-bf527/boards/ezkit.c      |   10 +
 arch/blackfin/mach-bf527/boards/tll6527m.c   |   10 +
 arch/blackfin/mach-bf548/boards/cm_bf548.c   |    9 +
 arch/blackfin/mach-bf548/boards/ezkit.c      |   10 +
 drivers/Kconfig                              |    2 +
 drivers/Makefile                             |    1 +
 drivers/char/Kconfig                         |   28 -
 drivers/char/Makefile                        |    1 -
 drivers/otp/Kconfig                          |   51 ++
 drivers/otp/Makefile                         |    3 +
 drivers/{char => otp}/bfin-otp.c             |  275 ++++---
 drivers/otp/otp.c                            |  913 +++++++++++++++++++++
 drivers/otp/otp_pc3x3.c                      | 1099 ++++++++++++++++++++++++++
 include/linux/otp.h                          |  277 +++++++
 20 files changed, 2677 insertions(+), 155 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-otp
 create mode 100644 drivers/otp/Kconfig
 create mode 100644 drivers/otp/Makefile
 rename drivers/{char => otp}/bfin-otp.c (40%)
 create mode 100644 drivers/otp/otp.c
 create mode 100644 drivers/otp/otp_pc3x3.c
 create mode 100644 include/linux/otp.h

-- 
1.7.4

