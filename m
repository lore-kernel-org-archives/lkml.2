Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759237Ab1LOSG7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 13:06:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34918 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab1LOSG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 13:06:58 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <mjg@redhat.com>, linux-acpi@vger.kernel.org,
        platform-driver-x86@vger.kernel.org
Cc: Len Brown <lenb@kernel.org>, Azael Avalos <coproscefalo@gmail.com>,
        linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH 0/4] toshiba_acpi: Expanded hotkey support
Date: Thu, 15 Dec 2011 12:06:07 -0600
Message-Id: <1323972371-13189-1-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,

The following patches expand toshiba_acpi's hotkey support to include
many additional models. Here's the high-level summary:

 * Add support for reading scancodes using the INFO method when
   avaialable and for generating hotkey notifications by filtering Fn
   key presses from the keyboard
 * Adds a new EC interface allowing toshiba_acpi to get a handle to the
   EC, which is needed because the NTFY method used to generate the
   hotkey notifications is in the EC namespace
 * Support some additional hotkey scancodes
 * Blacklist hotkey support for the Satellite C670-10V due to a buggy
   implementation of the INFO method on this model

More details can be found in the individual patch descriptions.

Cc-ing the ACPI folks on the full series to provide context regarding
how toshiba_acpi will use the new EC interface.

Thanks,
Seth


Azael Avalos (1):
  toshiba_acpi: Support additional hotkey scancodes

Seth Forshee (3):
  ACPI: EC: Add ec_get_handle()
  toshiba_acpi: Support alternate hotkey interfaces
  toshiba_acpi: Add blacklist for devices with hotkey problems

 drivers/acpi/ec.c                   |   10 ++
 drivers/platform/x86/toshiba_acpi.c |  254 ++++++++++++++++++++++++++++++-----
 include/linux/acpi.h                |    1 +
 3 files changed, 228 insertions(+), 37 deletions(-)
