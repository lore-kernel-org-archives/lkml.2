Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934162Ab0GOSkw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 14:40:52 -0400
Received: from imap.ru.mvista.com ([213.79.90.228]:30212 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S934152Ab0GOSks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 14:40:48 -0400
Date: Thu, 15 Jul 2010 22:40:45 +0400
From: Anton Vorontsov <avorontsov@mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Doug Thompson <dougthompson@xmission.com>,
        Peter Tyser <ptyser@xes-inc.com>, Dave Jiang <djiang@mvista.com>,
        Kumar Gala <galak@kernel.crashing.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org
Subject: [PATCH] edac: mpc85xx: Fix coldplug/hotplug module autoloading
Message-ID: <20100715184045.GA10275@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MPC85xx EDAC driver is missing module device aliases, so the driver
won't load automatically on boot. This patch fixes the issue by
adding proper MODULE_DEVICE_TABLE() macros.

Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>
---
 drivers/edac/mpc85xx_edac.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/mpc85xx_edac.c b/drivers/edac/mpc85xx_edac.c
index 3820879..cfa86f7 100644
--- a/drivers/edac/mpc85xx_edac.c
+++ b/drivers/edac/mpc85xx_edac.c
@@ -336,6 +336,7 @@ static struct of_device_id mpc85xx_pci_err_of_match[] = {
 	},
 	{},
 };
+MODULE_DEVICE_TABLE(of, mpc85xx_pci_err_of_match);
 
 static struct of_platform_driver mpc85xx_pci_err_driver = {
 	.probe = mpc85xx_pci_err_probe,
@@ -654,6 +655,7 @@ static struct of_device_id mpc85xx_l2_err_of_match[] = {
 	{ .compatible = "fsl,p4080-l2-cache-controller", },
 	{},
 };
+MODULE_DEVICE_TABLE(of, mpc85xx_l2_err_of_match);
 
 static struct of_platform_driver mpc85xx_l2_err_driver = {
 	.probe = mpc85xx_l2_err_probe,
@@ -1133,6 +1135,7 @@ static struct of_device_id mpc85xx_mc_err_of_match[] = {
 	{ .compatible = "fsl,p4080-memory-controller", },
 	{},
 };
+MODULE_DEVICE_TABLE(of, mpc85xx_mc_err_of_match);
 
 static struct of_platform_driver mpc85xx_mc_err_driver = {
 	.probe = mpc85xx_mc_err_probe,
-- 
1.7.0.5
