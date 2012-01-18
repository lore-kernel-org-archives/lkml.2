Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450Ab2ARToX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 14:44:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52134 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756406Ab2ARToT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 14:44:19 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <mjg@redhat.com>, linux-acpi@vger.kernel.org,
        platform-driver-x86@vger.kernel.org
Cc: Len Brown <lenb@kernel.org>, Azael Avalos <coproscefalo@gmail.com>,
        Thomas Renninger <trenn@suse.de>,
        Seth Forshee <seth.forshee@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/4] toshiba_acpi: Expanded hotkey support
Date: Wed, 18 Jan 2012 13:44:07 -0600
Message-Id: <1326915852-19896-1-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's another round of the patches for expanded hotkey support for
Toshibas addressing the problems raised in the last round. Changes since
v2:

 * Use WMI GUID instead of DMI data to identify models with buggy INFO
   implementations
 * Add comment in makefile regarding link order requirement necessary
   for the above

Thanks,
Seth


Azael Avalos (1):
  toshiba_acpi: Support additional hotkey scancodes

Seth Forshee (3):
  ACPI: EC: Add ec_get_handle()
  toshiba_acpi: Support alternate hotkey interfaces
  toshiba_acpi: Refuse to load on machines with buggy INFO
    implementations

 drivers/acpi/ec.c                   |   10 ++
 drivers/platform/x86/Kconfig        |    1 +
 drivers/platform/x86/Makefile       |    4 +
 drivers/platform/x86/toshiba_acpi.c |  246 +++++++++++++++++++++++++++++-----
 include/linux/acpi.h                |    1 +
 5 files changed, 225 insertions(+), 37 deletions(-)
