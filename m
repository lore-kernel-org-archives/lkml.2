Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660Ab1JJQXb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 12:23:31 -0400
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:40066 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928Ab1JJQXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 12:23:30 -0400
Message-ID: <4E931BF6.6070706@linux.vnet.ibm.com>
Date: Mon, 10 Oct 2011 13:23:18 -0300
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
CC: =?UTF-8?B?QXJrYWRpdXN6IE1pxZtraWV3aWN6?= <a.miskiewicz@gmail.com>,
        linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net,
        Debora Velarde <debora@linux.vnet.ibm.com>,
        Marcel Selhorst <m.selhorst@sirrix.com>
Subject: Re: Linux 3.1-rc9
References: <CA+55aFxPNszU5UHFrDDYnshLEMupaviFwhgEsgmPkqpmuWNZ8A@mail.gmail.com> <201110092251.15618.a.miskiewicz@gmail.com> <4E925873.2020501@linux.vnet.ibm.com>
In-Reply-To: <4E925873.2020501@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
x-cbid: 11101016-8936-0000-0000-000004B71F27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/11 23:29, Stefan Berger wrote:
> On 10/09/2011 04:51 PM, Arkadiusz Miśkiewicz wrote:
>> On Wednesday 05 of October 2011, Linus Torvalds wrote:
>>> Another week, another -rc.
>> suspend to ram regression is annoying (still visible on rc9;
>> https://lkml.org/lkml/2011/9/24/76) but unfortunately maintainers are 
>> silent.
>>
> I tried -rc9 on my Lenovo W500 with that same TPM. I cannot reproduce 
> the 'scheduling while atomic' problem you had reported earlier. I also 
> could suspend / resume fine as long as I did the following:
>
> - suspended with the tpm_tis driver as module in the kernel
> - once a suspend was done without the tpm_tis driver the subsequent 
> suspends were all done without the tpm_tis driver
>
> Once I had done a suspend/resume with the tpm_tis driver *not* in the 
> kernel and then again a suspend with the tpm_tis driver in the kernel, 
> it did not resume anymore. I believe previously (previous version of 
> kernel and/or Fedora) it refused to even suspend. The reason why this 
> doesn't work properly is that the driver has to send a command to the 
> TPM upon suspend and the BIOS then sends the corresponding wakeup 
> command.
>
> Did you maybe previously suspend/resume without a tpm_tis driver and 
> then try to suspend with it ?
>
> Also, my Lenovo W500 shows particularly odd behavior when I switch 
> from Windows to Linux. The first suspend with a Linux booted after 
> Windows (with or without tpm_tis driver) does *not* resume (reboot 
> required). A subsequently rebooted Linux makes the suspend/resume work 
> fine.
>
>    Stefan
>
Arkadiusz,

Do you still see the issue with this patch [1][2] applied?

[1] - http://marc.info/?l=linux-kernel&m=131824905826280&w=2
[2] - github.com/srajiv/tpm.git for-james

Thanks,
Rajiv

