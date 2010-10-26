Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998Ab0JZIVP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 04:21:15 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:40745 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab0JZIVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 04:21:13 -0400
Date: Tue, 26 Oct 2010 10:20:48 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Tomoya <tomoya-linux@dsn.okisemi.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Wolfram Sang <w.sang@pengutronix.de>,
        Ralf Baechle <ralf@linux-mips.org>, linux-i2c@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        srinidhi kasagar <srinidhi.kasagar@stericsson.com>,
        Tomoya MORINAGA <morinaga526@dsn.okisemi.com>,
        "Wang Qi\"" <qi.wang@intel.com>,
        "Wang Yong Y\"" <yong.y.wang@intel.com>, kok.howg.ewe@intel.com,
        joel.clark@intel.com, andrew.chih.howe.khor@intel.com
Subject: Re: [PATCH v3] Topcliff: Update PCH_I2C driver to 2.6.36
Message-ID: <20101026102048.316d0c04@endymion.delvare>
In-Reply-To: <4CC645A1.5010509@dsn.okisemi.com>
References: <4CC645A1.5010509@dsn.okisemi.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomoya,

On Tue, 26 Oct 2010 12:06:09 +0900, Tomoya wrote:
> Could you merge this patch to 2.6.37 ? 
> 
> Change Summary
>  - Change Author
>  - Change Name of "Signed-off-by"
> 
> Thanks, Tomoya(OKI SEMICONDUCTOR CO., LTD.)
> 
> ---
> I2C driver of Topcliff PCH
> 
> Topcliff PCH is the platform controller hub that is going to be used in
> Intel's upcoming general embedded platform. All IO peripherals in
> Topcliff PCH are actually devices sitting on AMBA bus.
> Topcliff PCH has I2C I/F. Using this I/F, it is able to access system
> devices connected to I2C.
> 
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
> Reviewed-by: Linus Walleij <linus.walleij@stericsson.com>
> 
> ---
>  drivers/i2c/busses/Kconfig   |    8 +
>  drivers/i2c/busses/Makefile  |    1 +
>  drivers/i2c/busses/i2c-pch.c |  908 ++++++++++++++++++++++++++++++++++++++++++

I don't like this driver name at all. For one thing, "pch" is too
short. Many other vendors could come up with names with acronym "PCH".

For another, Intel has many PCH (Platform Controller Hub) chips, some
of them (5/3400 Series, Cougar Point, Patsburg) are or will be
supported by the i2c-i801 driver, some of them (Moorestown) will be
supported by the upcoming i2c-intel-mid driver (even though the name
"PCH" is surprisingly missing from the source code) and your driver
only supports one particular model.

So please find a name which accurately represents the hardware your
driver is for. i2c-topcliff would be fine with me, but you will have to
check with Intel, as I know they are quite picky with the usage of code
names.

As for the driver code, I will not be able to review it, sorry. It's
not in my area, I don't have the time and I don't have the hardware. I
think it would make sense for Intel people to review and test it before
it gets upstream.

-- 
Jean Delvare
