Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab2FCT3v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 15:29:51 -0400
Received: from gloria.sntech.de ([95.129.55.99]:47004 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754182Ab2FCT3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 15:29:50 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 0/3] regulator: gpio-regulator: Fixes for problems that turned up with 3.5-rc1
Date: Sun, 3 Jun 2012 21:29:45 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.37-2-686; KDE/4.4.5; i686; ; )
Cc: Liam Girdwood <lrg@ti.com>, LKML <linux-kernel@vger.kernel.org>,
        Axel Lin <axel.lin@gmail.com>,
        Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201206032129.45414.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During the porting of my machine to 3.5-rc1 some glitches in the
gpio-regulator from different changes popped up.

This series fixes these.

While doing this, I noticed a possible uninitialized use of "selector" in
_regulator_do_set_voltage, where I'm not sure what the correct fix would be.

To summarize, before
	if (rdev->desc->ops->list_voltage)
		best_val = rdev->desc->ops->list_voltage(rdev, selector);
	else
		best_val = -1;

selector is set in the set_voltage callback or if the new map_voltage returns
a non-error value. If it returns an error value or the else clause is reached
selector is used uninitialized in the list_voltage and set_voltage_time_sel
call.

As written above, I'm not sure what the correct fix would be here.


Heiko Stuebner (3):
  regulator: gpio-regulator: do not pass drvdata pointer as reference
  regulator: gpio-regulator: Fix finding of smallest value
  regulator: gpio-regulator: populate selector from set_voltage

 drivers/regulator/gpio-regulator.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

-- 
1.7.2.3

