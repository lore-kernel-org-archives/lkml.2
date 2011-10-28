Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab1J1U1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 16:27:19 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33651 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241Ab1J1U1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 16:27:18 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paul Mundt <lethal@linux-sh.org>, Tony Lindgren <tony@atomide.com>,
        Mike Frysinger <vapier@gentoo.org>, linux-sh@vger.kernel.org,
        linux-omap@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH] regulator: provide dummy supply support
Date: Fri, 28 Oct 2011 22:26:57 +0200
Message-Id: <1319833618-25190-1-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.7
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following patch allows it for boards to register a dummy supply for
devices for which no software controllable regulator is available. The
current CONFIG_REGULATOR_DUMMY and (unused) regulator_use_dummy_regulator()
mechanisms only allow to provide a dummy regulator for *all* devices
for which no regulator is found. This would shadow real errors and thus
is not really an option for production kernels.

This patch may eventually superseed the current all-or-nothing approach.

This came to me while looking over Linus' smsc911x regulator support
patch and so I added all people affected by this patch to Cc.

Sascha

