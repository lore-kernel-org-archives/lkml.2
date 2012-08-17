Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758415Ab2HQQRh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 12:17:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45289 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757054Ab2HQQRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 12:17:20 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        platform-driver-x86@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, David Airlie <airlied@linux.ie>,
        Andreas Heider <andreas@meetr.de>,
        Bernhard Froemel <froemel@vmars.tuwien.ac.at>
Subject: [PATCH v2 0/3] Display switching support for Apple laptops
Date: Fri, 17 Aug 2012 11:17:01 -0500
Message-Id: <1345220224-22872-1-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds display switching support for Apple laptops. The first
two patches contain preparatory changes to vga_switcheroo, and the third
contains the changes to support display switching with the gmux.

While these patches will allow switching the display mux, most Macbook
owners will not be able to switch GPUs in practice until the graphics
drivers are updated to deal with missing or incorrect vbios information
on Apple machines. These patches do fix an issue seen by some users of
Linux on Macbooks, however. These users will switch to the internal GPU
in OS X and then reboot into Linux to save power, but after S3 the gmux
gets reset to the discrete GPU. Adding the display mux support will fix
this problem by restoring the gmux state during resume.

v2: Disable interrupts during suspend and re-enable them during resume
    to fix timeouts waiting for switching to complete after S3

Thanks,
Seth


Andreas Heider (1):
  apple-gmux: Add display mux support

Seth Forshee (2):
  vga_switcheroo: Don't require handler init callback
  vga_switcheroo: Remove assumptions about registration/unregistration
    ordering

 drivers/gpu/drm/nouveau/nouveau_acpi.c |    6 -
 drivers/gpu/vga/vga_switcheroo.c       |   61 +++++----
 drivers/platform/x86/apple-gmux.c      |  224 ++++++++++++++++++++++++++++++++
 3 files changed, 262 insertions(+), 29 deletions(-)

