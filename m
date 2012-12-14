Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab2LNHPN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 02:15:13 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5728 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab2LNHPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 02:15:11 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 13 Dec 2012 23:13:19 -0800
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <swarren@wwwdotorg.org>, <linux@arm.linux.org.uk>,
        <stern@rowland.harvard.edu>, <gregkh@linuxfoundation.org>,
        <sjg@chromium.org>, <olof@lixom.net>
CC: <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH 0/2] usb: tegra: modifying port reset based on instance number
Date: Fri, 14 Dec 2012 12:29:06 +0530
Message-ID: <1355468348-8821-1-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tegra USB host driver is using port instance number,
to handle some of the hardware issues on SOC e.g. reset PORT0
twice etc. As instance number based handling looks ugly,
added a new property to USB DT node for this purpose.
Modified host driver to make use of the information passed
through DT to reset the port second time.


Venu Byravarasu (2):
  arm: tegra: Add new DT property to USB node.
  usb: host: tegra: Resetting PORT0 based on information received via
    DT.

 .../bindings/usb/nvidia,tegra20-ehci.txt           |    2 ++
 arch/arm/boot/dts/tegra20.dtsi                     |    1 +
 drivers/usb/host/ehci-tegra.c                      |    6 +++++-
 3 files changed, 8 insertions(+), 1 deletions(-)

