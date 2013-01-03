Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134Ab3ACH37 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 02:29:59 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15314 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab3ACH34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 02:29:56 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 02 Jan 2013 23:25:59 -0800
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <swarren@wwwdotorg.org>, Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH RESEND 0/2] usb: tegra: modifying port reset based on instance number
Date: Thu, 3 Jan 2013 12:59:37 +0530
Message-ID: <1357198179-10031-1-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
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

