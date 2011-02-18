Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027Ab1BRR7W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 12:59:22 -0500
Received: from smtp-out.google.com ([216.239.44.51]:46374 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027Ab1BRR7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 12:59:19 -0500
From: Vincent Palatin <vpalatin@chromium.org>
To: Peter Tyser <ptyser@xes-inc.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Alek Du <alek.du@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Eric Miao <eric.y.miao@gmail.com>,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>, Olof <olofj@chromium.org>,
        vbendeb <vbendeb@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>
Subject: Re: [PATCH v3 4/4] gpio: Add support for Intel ICHx/3100/Series[56] GPIO
Date: Fri, 18 Feb 2011 12:58:14 -0500
Message-Id: <1298051894-30600-1-git-send-email-vpalatin@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1297983799-4747-4-git-send-email-ptyser@xes-inc.com>
References: <1297983799-4747-4-git-send-email-ptyser@xes-inc.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have tested it on a Pineview / Tigerpoint based board.
It works well given you add the PCI ids for the tigerpoint/NM10 chipset
(cf patch below).
The Tigerpoint/NM10 is ICH7 based for the GPIO part.

Tested-by: Vincent Palatin <vpalatin@chromium.org>

Signed-off-by: Vincent Palatin <vpalatin@chromium.org>
---
 drivers/gpio/ichx_gpio.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/ichx_gpio.c b/drivers/gpio/ichx_gpio.c
index 4c7aec6..4bba9af 100644
--- a/drivers/gpio/ichx_gpio.c
+++ b/drivers/gpio/ichx_gpio.c
@@ -394,6 +394,7 @@ static DEFINE_PCI_DEVICE_TABLE(ichx_pci_tbl) = {
 	{ ICHX_GPIO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH7_1, &ich7_desc) },
 	{ ICHX_GPIO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH7_30, &ich7_desc) },
 	{ ICHX_GPIO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH7_31, &ich7_desc) },
+	{ ICHX_GPIO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_TGP_LPC, &ich7_desc) },
 	{ ICHX_GPIO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_0, &ich7_desc) },
 	{ ICHX_GPIO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_1, &ich7_desc) },
 	{ ICHX_GPIO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_2, &ich7_desc) },
-- 
1.7.3.1

