Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932724Ab1CWMRG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 08:17:06 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44799 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932698Ab1CWMRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 08:17:03 -0400
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, Jamie Iles <jamie@jamieiles.com>
Subject: [RFC PATCH 0/2] Support for picoxcell OTP memory
Date: Wed, 23 Mar 2011 12:16:57 +0000
Message-Id: <1300882619-19152-1-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds support for the OTP memory in picoxcell devices
which can be used for the first-stage bootloaders, cryptographic keys
and any other per-device information.  The first patch implements a
fairly generic OTP layer that handles the userspace interface and device
registration and abstracts the backend detail of how to actually read
and write the OTP to support different backends.

The second patch implements support for the OTP PC3X3 family of devices
which has 16KB of OTP.

Greg, I'm not sure if what I've done here is the best way to interface
with the driver model but I'm open to changes!

Jamie

Jamie Iles (2):
  picoxcell-otp: add support for picoxcell OTP devices
  picoxcellotp: add support for PC3X3 OTP devices

 Documentation/ABI/testing/sysfs-bus-picoxcell-otp  |   37 +
 .../ABI/testing/sysfs-platform-picoxcell-otp       |   39 +
 drivers/char/Kconfig                               |   15 +
 drivers/char/Makefile                              |    2 +
 drivers/char/picoxcellotp.c                        |  929 +++++++++++++++++
 drivers/char/picoxcellotp.h                        |  230 +++++
 drivers/char/picoxcellotp_pc3x3.c                  | 1078 ++++++++++++++++++++
 7 files changed, 2330 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-picoxcell-otp
 create mode 100644 Documentation/ABI/testing/sysfs-platform-picoxcell-otp
 create mode 100644 drivers/char/picoxcellotp.c
 create mode 100644 drivers/char/picoxcellotp.h
 create mode 100644 drivers/char/picoxcellotp_pc3x3.c

-- 
1.7.4

