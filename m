Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751671Ab2L0AOl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 19:14:41 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:57507 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab2L0AOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 19:14:39 -0500
From: Tony Prisk <linux@prisktech.co.nz>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH 0/3] clk fixes for 3.8
Date: Thu, 27 Dec 2012 13:14:28 +1300
Message-Id: <1356567272-3420-1-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike,

Three bugfixes for 3.8.

#1 was a boo-boo on my part, function returned the wrong variables.
#2 is a truncation problem which results in a higher-than-requested clock rate.
#3 became apparent when the MMC driver started requesting rate=0 during init.

Tony Prisk (3):
  clk: vt8500: Fix error in PLL calculations on non-exact match.
  clk: vt8500: Fix device clock divisor calculations
  clk: vt8500: Fix division-by-0 when requested rate=0

 drivers/clk/clk-vt8500.c |   28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

-- 
1.7.9.5

