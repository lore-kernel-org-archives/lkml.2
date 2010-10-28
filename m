Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759334Ab0J1QKV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 12:10:21 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53146 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756140Ab0J1QKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 12:10:17 -0400
Message-ID: <4CC9A03F.80401@ti.com>
Date: Thu, 28 Oct 2010 12:09:35 -0400
From: Cyril Chemparathy <cyril@ti.com>
Reply-To: cyril@ti.com
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.14) Gecko/20101006 Lightning/1.0b1 Thunderbird/3.0.9
MIME-Version: 1.0
To: Linus Walleij <linus.ml.walleij@gmail.com>
CC: "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "dbrownell@users.sourceforge.net" <dbrownell@users.sourceforge.net>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v4 01/12] misc: add driver for sequencer serial port
References: <1288124308-14999-1-git-send-email-cyril@ti.com>	<1288124308-14999-2-git-send-email-cyril@ti.com> <AANLkTi=rDep3jkp2QAjVsgjZ7JQ0ysnse4TARv29fyHm@mail.gmail.com>
In-Reply-To: <AANLkTi=rDep3jkp2QAjVsgjZ7JQ0ysnse4TARv29fyHm@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2010 11:49 AM, Linus Walleij wrote:
> 2010/10/26 Cyril Chemparathy <cyril@ti.com>:
> 
>> TI's sequencer serial port (TI-SSP) is a jack-of-all-trades type of serial port
>> device.  It has a built-in programmable execution engine that can be programmed
>> to operate as almost any serial bus (I2C, SPI, EasyScale, and others).
>>
>> This patch adds a driver for this controller device.  The driver does not
>> expose a user-land interface.  Protocol drivers built on top of this layer are
>> expected to remain in-kernel.
> 
> Why is this thing in drivers/misc?
> 
> drivers/mfd is IMHO the apropriate place for a driver like this, and
> the subdrivers should be migrated to use mfd cells and platform
> drivers for the subdevices.
> 
> All functions and abstractions you create here look suspiciously
> lot like other MFD devices.
> 
> But please, beat me up if I'm wrong!

Alan had raised the same concern earlier, and my response was:

> Unlike MFDs, this device doesn't have cells with differing
> functionality.  Instead it has functionally identical ports that can
> operate in a variety of modes.  That said, does this still fit in with
> other MFD drivers?  If so, I don't see a problem with moving it there.

I don't see a problem with moving this into MFD, but this won't be able
to use any of the functionality provided by mfd-core.

Thanks
Cyril.
