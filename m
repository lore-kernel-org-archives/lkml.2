Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491Ab2IRIai (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 04:30:38 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:54522 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756785Ab2IRIaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 04:30:01 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: NeilBrown <neilb@suse.de>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Benoit Cousson <b-cousson@ti.com>, Felipe Balbi <balbi@ti.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] mfd: twl: Move PWM driver to PWM framework
Date: Tue, 18 Sep 2012 10:29:49 +0200
Message-Id: <1347956991-16088-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.7.12
X-Provags-ID: V02:K0:4YxxBeyfHDh5Um6OZ1nrgp06hdJxkFvyN5ifHE8zIRw
 5XM8HVxCHQYHfVldk/aQdxl+m5ZkEwnd2rj+PzVizABNtM3QcP
 leKzFDYJpdJFPq8TS3uKPQwwc3Z0zMCTGIQ3GOsDfaOFkQuf7u
 WfQyr74sPHSOL9Yk9/HfJWU0kD1kBCyl65ubL7TTJhF6gQ9JMe
 fvimKaoqEau8C5Vi9wGv8Xz87es9TWnlmT5ah4SbNNprw1irUc
 cHquB73a8odE/GSwX+iy9eM+cssBFu88rHUshJqWpI5OJWJuHV
 J8vqtujdbnIqa2ysEq1dWmUPDGRTPd9Dfy4/NBJpkrEbDRTOR3
 fEcK3URf+Lv9oOX1bpNq6ifz/5zLYMj6q5vCxFwpBPfA5g6AoN
 syXVCEsr51IYNRCbdAJ7ZF3BQhZrSOfhrOrJyPdNIeKXBDrWcP
 q509E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This mini series replaces the twl_has_*() macros by the equivalent
standard IS_ENABLED() macro and moves the PWM driver to the PWM
framework.

I'll take the second patch through the PWM tree but would like to have
some Acked-bys from people that know and have the hardware and can
verify that I haven't broken anything.

Thierry

Thierry Reding (2):
  mfd: twl: Replace twl_has_*() macros by IS_ENABLED()
  pwm: Move TWL6030 PWM driver to PWM framework

 drivers/mfd/Kconfig                              |  10 --
 drivers/mfd/Makefile                             |   1 -
 drivers/mfd/twl-core.c                           | 124 ++++++-----------------
 drivers/pwm/Kconfig                              |   9 ++
 drivers/pwm/Makefile                             |   1 +
 drivers/{mfd/twl6030-pwm.c => pwm/pwm-twl6030.c} | 119 +++++++++++++---------
 6 files changed, 111 insertions(+), 153 deletions(-)
 rename drivers/{mfd/twl6030-pwm.c => pwm/pwm-twl6030.c} (55%)

-- 
1.7.12

