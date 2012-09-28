Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714Ab2I1JwZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 05:52:25 -0400
Received: from antcom.de ([188.40.178.216]:40950 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753858Ab2I1JwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 05:52:24 -0400
Message-ID: <50657356.4010801@antcom.de>
Date: Fri, 28 Sep 2012 11:52:22 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, w.sang@pengutronix.de,
        jbe@pengutronix.de, Bill Gatliff <bgat@billgatliff.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [PATCH RFC 1/2] gpio: Add a block GPIO API to gpiolib
References: <1348780923-27428-1-git-send-email-stigge@antcom.de> <CACRpkdZ+1ffsMDRZXYb5RRndoXstj_QHvHOpeikRY0bas72dKQ@mail.gmail.com>
In-Reply-To: <CACRpkdZ+1ffsMDRZXYb5RRndoXstj_QHvHOpeikRY0bas72dKQ@mail.gmail.com>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2012 11:14 AM, Linus Walleij wrote:
>> @@ -686,6 +731,13 @@ read-only attributes:
>>
>>         "ngpio" ... how many GPIOs this manges (N to N + ngpio - 1)
>>
>> +       "block" ... get/set Block GPIO:
>> +                   * reads: space separated list of GPIO inputs of this chip that
>> +                     are set to 1, e.g. "83 85 87 99"
>> +                   * write: space separated list of GPIO outputs of this chip
>> +                     that are to be set or cleared, e.g. "80 -83 -85" (prefix
>> +                     "-" clears)
> 
> This sort of breaks the sysfs convention of one value per file,
> does it not?
> 
> It's not like I have some better idea, just we need to think about
> other possible solutions.
> 
> The GPIO sysfs interface is not universally liked. What are the
> typical applications you have for this? Industrial control by
> bit-banging userspace processes?

Yes, I had several projects in the past with the need of setting groups
of GPIOs at once (typically, 8 bit busses via GPIO lines), so needed to
provide some hacks. Don't want to do this over and over again. :-)

Bit-banging in kernel and userspace.

It's hard to do the one-value-per-file right for a several-gpios-at-once
goal. :-) I originally had a one-value solution: A bit map, continuously
hex coded, like in the original kernel API idea (e.g. 0x000F0A0010).
Wasn't sure because it encodes GPIO numbers in a weird way.

Strictly formally: Isn't a comma-separated list of a GPIO block (e.g.
"80,81,85") a singe value in a sense? :-) Or other possibilities? Maybe
some node in /proc? Or some kind of new character device node?

Otherwise, I need to think about leaving out the sysfs for this purpose.

Thanks in advance,

Roland
