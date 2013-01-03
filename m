Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab3ACN1g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 08:27:36 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:39174 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752853Ab3ACN1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 08:27:33 -0500
From: Matt Fleming <matt@console-pimps.org>
To: Steve Langasek <steve.langasek@canonical.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Olof Johansson <olof@lixom.net>,
        Tony Luck <tony.luck@intel.com>, Matt Fleming <matt.fleming@intel.com>
Subject: [RFC PATCH 0/2] EFI facilities bitfield
Date: Thu,  3 Jan 2013 13:18:03 +0000
Message-Id: <1357219085-4312-1-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

Various users expect different semantics from 'efi_enabled', and one
variable can't be all things to all users. Introduce an EFI facilities
bitfield, which informs users what EFI initialisation steps were
completed successfully (are the system/config tables mapped, can we
invoke runtime services, etc?) and allows users to clearly document
which pieces of EFI firmware functionality they're using.

The immediate motivation for this patch series is the bug report at,

    https://bugzilla.kernel.org/show_bug.cgi?id=47121

Drivers need a new means of detecting whether they're running on an
EFI machine, as sadly the expression,

    if (!efi_enabled)

hasn't been a sufficient condition for quite some time.

This series has only seen minimal runtime testing since it's an RFC
and is intended to start a discussion.

Matt Fleming (2):
  efi: Make 'efi_enabled' a function to query EFI facilities
  samsung-laptop: Disable on EFI hardware

 arch/x86/include/asm/efi.h             |  1 +
 arch/x86/kernel/reboot.c               |  2 +-
 arch/x86/kernel/setup.c                | 28 ++++++++---------
 arch/x86/platform/efi/efi.c            | 55 ++++++++++++++++++++--------------
 drivers/acpi/osl.c                     |  2 +-
 drivers/firmware/dmi_scan.c            |  2 +-
 drivers/firmware/efivars.c             |  4 +--
 drivers/firmware/iscsi_ibft_find.c     |  2 +-
 drivers/gpu/drm/radeon/radeon_device.c |  3 +-
 drivers/platform/x86/ibm_rtl.c         |  2 +-
 drivers/platform/x86/samsung-laptop.c  |  3 ++
 drivers/scsi/isci/init.c               |  2 +-
 include/linux/efi.h                    | 24 +++++++++++----
 init/main.c                            |  4 +--
 14 files changed, 80 insertions(+), 54 deletions(-)

-- 
1.7.11.7

