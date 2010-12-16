Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792Ab0LPROR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 12:14:17 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47845 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100Ab0LPROL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 12:14:11 -0500
From: Wolfram Sang <w.sang@pengutronix.de>
To: devicetree-discuss@ozlabs.org
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: [RFC 0/3] Introduce of_probe_platform_driver()
Date: Thu, 16 Dec 2010 18:13:56 +0100
Message-Id: <1292519639-21859-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First, I noted a section mismatch in the mpc52xx_psc_spi-driver which tried to
have its probe in __init. Then, I noted that the mpc512x_psc_spi-driver was in
the __devinit-section, not in __init. I finally saw that there is no
of-equivalent to platform_driver_probe() and tried to implement one.

This is the outcome which seems to work on a MPC5121-board. I have my
spi-device and the sysfs does not show bind/unbind-files.

I can't yet tell why, but the approach looks a bit clumsy. Probably there is
some condition I have missed so far. It should work as a first RFC, however.
Release early, right? :)

All the best,

   Wolfram

Wolfram Sang (3):
  of: platform: introduce of_probe_platform_driver()
  spi: mpc52xx_psc_spi: fix section mismatch warning
  spi: mpc512x_psc_spi: move init-routines to __init

 drivers/of/platform.c         |   30 +++++++++++++++++++++++++++---
 drivers/spi/mpc512x_psc_spi.c |   10 +++++-----
 drivers/spi/mpc52xx_psc_spi.c |    4 ++--
 include/linux/of_platform.h   |    2 ++
 4 files changed, 36 insertions(+), 10 deletions(-)

-- 
1.7.2.3

