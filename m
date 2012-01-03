Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab2ACTDA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 14:03:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53642 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666Ab2ACTC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 14:02:56 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <mjg@redhat.com>, linux-acpi@vger.kernel.org,
        platform-driver-x86@vger.kernel.org
Cc: Len Brown <lenb@kernel.org>, Azael Avalos <coproscefalo@gmail.com>,
        Thomas Renninger <trenn@suse.de>, linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH v2 0/4] toshiba_acpi: Expanded hotkey support
Date: Tue,  3 Jan 2012 13:02:34 -0600
Message-Id: <1325617358-8286-1-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an update to the patches I sent previously to enable hotkeys on
many Toshiba models that aren't supported by the code currently in
toshiba_acpi. Once agains, here's the high-level summary:

 * Add support for reading scancodes using the INFO method when
   avaialable and for generating hotkey notifications by filtering Fn
   key presses from the keyboard
 * Adds a new EC interface allowing toshiba_acpi to get a handle to the
   EC, which is needed because the NTFY method used to generate the
   hotkey notifications is in the EC namespace
 * Support some additional hotkey scancodes
 * Blacklist hotkey support for some Satellite models due to a buggy
   implementation of the INFO method on this model

The only change since v1 is to add additional machines to the hotkey
blacklist. These machines were identified by scraping bug reports to
identify machines with the same INFO method implementation in their
DSDTs.

Thanks,
Seth


Azael Avalos (1):
  toshiba_acpi: Support additional hotkey scancodes

Seth Forshee (3):
  ACPI: EC: Add ec_get_handle()
  toshiba_acpi: Support alternate hotkey interfaces
  toshiba_acpi: Add blacklist for models with hotkey problems

 drivers/acpi/ec.c                   |   10 ++
 drivers/platform/x86/toshiba_acpi.c |  275 ++++++++++++++++++++++++++++++-----
 include/linux/acpi.h                |    1 +
 3 files changed, 249 insertions(+), 37 deletions(-)
