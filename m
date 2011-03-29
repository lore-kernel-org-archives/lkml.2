Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291Ab1C2MIL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 08:08:11 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50341 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab1C2MIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 08:08:09 -0400
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, vapier@gentoo.org, arnd@arndb.de,
        Jamie Iles <jamie@jamieiles.com>
Subject: [RFC PATCHv4 0/4] Support for OTP memory
Date: Tue, 29 Mar 2011 13:07:57 +0100
Message-Id: <1301400481-11645-1-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This series of the OTP memory support has been updated since v3 with the
following main changes:

	- The device specific ioctl() has now been eliminated and an
	OTP_LOCK_AREA ioctl() has been added that uses the new lock_word()
	operation to perform locking of OTP.
	- The read_word/write_word operations are now per-device operations
	rather than per-region.
	- A word_size attribute has been added so that users can get the OTP
	word size (useful for the area locking).
	- Regions can have labels (a bit like partition names).
	- The sysfs show/store functions now take a backend module reference
	before accessing the operations to prevent a possible invalid
	reference when the backend module is unloaded.

Thanks,

Jamie Iles (4):
  drivers/otp: add initial support for OTP memory
  drivers/otp: add support for Picoxcell PC3X3 OTP
  Blackfin: add the OTP device as a platform device
  drivers/otp: convert bfin otp to generic OTP

 Documentation/ABI/testing/sysfs-bus-otp      |   93 +++
 Documentation/ioctl/ioctl-number.txt         |    1 +
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
 drivers/{char => otp}/bfin-otp.c             |  261 +++----
 drivers/otp/otp.c                            | 1051 ++++++++++++++++++++++++
 drivers/otp/otp_pc3x3.c                      | 1102 ++++++++++++++++++++++++++
 include/linux/otp.h                          |  305 +++++++
 21 files changed, 2819 insertions(+), 169 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-otp
 create mode 100644 drivers/otp/Kconfig
 create mode 100644 drivers/otp/Makefile
 rename drivers/{char => otp}/bfin-otp.c (44%)
 create mode 100644 drivers/otp/otp.c
 create mode 100644 drivers/otp/otp_pc3x3.c
 create mode 100644 include/linux/otp.h

-- 
1.7.4

