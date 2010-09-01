Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738Ab0IACn4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 22:43:56 -0400
Received: from mail.perches.com ([173.55.12.10]:1161 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488Ab0IACny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 22:43:54 -0400
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_I2C driver to 2.6.35
From: Joe Perches <joe@perches.com>
To: Masayuki Ohtak <masa-korg@dsn.okisemi.com>
Cc: "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Crane Cai <crane.cai@amd.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        srinidhi kasagar <srinidhi.kasagar@stericsson.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Wang Yong Y\"" <yong.y.wang@intel.com>,
        "Wang Qi\"" <qi.wang@intel.com>,
        "Andrew\"" <andrew.chih.howe.khor@intel.com>, arjan@linux.intel.com,
        Tomoya MORINAGA <morinaga526@dsn.okisemi.com>,
        Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <4C7DB9CF.5000905@dsn.okisemi.com>
References: <4C7DB9CF.5000905@dsn.okisemi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 Aug 2010 19:43:52 -0700
Message-ID: <1283309032.1797.123.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-01 at 11:26 +0900, Masayuki Ohtak wrote:
> I2C driver of Topcliff PCH
> +++ b/drivers/i2c/busses/i2c-pch.c
[]
> +static void pch_init(struct i2c_algo_pch_data *adap)
[]
> +	if (pch_i2c_speed == FAST_MODE_CLK) {
> +		reg_value |= FAST_MODE_EN;
> +		dev_dbg(adap->pch_adapter.dev.parent, "Fast mode enabled\n");
> +	}

Just a suggestion below, ignore it at your pleasure...

These dev_<level> calls might be easier to read if you had
some #defines like:

#define pch_dbg(adap, fmt, arg...)		\
	dev_dbg(adap->pch_adapter.dev.parent, fmt, ##arg)
#define pch_err(adap, fmt, arg...)		\
	dev_err(adap->pch_adapter.dev.parent, fmt, ##arg)
#define pch_info(adap, fmt, arg...)		\
	dev_info(adap->pch_adapter.dev.parent, fmt, ##arg)

then the last dev_dbg becomes:

		pch_dbg(adap, "Fast mode enabled\n");

Many modules use similar wrapper #defines.

> +	dev_dbg(adap->pch_adapter.dev.parent,
> +		"%s: I2CCTL=%x pch_i2cbc=%x pch_i2ctmr=%x Enable interrupts\n",
> +		__func__, ioread32(p + PCH_I2CCTL),
> +		pch_i2cbc, pch_i2ctmr);

	pch_dbg(adap, etc...)

etc.

cheers, Joe

