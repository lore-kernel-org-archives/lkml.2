Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab1EBAtm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 20:49:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752242Ab1EBAtk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 20:49:40 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 0/2] vga switcheroo: Prevent nouveau irq handler from kill the
 system
To: airlied@linux.ie, dri-devel@lists.freedesktop.org
Cc: alex.williamson@redhat.com, linux-kernel@vger.kernel.org
Date: Sun, 01 May 2011 18:49:21 -0600
Message-ID: <20110502004806.2307.34136.stgit@ul30vt.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On an Intel/Nvidia hybrid graphics system, using the integrated
graphics and powering off the discrete, one of the primary sources
of system hangs seems to be the nouveau driver processing interrupts
while the device is powered off.  This short series removes the
unbalanced pci_enable_device() from core switcheroo code, allowing
us to check pci_is_enabled() from the nouveau irq handler to determine
whether to touch hardware.  Thanks,

Alex

---

Alex Williamson (2):
      drm/nouveau: Check that the device is enabled before processing interrupt
      vga_switcheroo: Remove unbalanced pci_enable_device


 drivers/gpu/drm/nouveau/nouveau_drv.c |    2 ++
 drivers/gpu/drm/nouveau/nouveau_irq.c |    3 +++
 drivers/gpu/vga/vga_switcheroo.c      |    6 ------
 3 files changed, 5 insertions(+), 6 deletions(-)
