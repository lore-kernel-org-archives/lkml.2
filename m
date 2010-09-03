Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964Ab0ICMST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 08:18:19 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39590 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757936Ab0ICMSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 08:18:16 -0400
Date: Fri, 3 Sep 2010 13:36:13 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Masayuki Ohtak <masa-korg@dsn.okisemi.com>
Cc: "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Crane Cai <crane.cai@amd.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        srinidhi kasagar <srinidhi.kasagar@stericsson.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        joe@perches.com, yong.y.wang@intel.com, qi.wang@intel.com,
        andrew.chih.howe.khor@intel.com, arjan@linux.intel.com,
        Tomoya MORINAGA <morinaga526@dsn.okisemi.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_I2C driver to 2.6.35
Message-ID: <20100903133613.1c519c49@lxorguk.ukuu.org.uk>
In-Reply-To: <4C80CBC0.5050908@dsn.okisemi.com>
References: <4C80CBC0.5050908@dsn.okisemi.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +config PCH_I2C_CH_COUNT
> +	int "PCH I2C the number of channel count"
> +	range 1 2
> +	depends on PCH_I2C
> +	help
> +	  This driver is for PCH(Platform controller Hub) I2C of Topcliff which
> +	  is an IOH(Input/Output Hub) for x86 embedded processor.
> +	  The number of I2C buses/channels supported by the PCH I2C controller.
> +	  PCH I2C of Topcliff supports only one channel.

These sort of settings need to be runtime so one kernel can be built for
many platform variants. In this case if I understand correctly the
current device only has one channel so the define could just be moved
into the driver for now and made a variable later as/when/if new hardware
with more channels appears.



> +static s32 pch_wait_for_xfer_complete(struct i2c_algo_pch_data *adap)
> +{
> +	s32 ret;
> +	ret = wait_event_interruptible_timeout(pch_event,
> +			(adap->pch_event_flag != 0), msecs_to_jiffies(50));
> +	if (ret < 0) {
> +		pch_err(adap, "timeout: %x\n", adap->pch_event_flag);
> +		return ret;
> +	}

You are reporting a timeout when _interruptible can also be woken by a
signal to the process (eg the user hitting ^C)


