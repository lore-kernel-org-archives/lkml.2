Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab1AYNXp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 08:23:45 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59675 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629Ab1AYNXn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 08:23:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=BsbaTKWTQCcjTL5MTkjse1+Z5ogUb55D6CVHQnPd25J7YM77vIO2ZeCwsZxFmNavAC
         zGGZtfOoBdhdLuoQSTRaZ6sxoBvPu0g509R9m8a5hGLgiXxvfMRF447jnZnDFBAgKsum
         mF2AkLoL53GO9Qyqhbusdfzs7eQBx9lKmSZWA=
MIME-Version: 1.0
In-Reply-To: <AANLkTikLwTdV2B5Dyp_adCxgWcE-+Wb6uiN5MBfnA1_K@mail.gmail.com>
References: <4D2B4CE4.9080309@ahsoftware.de>
	<alpine.LFD.2.00.1101101722470.9794@xanadu.home>
	<4D2BFA08.5030104@ahsoftware.de>
	<AANLkTinR7ih2ZMRMbXmSvoh-rS3LVv+UCvd0rRH_ESzf@mail.gmail.com>
	<20110111155930.GH11039@n2100.arm.linux.org.uk>
	<4D2D1942.4050905@ahsoftware.de>
	<AANLkTimAFp7ORrJLw2d8-i5pK0MZGTyAN5kmRR37ky1v@mail.gmail.com>
	<alpine.LFD.2.00.1101121314470.25498@xanadu.home>
	<20110112184258.GH11039@n2100.arm.linux.org.uk>
	<alpine.LFD.2.00.1101121350350.25498@xanadu.home>
	<AANLkTikLwTdV2B5Dyp_adCxgWcE-+Wb6uiN5MBfnA1_K@mail.gmail.com>
Date: Tue, 25 Jan 2011 13:23:43 +0000
X-Google-Sender-Auth: PKGl14gaQvcRw37WgNEh-qX4Y8o
Message-ID: <AANLkTim3C7P=Wzd9w--yrCrXsq7JQLPQdLMkSv28xqDB@mail.gmail.com>
Subject: Re: ARM: relocation out of range (when loading a module)
From: Catalin Marinas <catalin.marinas@arm.com>
To: Sachin Verma <imschnvrm@gmail.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rabin Vincent <rabin@rab.in>, Alexander Holler <holler@ahsoftware.de>,
        Dave Martin <dave.martin@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 January 2011 08:44, Sachin Verma <imschnvrm@gmail.com> wrote:
> On Thu, Jan 13, 2011 at 12:25 AM, Nicolas Pitre
> <nicolas.pitre@linaro.org> wrote:
>> On Wed, 12 Jan 2011, Russell King - ARM Linux wrote:
>>
>>> Then came along the embedded initrd/initramfs idea which rather buggered
>>> the scheme when large initramfs are embedded into the image.
>>>
>>> As the overall feeling at the time was "don't use large initrds" it's
>>> something I've never really cared about - and I'm still of the opinion
>>> that 16MB of compressed initrd/initramfs is rather silly.
>>
>> It is... but we have more than 32MB of RAM total now, and people are
>> running standard distributions on ARM these days, such as Fedora or
>> Ubuntu, including their corresponding initrd that may contain lots of
>> modules, splashscreen data, etc.  So it might be a good idea to think
>> about fixing this limitation before it comes back again.
>>
>
> in fact it is not just the initrd/initramfs size, i am facing issues
> with loading modules on MMU-less envt(Cortex M3).
> I have 128MB of Physical RAM and i am using a 4MB initrd to boot my
> system. when i try to load kernel modules i get relocation errors.
> As MMU-less systems are allowing modules to be loaded anywhere from
> RAM and not from any predefined limits of MODULES_VADDR and
> MODULES_END.
>
> Do you have any pointers on how to tackle this situation for MMU less
> environments?

I don't think there is a simple solution. As a hack, you could define
DMA and Normal Zones in your system and force module allocations from
the DMA zone (which would be close to the kernel).

I'm not sure whether the kernel could be compile with a larger memory
model, but then you have to improve the kernel to handle new
relocation types.

-- 
Catalin
