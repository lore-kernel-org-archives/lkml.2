Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937Ab2HTOwO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 10:52:14 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62370 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756832Ab2HTOwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 10:52:07 -0400
Message-ID: <1345474316.9850.4.camel@phoenix>
Subject: Re: [PATCH] regulator: ab8500: fix voltage selector regression
From: Axel Lin <axel.lin@gmail.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org,
        Mattias Wallin <mattias.wallin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Date: Mon, 20 Aug 2012 22:51:56 +0800
In-Reply-To: <1345465097-31576-1-git-send-email-linus.walleij@stericsson.com>
References: <1345465097-31576-1-git-send-email-linus.walleij@stericsson.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 一，2012-08-20 於 14:18 +0200，Linus Walleij 提到：
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> Commit 3bf6e90e476fb34ca47b6dda270f41d9cebcb1ac
> "regulator: Convert ab8499 to use get_voltage_sel()"
> and commit ae713d394d9e2aacaab620acd3212855f1f06b00
> "regulator: Convert ab8500 to set_voltage_sel"
> corrupted the voltage selector mechanism is two ways:
I'm not very sure the commits you mentioned is the root cause,
because it looks that here is no behavior change with both commits.
Does it really work if you revert above commits you mention?

> 
> The function for getting the selector stopped respecting
> the bit shift to get the selector out, and the function
> for setting the selector hacked in a non-generic kludge
> that does not scale. Besides, the regulator info struct
> for the AB8500 already contains the proper shift values.
> 
> This sanitize the code so it works as expected again.

I got below build error after apply this patch to regulator tree.

  CC      drivers/regulator/ab8500.o
drivers/regulator/ab8500.c: In function
'ab8500_regulator_get_voltage_sel':
drivers/regulator/ab8500.c:197:2: error: 'struct ab8500_regulator_info'
has no member named 'voltage_shift'
drivers/regulator/ab8500.c:205:20: error: 'struct ab8500_regulator_info'
has no member named 'voltage_shift'
drivers/regulator/ab8500.c: In function
'ab8500_regulator_set_voltage_sel':
drivers/regulator/ab8500.c:221:31: error: 'struct ab8500_regulator_info'
has no member named 'voltage_shift'
drivers/regulator/ab8500.c: In function
'ab8500_regulator_get_voltage_sel':
drivers/regulator/ab8500.c:206:1: warning: control reaches end of
non-void function [-Wreturn-type]
make[2]: *** [drivers/regulator/ab8500.o] Error 1
make[1]: *** [drivers/regulator] Error 2
make: *** [drivers] Error 2

Regards,
Axel


