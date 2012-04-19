Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760Ab2DSQcQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 12:32:16 -0400
Received: from antcom.de ([188.40.178.216]:37129 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753021Ab2DSQcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 12:32:15 -0400
Message-ID: <4F903E0C.6010604@antcom.de>
Date: Thu, 19 Apr 2012 18:32:12 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20120216 Icedove/8.0
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>, vitalywool@gmail.com,
        khali@linux-fr.org, ben-linux@fluff.org, rob.herring@calxeda.com,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com
Subject: Re: [PATCH v4] i2c: Add device tree support to i2c-pnx.c
References: <1334850612-24151-1-git-send-email-stigge@antcom.de> <20120419160715.GD24987@pengutronix.de>
In-Reply-To: <20120419160715.GD24987@pengutronix.de>
X-Enigmail-Version: 1.3.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 04/19/2012 06:07 PM, Wolfram Sang wrote:
>> + - clock-frequency: desired I2C bus clock frequency in Hz,
>> Default: 100000 Hz + - pnx,timeout: I2C bus timeout in
>> milliseconds, Default: 10 ms
> 
> I'd like to repeat my question to the devicetree folks here: Can we
> have timeout generic? It doesn't make sense to me to have that per
> vendor again and again.

Sounds completely reasonable.

To help make the devicetree conversion into 3.5, I would prefer to
integrate the "vendor,timeout" as-is if a longish standardization
process would block this, considering that we luckily only have 2-3 of
such timeout definitions currently.

I'd volunteer to clean up later by preparing a patch when there is a
standard timeout defined.

If we have a solution soon, I will prepare a new version of the patch,
of course, in the next days.

>> +	i2c2: i2c@400a8000 { +		compatible = "nxp,pnx-i2c"; +		reg =
>> <0x400a8000 0x100>; +		interrupt-parent = <&mic>; +		interrupts =
>> <50 0>; +		#address-cells = <1>; +		#size-cells = <0>; +
>> clock-frequency = <0x186a0>; +		pnx,timeout = <0x64>;
> 
> Did you change this, too? Timeouts are better readable in dec :)

Right. But even when removing the "0x" in the timeout line above, it's
still hex, see Documentation/devicetree/booting-without-of.txt

Or did I get sth. wrong?

Thanks,

Roland
