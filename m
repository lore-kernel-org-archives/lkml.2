Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134Ab2FSLPd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 07:15:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47441 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab2FSLPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 07:15:31 -0400
Message-ID: <1340104522.3964.1.camel@phoenix>
Subject: regulator: tps6586x: What is the meaning of TPS6586X_SLEW_RATE_SET
 setting?
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mike Rapoport <mike@compulab.co.il>, Danny Huang <dahuang@nvidia.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 19 Jun 2012 19:15:22 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,
While looking at the datasheet (tps65860 and tps65862),
I don't understand why we have TPS6586X_SLEW_RATE_SET (0x08) in the code.

According to the datasheet, BIT3 of SM1SL/SM0SL is not used:

SM1SL [Addr 0x25]
SM0SL [Addr 0x28]
        BIT[2:0] SM0/SM1 SUPPLY RAMP RATE
        BIT[7:3] NOT USED

So why we need to check the "unused bit" in tps6586x_regulator_set_slew_rate()?

        if (!(setting->slew_rate & TPS6586X_SLEW_RATE_SET))
                return 0;

Regards,
Axel

