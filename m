Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161569Ab2COVcP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 17:32:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55609 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756761Ab2COVcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 17:32:12 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH v3 0/2] Add driver for Apple gmux device
Date: Thu, 15 Mar 2012 16:32:06 -0500
Message-Id: <1331847128-16339-1-git-send-email-seth.forshee@canonical.com>
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

Changes since v2:

 - Add prerequisite patch for apple_bl to support disabling this
   backlight when a gmux backlight device is present.

 - Unregister acpi_video when a gmux backlight device is present.

Thanks,
Seth


Seth Forshee (2):
  apple_bl: Add register/unregister functions
  platform/x86: Add driver for Apple gmux device

 drivers/platform/x86/Kconfig       |   11 ++
 drivers/platform/x86/Makefile      |    1 +
 drivers/platform/x86/apple-gmux.c  |  242 ++++++++++++++++++++++++++++++++++++
 drivers/video/backlight/apple_bl.c |   23 +++-
 include/linux/apple_bl.h           |   11 ++
 5 files changed, 286 insertions(+), 2 deletions(-)
 create mode 100644 drivers/platform/x86/apple-gmux.c
 create mode 100644 include/linux/apple_bl.h

