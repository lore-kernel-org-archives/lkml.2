Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493Ab0JDQJa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 12:09:30 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48812 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab0JDQJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 12:09:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=w6S9k4xbSsvktHnl5GeWVDsq27mYJDr42Ys6wjmrmqo1GIEhpn/Ywj/jeY2DxBEXI3
         71Ef+PMVG7WRZFF1wlZ+SpbqYn5n7eqX1suK1my/gX0Dzqv7ZZPDcoYA+MqJaSdvXpOC
         WRG9Qnz95JkI8sEvVysTwKPvPJiQcsalr78ls=
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-omap <linux-omap@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>
Cc: Greg KH <greg@kroah.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        Tony Lindgren <tony@atomide.com>,
        Omar Ramirez Luna <omar.ramirez@ti.com>,
        Hiroshi Doyu <hiroshi.doyu@nokia.com>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH 0/2] omap: dsp: make the driver actually work
Date: Mon,  4 Oct 2010 19:09:13 +0300
Message-Id: <1286208555-8829-1-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.7.3.1.2.g7fe2b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It seems the platform device was dropped from the migration of tidspbridge into
staging, plus the sdram meblock (previously bootmem) required for it work are
gone.

Withouth these patches the driver loads, but doesn't do anything.

A second issue with ioremap() still remains, but that can be solved by
reverting 309caa9.

I think these might be worth to get into 2.6.36, if not, I have versions with
more changes; cleanups and so on.

Tested on a Nokia N900.

Felipe Contreras (2):
  omap: add dsp platform device
  staging: tidspbridge: use omap_dsp_platform_data

 arch/arm/mach-omap2/Makefile                       |    4 +
 arch/arm/mach-omap2/dsp.c                          |   85 ++++++++++++++++++++
 arch/arm/plat-omap/common.c                        |    2 +
 arch/arm/plat-omap/devices.c                       |   30 +++++++
 arch/arm/plat-omap/include/plat/dsp.h              |   31 +++++++
 drivers/staging/tidspbridge/core/tiomap3430.c      |   14 ++--
 drivers/staging/tidspbridge/core/tiomap3430_pwr.c  |   14 ++--
 drivers/staging/tidspbridge/core/tiomap_io.c       |    4 +-
 .../tidspbridge/include/dspbridge/host_os.h        |   19 -----
 drivers/staging/tidspbridge/rmgr/drv_interface.c   |   10 ++-
 10 files changed, 177 insertions(+), 36 deletions(-)
 create mode 100644 arch/arm/mach-omap2/dsp.c
 create mode 100644 arch/arm/plat-omap/include/plat/dsp.h

-- 
1.7.3.1.2.g7fe2b

