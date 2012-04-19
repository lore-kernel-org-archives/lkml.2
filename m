Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965379Ab2DSVSq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:18:46 -0400
Received: from antcom.de ([188.40.178.216]:40380 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965355Ab2DSVSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:18:43 -0400
Message-ID: <4F90812F.5090106@antcom.de>
Date: Thu, 19 Apr 2012 23:18:39 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
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
References: <1334850612-24151-1-git-send-email-stigge@antcom.de> <20120419160715.GD24987@pengutronix.de> <4F903E0C.6010604@antcom.de> <20120419203915.GB28005@pengutronix.de>
In-Reply-To: <20120419203915.GB28005@pengutronix.de>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On 19/04/12 22:39, Wolfram Sang wrote:
>> If we have a solution soon, I will prepare a new version of the 
>> patch, of course, in the next days.
> 
> Thanks. One question, though: Will it really block dt-conversion? 
> The whole conversion should not be depending on the i2c-driver?

Technically, it would certainly be possible to convert some drivers
and leave others. But I would highly prefer to convert i2c also. With
LPC32xx, there are typically many I2C clients depending on DT on a
reasonable DT enabled mach.

I'm fine with "timeout" also, when you accept it into pnx-i2c.c and
will certainly provide a "timeout" patch update so you can pick the
version which suits best.

Another solution would be to not use timeout with the dt enabled
i2c-pnx for now (using the hard coded default timeout as the current
i2c-pnx.c does) and possibly introduce the (anyway optional) "timeout"
later.

Actually, that would be my favour.

What do you think?

>>> Did you change this, too? Timeouts are better readable in dec
>>> :)
>> 
>> Right. But even when removing the "0x" in the timeout line
>> above, it's still hex, see 
>> Documentation/devicetree/booting-without-of.txt
>> 
>> Or did I get sth. wrong?
> 
> I think the document is probably outdated :( "clock-frequency" is 
> also without 0x and dec.

Interesting! When the documentation is outdated - how does the parser
actually decide between hex (e.g. regs/addresses) and dec (e.g.
clock-frequency) in the absence of "0x"?

Thanks in advance,

Roland
