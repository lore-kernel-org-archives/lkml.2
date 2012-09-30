Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751197Ab2I3PKJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 11:10:09 -0400
Received: from antcom.de ([188.40.178.216]:52635 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797Ab2I3PKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 11:10:08 -0400
Message-ID: <506860C6.5020408@antcom.de>
Date: Sun, 30 Sep 2012 17:09:58 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.7) Gecko/20120922 Icedove/10.0.7
MIME-Version: 1.0
To: Stijn Devriendt <highguy@gmail.com>
CC: grant.likely@secretlab.ca, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        w.sang@pengutronix.de, jbe@pengutronix.de,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        bgat@billgatliff.com
Subject: Re: [PATCH RFC 1/2] gpio: Add a block GPIO API to gpiolib
References: <1348780923-27428-1-git-send-email-stigge@antcom.de> <CAOY=C6GG6jqqEAAGJjmDG-BFT2eq=9+ck+F_EOcthRgDCDv8=Q@mail.gmail.com> <50682402.8020402@antcom.de> <CAOY=C6FaLckRHSfAHvw2=J9xZEVFDZPL+1oKnKeGnpOGPFVB1w@mail.gmail.com>
In-Reply-To: <CAOY=C6FaLckRHSfAHvw2=J9xZEVFDZPL+1oKnKeGnpOGPFVB1w@mail.gmail.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stijn,

On 30/09/12 16:52, Stijn Devriendt wrote:
>> One question: How did you solve the one-value-per-file in the sysfs
>> interface?
>>
> By exporting the group as a whole:
> /sys/.../gpiogroup248/value
> where value contains a decimal representing the group value.
> Again, this respects the ordering of the pins:
> 
> Actual pins: 0x2D (b 0010 1101)
> Selected pins: 6 3 0 1
> Readout: 6 (b 0 1 1 0)
> 
> The export sysfs file does, however, accept multiple gpio IDs for groups.
> Not sure if this is a 'violation' per se...

If I understand correctly, it's a violation (single-value should hold
for read and write).

To solve it, I have the following in mind: /sys/.../gpiogroupXXX/
contains files "bit0" ... "bit31" which contain a gpio number each,
empty if "unconnected".

Roland
