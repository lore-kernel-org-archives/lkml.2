Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084Ab0LVO0b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 09:26:31 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37955 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab0LVO0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 09:26:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JSF1oj52VTHVk+IIA7XzkaN1uA9c2OmCpy0Gd5klHTW60FAvGo91B6sG8UW7ZvtcQT
         d4n2w9dj8wNOO92Cdju8nnOVJEcbNDKBjqPp+c275JSR6nNj4M6jbJoBnY++wjbv4y8Q
         vkR2N45esd1mC6KWl+/8yYSC9hQQ369zy9hAs=
From: "Anoop P.A" <anoop.pa@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Anatolij Gustschin <agust@denx.de>, Anand Gadiyar <gadiyar@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Oliver Neukum <oneukum@suse.de>, Hans de Goede <hdegoede@redhat.com>,
        Paul Mortier <mortier@btinternet.com>, Andiry Xu <andiry.xu@amd.com>
Cc: Anoop P A <anoop.pa@gmail.com>
Subject: [PATCH V2 0/2] EHCI support for on-chip PMC MSP USB controller
Date: Wed, 22 Dec 2010 20:04:07 +0530
Message-Id: <1293028447-21703-1-git-send-email-anoop.pa@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1292929580-5829-1-git-send-email-anoop.pa@gmail.com>
References: <1292929580-5829-1-git-send-email-anoop.pa@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anoop P A <anoop.pa@gmail.com>

Changes Since V1:
1.Updated driver code with changes from ehci-pci.c
2.Moved over current fixup to different patch.
3.Removed #ifdef and added quirk list entry for overcurrent fixup.

Anoop P A (2):
  EHCI support for on-chip PMC MSP USB controller.
  MSP onchip root hub over current quirk.

 .../mips/include/asm/pmc-sierra/msp71xx/msp_regs.h |   17 +-
 arch/mips/include/asm/pmc-sierra/msp71xx/msp_usb.h |  144 +++++
 arch/mips/pmc-sierra/Kconfig                       |    8 +
 arch/mips/pmc-sierra/msp71xx/Makefile              |    2 +-
 arch/mips/pmc-sierra/msp71xx/msp_usb.c             |  239 +++++++---
 drivers/usb/core/hub.c                             |   45 ++-
 drivers/usb/core/quirks.c                          |    3 +
 drivers/usb/host/Kconfig                           |   15 +-
 drivers/usb/host/ehci-hcd.c                        |   12 +
 drivers/usb/host/ehci-pmcmsp.c                     |  551 ++++++++++++++++++++
 include/linux/usb/quirks.h                         |    3 +
 11 files changed, 959 insertions(+), 80 deletions(-)
 create mode 100644 arch/mips/include/asm/pmc-sierra/msp71xx/msp_usb.h
 create mode 100644 drivers/usb/host/ehci-pmcmsp.c

