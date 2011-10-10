Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab1JJRXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 13:23:17 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:47616 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab1JJRXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 13:23:16 -0400
Message-ID: <4E9329BC.8030704@linux.vnet.ibm.com>
Date: Mon, 10 Oct 2011 13:22:04 -0400
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.11
MIME-Version: 1.0
To: =?UTF-8?B?QXJrYWRpdXN6IE1pxZtraWV3aWN6?= <a.miskiewicz@gmail.com>
CC: Rajiv Andrade <srajiv@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net,
        Debora Velarde <debora@linux.vnet.ibm.com>,
        Marcel Selhorst <m.selhorst@sirrix.com>
Subject: Re: Linux 3.1-rc9
References: <CA+55aFxPNszU5UHFrDDYnshLEMupaviFwhgEsgmPkqpmuWNZ8A@mail.gmail.com> <4E925873.2020501@linux.vnet.ibm.com> <4E931BF6.6070706@linux.vnet.ibm.com> <201110101905.52769.a.miskiewicz@gmail.com>
In-Reply-To: <201110101905.52769.a.miskiewicz@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
x-cbid: 11101017-7282-0000-0000-0000025161DB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2011 01:05 PM, Arkadiusz Miśkiewicz wrote:
> On Monday 10 of October 2011, Rajiv Andrade wrote:
>> On 09/10/11 23:29, Stefan Berger wrote:
>>> On 10/09/2011 04:51 PM, Arkadiusz Miśkiewicz wrote:
>>>> On Wednesday 05 of October 2011, Linus Torvalds wrote:
>>>>> Another week, another -rc.
>>>> suspend to ram regression is annoying (still visible on rc9;
>>>> https://lkml.org/lkml/2011/9/24/76) but unfortunately maintainers are
>>>> silent.
>>> I tried -rc9 on my Lenovo W500 with that same TPM. I cannot reproduce
>>> the 'scheduling while atomic' problem you had reported earlier. I also
>>> could suspend / resume fine as long as I did the following:
>>>
>>> - suspended with the tpm_tis driver as module in the kernel
>>> - once a suspend was done without the tpm_tis driver the subsequent
>>> suspends were all done without the tpm_tis driver
>>>
>>> Once I had done a suspend/resume with the tpm_tis driver *not* in the
>>> kernel and then again a suspend with the tpm_tis driver in the kernel,
>>> it did not resume anymore. I believe previously (previous version of
>>> kernel and/or Fedora) it refused to even suspend. The reason why this
>>> doesn't work properly is that the driver has to send a command to the
>>> TPM upon suspend and the BIOS then sends the corresponding wakeup
>>> command.
>>>
>>> Did you maybe previously suspend/resume without a tpm_tis driver and
>>> then try to suspend with it ?
>>>
>>> Also, my Lenovo W500 shows particularly odd behavior when I switch
>>> from Windows to Linux. The first suspend with a Linux booted after
>>> Windows (with or without tpm_tis driver) does *not* resume (reboot
>>> required). A subsequently rebooted Linux makes the suspend/resume work
>>> fine.
>>>
>>>     Stefan
>> Arkadiusz,
>>
>> Do you still see the issue with this patch [1][2] applied?
> The issue doesn't happen with this patch but error condition with "Could not
> read PCR 0. TPM is not working correctly." is triggered immediately at boot,
> even before suspend is used.
>
> $ dmesg|grep -iE "(tpm|suspend)"
> [   12.640039] tpm_tis 00:0a: 1.2 TPM (device-id 0x1020, rev-id 6)
> [   12.640048] tpm_tis 00:0a: Intel iTPM workaround enabled
> [   12.768057] tpm_tis 00:0a: Could not read PCR 0. TPM is not working
> correctly.
> [   12.768066] tpm_tis 00:0a: Was machine previously suspended without TPM
> driver present?
> [   88.512117] Suspending console(s) (use no_console_suspend to debug)
>
Though I suppose that now your suspend/resume cycles always work?
I guess the BIOS seems not to be initializing the TPM correctly. Any 
chance you can get a hold of a BIOS update for your machine?

    Stefan

