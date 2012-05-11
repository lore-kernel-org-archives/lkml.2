Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437Ab2EKGPR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 02:15:17 -0400
Received: from 50.23.254.54-static.reverse.softlayer.com ([50.23.254.54]:35532
	"EHLO softlayer.compulab.co.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757192Ab2EKGPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 02:15:11 -0400
Message-ID: <4FACAE68.2090004@compulab.co.il>
Date: Fri, 11 May 2012 09:15:04 +0300
From: Igor Grinberg <grinberg@compulab.co.il>
Organization: CompuLab Ltd.
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.3) Gecko/20120506 Thunderbird/10.0.3
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Wolfgang Denk <wd@denx.de>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@ardb.de>,
        Olof Johansson <olof@lixom.net>, linux-embedded@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: Re: Handling of modular boards
References: <20120504185850.GO14230@opensource.wolfsonmicro.com> <201205041934.08830.arnd@arndb.de> <20120504203357.6B79B206451@gemini.denx.de> <20120504220944.GT14230@opensource.wolfsonmicro.com> <4FABB758.7000702@compulab.co.il> <4FABE9BE.2010108@wwwdotorg.org>
In-Reply-To: <4FABE9BE.2010108@wwwdotorg.org>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/12 19:15, Stephen Warren wrote:
> On 05/10/2012 06:40 AM, Igor Grinberg wrote:
>> On 05/05/12 01:09, Mark Brown wrote:
>>> On Fri, May 04, 2012 at 10:33:57PM +0200, Wolfgang Denk wrote:
>>
>>>> On the other hand, some of the issues we're trying to solve
>>>> here for the kernel are also present in the boot loader, so
>>>> this needs to do this anyway - whether by inserting new or
>>>> modifying (enabling or disabling) existing properties in the DT
>>>> is not really relevant here.
>>
>>> FWIW if the bootloader can usefully handle this stuff I think
>>> that's a good approach but there is substantial variation in
>>> quality of implementation between bootloaders and even when the
>>> bootloader is a good one it's not always practical to update it
>>> or the data it relies on.
>>
>> I agree on this (and also with Ben), all our boards/extensions/base
>> boards/etc can be discovered in the boot loader and we will use the
>> DT to pass the relevant information on the attached extensions and
>> used base board.
>>
>> Also, most (if not all) of our boards/extensions have I2C EEPROM
>> which describes the devices on that board/extension which is useful
>> for building/extending the DT in the bootloader.
> 
> I believe that's true for all/many NVIDIA boards too.
> 
> But, duplicating all this in every bootloader might not make sense.

Yeah, I agree on this, especially when you have multiple bootloaders
for the same board...

On the other hand, that is a common problem of the open source
software - anyone can create a bootloader, publish and use it...

> Sure there are some cases where the bootloader needs this information
> (e.g. to load the kernel from an SD card that's on 1 of N plugin
> boards), but there may be much information the bootloader doesn't care
> about.
> 
> Would it make sense to write a DT-identifying-and-merging shim that
> can be executed by the bootloader, create the final DT, and then jump
> to the kernel?
> 
> Hmmm. That's probably a bad idea, since then it means needing e.g. I2C
> drivers to read the ID EEPROMs, pinmux drivers, ... in the shim.
> 
> Perhaps the common shim idea makes sense, but we need a standardized
> API it can use that all bootloaders provide for it to operate.

Let's see where we're heading:
We created/extended the DT to abstract all the SoC/board specific
(probably also undetectable) stuff away from the kernel and now we will
create a special shi(t)m that will interface the bootloader and create the DT?

I don't think it is a good idea, especially because you still need to change
the bootloader(s) and if you place the I2C/pinmux/gpio drivers inside that
shi(t)m, you duplicate the bootloader, no?

I think we should let the bootloader(s) create/extend the DT and if for some
reason a bootloader wants to separate the DT code into a shim, let it be so.

> 
> This is beginning to sound a lot like a UEFI byte code module (I
> assume; I know little about them)

That's another curse... probably we will not get away from it...

 

-- 
Regards,
Igor.
