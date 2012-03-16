Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290Ab2CPTl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 15:41:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60085 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757081Ab2CPTl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 15:41:27 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH v4 0/2] Add driver for Apple gmux device
Date: Fri, 16 Mar 2012 14:41:20 -0500
Message-Id: <1331926882-22979-1-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apple laptops with hybrid graphics have a device named gmux that is used
for switching between GPUs and backlight control. On many models this is
the only reliable method for controlling the backlight.

This series adds initial support for the gmux device, along with
anciallary support for disabling apple_bl when the gmux device is
detected. Initially only backlight control is supported.

Changes since v3:

 - Rename apple_bl_register_count to apple_bl_registered and make it
   static.

 - Add stubs for apple_bl register/unregister functions and drop
   APPLE_GMUX's dependency on BACKLIGHT_APPLE.

Thanks,
Seth


Seth Forshee (2):
  apple_bl: Add register/unregister functions
  platform/x86: Add driver for Apple gmux device

 drivers/platform/x86/Kconfig       |   10 ++
 drivers/platform/x86/Makefile      |    1 +
 drivers/platform/x86/apple-gmux.c  |  242 ++++++++++++++++++++++++++++++++++++
 drivers/video/backlight/apple_bl.c |   23 +++-
 include/linux/apple_bl.h           |   26 ++++
 5 files changed, 300 insertions(+), 2 deletions(-)
 create mode 100644 drivers/platform/x86/apple-gmux.c
 create mode 100644 include/linux/apple_bl.h

