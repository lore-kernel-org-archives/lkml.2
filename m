Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932981Ab2FVOcP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 10:32:15 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33815 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932246Ab2FVOb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 10:31:26 -0400
From: sjur.brandeland@stericsson.com
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjurbren@gmail.com>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [RFC 0/4] STE-modem remoteproc driver
Date: Fri, 22 Jun 2012 16:31:06 +0200
Message-Id: <1340375470-13097-1-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

Hi Ohad,

This is the initial stab on the remoteproc driver for ST-Ericsson modems.
Please let me know what you think.

remoteproc_ste_modem features:
For kicking to work I need to declare what IDs I'm currently using, so I had to
iterate over the rproc->notifyids to find the IDs. 

A sysfs file is introduced for switching on/off the modem, as modem
start-up must be controlled from user space. 

As mentioned before I need the firmware to be allocated first in the shared
memory are. So in order to reserve  space for firmware at the start of the
memory region, I had to allocate dma memory before calling rproc_register(),
and then releasing it afterward.


I do not yet have an implementation of the stemod_kick module available. It
might take a while before this is upstreamed. The stemod_kick functions are
looked up dynamically so this is not a build issue.

The platform device is not yet upstreamed either. But it should be pretty simple,
it basically just provides the shared memory area to the driver.

I also included one fix in this patch-set. It doesn't seems like carveout for
non-iommu is working correctly. I added a simple patch for this.
Let me know what you think, and how to proceed for this fix.

Best regards,
Sjur Brændeland

Sjur Brændeland (4):
  remoteproc: Bugfix assign device address to carveout (noiommu)
  remoteproc: Add custom STE-modem firmware loader.
  remoteproc: Add API (header file) for kicking STE modems
  remoteproc: Add driver for STE Modem

 drivers/remoteproc/Kconfig                       |   10 +
 drivers/remoteproc/Makefile                      |    3 +
 drivers/remoteproc/remoteproc_core.c             |    4 +
 drivers/remoteproc/remoteproc_internal.h         |    1 +
 drivers/remoteproc/remoteproc_ste_modem_loader.c |  179 ++++++++++++
 drivers/remoteproc/ste_modem_rproc.c             |  333 ++++++++++++++++++++++
 drivers/remoteproc/stemod_kick.h                 |  113 ++++++++
 7 files changed, 643 insertions(+), 0 deletions(-)
 create mode 100644 drivers/remoteproc/remoteproc_ste_modem_loader.c
 create mode 100644 drivers/remoteproc/ste_modem_rproc.c
 create mode 100644 drivers/remoteproc/stemod_kick.h

-- 
1.7.5.4

