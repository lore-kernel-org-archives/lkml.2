Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932334Ab1CXPV0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 11:21:26 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59836 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab1CXPVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 11:21:25 -0400
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, vapier@gentoo.org, Jamie Iles <jamie@jamieiles.com>
Subject: [RFC PATCHv2 0/4] Support for OTP memory
Date: Thu, 24 Mar 2011 15:21:07 +0000
Message-Id: <1300980071-24645-1-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following some feedback from Greg, I've updated this series to be more
of a generic OTP layer.  Everything is now registered under the "otp"
bus and I've also converted the blackfin OTP driver to use this
framework (which is the only current OTP driver I could find).

Mike, I wasn't 100% sure how big the blackfin OTP is but I found a
datasheet talking about 64KB so I've assumed that for now.

Main changes since v1:

	- both devices and regions are now on the "otp" bus.
	- moved to drivers/otp.
	- converted bfin-otp to the generic OTP layer.

Jamie Iles (4):
  drivers/otp: add initial support for OTP memory
  drivers/otp: add support for Picoxcell PC3X3 OTP
  drivers/otp: allow an ioctl to be specified
  drivers/otp: convert bfin otp to generic OTP

 Documentation/ABI/testing/sysfs-bus-otp |   68 ++
 drivers/Kconfig                         |    2 +
 drivers/Makefile                        |    1 +
 drivers/char/Kconfig                    |   28 -
 drivers/char/Makefile                   |    1 -
 drivers/otp/Kconfig                     |   49 ++
 drivers/otp/Makefile                    |    3 +
 drivers/{char => otp}/bfin-otp.c        |  174 +++---
 drivers/otp/otp.c                       |  896 +++++++++++++++++++++++++
 drivers/otp/otp_pc3x3.c                 | 1079 +++++++++++++++++++++++++++++++
 include/linux/otp.h                     |  224 +++++++
 11 files changed, 2397 insertions(+), 128 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-otp
 create mode 100644 drivers/otp/Kconfig
 create mode 100644 drivers/otp/Makefile
 rename drivers/{char => otp}/bfin-otp.c (54%)
 create mode 100644 drivers/otp/otp.c
 create mode 100644 drivers/otp/otp_pc3x3.c
 create mode 100644 include/linux/otp.h

-- 
1.7.4

