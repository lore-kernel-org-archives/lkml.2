Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab1KXWNK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 17:13:10 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44745 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab1KXWNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 17:13:09 -0500
Message-ID: <4ECEC16E.5080806@gmail.com>
Date: Fri, 25 Nov 2011 09:13:02 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Lightning/1.0b2 Thunderbird/3.1.15
MIME-Version: 1.0
To: "Voss, Nikolaus" <N.Voss@weinmann.de>
CC: "'Ben Dooks'" <ben-i2c@fluff.org>,
        "'linux-i2c@vger.kernel.org'" <linux-i2c@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'ben-linux@fluff.org'" <ben-linux@fluff.org>,
        "'carsten.behling@garz-fricke.com'" <carsten.behling@garz-fricke.com>
Subject: Re: [PATCH v7 0/5] AT91: replace broken TWI driver i2c-at91.c
References: <cover.1322062555.git.n.voss@weinmann.de> <20111123233238.GL19115@trinity.fluff.org> <EF2E73589CA71846A15D0B2CDF79505D087B44FD63@wm021.weinmann.com>
In-Reply-To: <EF2E73589CA71846A15D0B2CDF79505D087B44FD63@wm021.weinmann.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/11/11 17:33, Voss, Nikolaus wrote:

> Hi,
> 
> Ben Dooks wrote on 2011-11-24:
>> On Wed, Nov 23, 2011 at 04:35:55PM +0100, Nikolaus Voss wrote:
>>> The old driver has two main deficencies:
>>> i)  No repeated start (Sr) condiction is possible, this makes it unusable
>>>     e.g. for most SMBus transfers.
>>> ii) I/O was done with polling/busy waiting what caused over-/underruns
>>>     even at light system loads and clock speeds.
>>>
>>> The new driver overcomes these deficencies and in addition allows for
>>> more than one TWI interface.
>>>
>>> A remaining limitation is the fact, that only one repeated start is
>>> possible (two concatenated messages). This limitation is imposed by
>>> the hardware. However, this should not be a problem as all common
>>> i2c-client communication does not rely on more than one repeated start.
>>>
>>> v7: Patch 4/5: i)  fix bug if internal address > 1 byte
>>>                ii) send stop when len == 1
>>>                    (both reported by Carsten Behling)
>>> v6: Patch 5/5: support for I2C_SMBUS_BLOCK_DATA transfers.
>>>     Better use of clk_(un)prepare().
>>>     More sensible transfer timeout.
>>> v5: Another round of review comments from Ryan Mallon, Felipe Balbi
>>>     and Russell King: convert twi clk to use .dev_id, cleanups
>>> v4: Integrated more review comments from Ryan Mallon and Felipe Balbi:
>>>     Moved register include file to local include, code cleanups
>>> v3: Integrated review comments from Ryan Mallon and Felipe Balbi
>>> v2: Fixed whitespace issue
>>>
>>> Nikolaus Voss (5):
>>>   drivers/i2c/busses/i2c-at91.c: remove broken driver
>>>   Replace clk_lookup.con_id with clk_lookup.dev_id entries for twi clk
>>>   drivers/i2c/busses/i2c-at91.c: add new driver
>>>   G45 TWI: remove open drain setting for twi function gpios
>>>   i2c-at91.c: add SMBUS_READ_BLOCK_DATA functionality
>>
>> Is the original driver so broken that the two could not co-exist, or are
>> we making so many changes that there's no point in keeping the original
>> one?
> 
> The old driver was marked as broken for the above reasons and I can hardly
> imagine any setup in which it would be preferable to i2c-gpio. So it does
> not make any sense to keep the old driver alive. Though inspired by the old
> driver, the new one is almost a rewrite from scratch, so for better reviewing,
> I removed the old instead of doing a diff.


I can confirm this. I worked on a number of AT91 based platforms with
several different i2c client devices and we always had to use the
i2c-gpio driver because the at91-i2c driver would not reliably work with
our client devices.

None of the at91 defconfigs select I2C_AT91, so it should be fairly safe
to remove the old driver. Getting this driver into linux-next (if it
isn't already) would be good so we can see if it does cause problems for
anybody.

Thanks,
~Ryan




