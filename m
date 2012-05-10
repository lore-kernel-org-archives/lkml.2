Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759385Ab2EJMMx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 08:12:53 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:36392 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756730Ab2EJMMv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 08:12:51 -0400
MIME-Version: 1.0
In-Reply-To: <20120510090910.GD3908@opensource.wolfsonmicro.com>
References: <20120510143329.4cef3cd78ce5ea55416b1d93@canb.auug.org.au>
	<CACRpkdYsHXnWHvBw6Pt1atvwKP6KYjfu-PwQnL_L7-yW1-4_FA@mail.gmail.com>
	<20120510090910.GD3908@opensource.wolfsonmicro.com>
Date: Thu, 10 May 2012 14:12:51 +0200
Message-ID: <CACRpkdbc3dWpTvsojUvjCitdBMJ6F9U+uhSoJLt3-zFc=azhxw@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the sound-asoc tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Ola Lilja <ola.o.lilja@stericsson.com>, Liam Girdwood <lrg@ti.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 11:09 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Thu, May 10, 2012 at 10:30:50AM +0200, Linus Walleij wrote:
>
>>  menuconfig SND_SOC_UX500
>>         tristate "SoC Audio support for Ux500 platform"
>>         depends on SND_SOC
>> +       depends on MFD_DB8500_PRCMU
>>         help
>>                 Say Y if you want to enable ASoC-support for
>>                 any of the Ux500 platforms (e.g. U8500).
>
> I applied this (without your signoff as you didn't supply one so it'll
> show up as my patch,

Sorry, Acked-by :-)

>> But it seems it has a wider dependency on some MOP500 board
>> stuff being merged first, which is more of a problem I think, part
>> of that is pending in the Ux500 tree.
>
> If this has a dependency on a particular board the driver is badly
> broken, this is the driver for the SoC I2S controller so it should work
> with any board.
>
> That said in terms of applying the change the arch/arm stuff shouldn't
> be an issue - it was just registering devices and clocks.  The driver
> won't load until the two trees are merged but that's not an issue, it's
> not going to run anyway if we delay applying it.

Yeah let's see if it works, if it breaks again we can just pull it out
and defer it.

Yours,
Linus Walleij
