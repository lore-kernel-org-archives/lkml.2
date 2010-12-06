Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab0LFSFv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 13:05:51 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:20420 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695Ab0LFSFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 13:05:50 -0500
Message-ID: <4CFD258B.4030604@oracle.com>
Date: Mon, 06 Dec 2010 10:03:55 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: trapdoor6@gmail.com, Michal Marek <mmarek@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        brueckner@linux.vnet.ibm.com, lacombar@gmail.com, mchehab@redhat.com,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] kbuild and kconfig fixes for 2.6.37-rc5
References: <20101204135732.GA12774@sepie.suse.cz>	<AANLkTimeyo==XJWUaUs8EzJvA8azkk3sw9FXQhMjuo6M@mail.gmail.com>	<20101205081108.9bdb7504.randy.dunlap@oracle.com>	<AANLkTimm1Xn4wwNAoDJ4hjnOmBOnxBgcsCzVEJTEag97@mail.gmail.com> <AANLkTimXRBz7-mz_E_xdc85pGi7ExMy67XfDVF7jEt+Y@mail.gmail.com>
In-Reply-To: <AANLkTimXRBz7-mz_E_xdc85pGi7ExMy67XfDVF7jEt+Y@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/10 10:01, Catalin Marinas wrote:
> On 5 December 2010 16:51, trapDoor <trapdoor6@gmail.com> wrote:
>> On Sun, Dec 5, 2010 at 4:11 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>>> On Sun, 5 Dec 2010 15:42:46 +0000 trapDoor wrote:
>>>
>>>> Hello,
>>>> I couldn't wait and I merged the changes into my copy of mainline
>>>> tree. The merge was successful, no conflicts and the merge-diffstat
>>>> was exactly the same as above. However, when  running oldconfig on the
>>>> patched kernel I still get lots of warnings:
>>>>
>>>> warning: (GPIO_RDC321X && PCI && GPIOLIB) selects MFD_RDC321X which
>>>> has unmet direct dependencies (MFD_SUPPORT && PCI)
>>>> warning: (I2C_ISCH && I2C && PCI || GPIO_SCH && GPIOLIB && PCI ||
>>>> GPIO_VX855 && GPIOLIB || GPIO_RDC321X && PCI && GPIOLIB ||
> [...]
>>>> MFD_JZ4740_ADC && MFD_SUPPORT && MACH_JZ4740 || MFD_TPS6586X &&
>>>> MFD_SUPPORT && I2C=y && GPIOLIB && GENERIC_HARDIRQS || MFD_VX855 &&
>>>> MFD_SUPPORT && PCI) selects MFD_CORE which has unmet direct
>>>> dependencies (MFD_SUPPORT)
>>>
>>> That's 2 warnings.  I have sent a patch for the first one.
>>> Looks like I need to resend it.
>>
>> I was actually impressed by the amount of lines produced by those two
>> warnings :) I'd call it 'a lot'.
> 
> This could be simplified to only show the first option of every '&&'
> expression, something like below:
> 
> warning: I2C_ISCH selects MFD_CORE...
> warning: GPIO_SCH selects MFD_CORE...
> 
> But I couldn't figure out whether the expression reduction code in
> kbuild reorders the options or not.

I'm pretty sure that I have seen cases where the faulty kconfig is not the
first one listed, so all of them need to be available.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
