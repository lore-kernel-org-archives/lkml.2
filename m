Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823Ab0KXH6B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 02:58:01 -0500
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:47269 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751580Ab0KXH6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 02:58:00 -0500
Message-ID: <4CECC555.8060408@stericsson.com>
Date: Wed, 24 Nov 2010 08:57:09 +0100
From: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100713 Lightning/1.0b1 Thunderbird/3.0.6
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Subject: Re: [PATCH 2/3] regulators: Update of ab8500 driver
References: <1290536754-21775-1-git-send-email-bengt.g.jonsson@stericsson.com> <1290536754-21775-3-git-send-email-bengt.g.jonsson@stericsson.com> <20101123183833.GB19212@rakim.wolfsonmicro.main>
In-Reply-To: <20101123183833.GB19212@rakim.wolfsonmicro.main>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-11-23 19:38, Mark Brown wrote:
> On Tue, Nov 23, 2010 at 07:25:53PM +0100, Bengt Jonsson wrote:
>> This patch updates the driver with some bug fixes, support
>> for v2 hardware, support for regulator_count_voltages,
>> changes for reading the board config, added indexing of
>> the regulator array and added debug prints.
>
> This is a whole series of changes which don't seem terribly related to
> each other and aren't clearly described - please split this out into a
> patch series which clearly shows each individual change.  For example,
> one change per bug fix, another adding v2 support, another adding count
> support and so on.  As things stand it's very difficult to review your
> patch as it's not clear what each change is supposed to be doing or that
> bits haven't been missed from changes.
I will do that.
>
>> -	ret = abx500_get_register_interruptible(info->dev, info->voltage_bank,
>> -		info->voltage_reg,&value);
>> +	ret = abx500_get_register_interruptible(info->dev,
>> +			info->voltage_bank, info->voltage_reg,&regval);
>
> In addition to what's noted above you also appear to have some renaming
> of variables and struct members plus some other stylistic changes which
> adds to the noise, again these should be split out for ease of review.
I will do that too.
>
>> +	[AB8500_REGULATOR_INTCORE] = {
>> +		.desc = {
>> +			.name		= "intcore",
>
> The previous way of listing the regulators with a macro seemed more
> immediately readable?
Removing the macros is just my suggestion. The disadvantage I see with 
macros is that I need to read both the macro and the listing to see what 
it really does. On the other hand, macros are probably more compact. If 
it is ok, I will break out a patch with this change and put it in the 
end of the patch stack. Then you can decide if you want it or not.
