Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241Ab0E0Nls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 09:41:48 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50203 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247Ab0E0Nlp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 09:41:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=W+qgVB784ote7hDibokAsCfiErd7mQSEpQA+oyxevG+tb3SZ5r3K2f/TtF4Q5PbIsf
         A054T+3C6cPUPa3lxotUUcF4O8K3uSzbPV6URSZjtuM0i7SreMXna2DMNbsDF7UcXRO1
         USMRMKBFTYVfxgNYkONEoM8j9rOhfAIAOjFPQ=
MIME-Version: 1.0
In-Reply-To: <4BFE73DF.5090107@tilera.com>
References: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com>
	<201005252345.15685.arnd@arndb.de>
	<4BFDC3D1.40708@tilera.com>
	<201005271041.30519.arnd@arndb.de>
	<4BFE73DF.5090107@tilera.com>
Date: Thu, 27 May 2010 15:41:44 +0200
X-Google-Sender-Auth: Bp4NkKOUW4b04Lhyp9w8H9Qg4Bw
Message-ID: <AANLkTinTjpx6GTRidb6mzJ7At2tDlm6VeKW5dBGZZQcc@mail.gmail.com>
Subject: Re: [PATCH] arch/tile: new multi-core architecture for Linux
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-arch@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 15:30, Chris Metcalf <cmetcalf@tilera.com> wrote:
> On 5/27/2010 4:41 AM, Arnd Bergmann wrote:
>> On Thursday 27 May 2010, Chris Metcalf wrote:
>>>> +EXPORT_SYMBOL(inb);
>>>>
>>>> If you just remove these definitions, you get a link error for any
>>>> driver that tries to use these, which is probably more helpful than
>>>> the panic.
>>>>
>>>> OTOH, are you sure that you can't just map the PIO calls to mmio functions
>>>> like readb plus some fixed offset? On most non-x86 architectures, the PIO
>>>> area of the PCI bus is just mapped to a memory range somewhere.
>>>>
>>>>
>>> I'll try to remove them and see if anything falls over.  We don't have
>>> any memory-mapped addresses in the 32-bit architecture, though that
>>> changes with the 64-bit architecture, which introduces IO mappings.  For
>>> PCI we actually have to do a hypervisor transaction for reads or writes.
>>>
>> Ok, then I assume that PIO would also be a hypervisor call, right?
>> If you don't have MMIO on 32 bit, you might want to not define either
>> PIO (inb, ...) no MMIO (readb, ...) calls there and disable
>> CONFIG_HAVE_MMIO in Kconfig.
>>
>
> We don't define CONFIG_HAVE_MMIO, but drivers certainly seem to use
> ioread/iowrite methods as well as inb/outb without guarding them with
> any particular tests, so we have to provide definitions of some kind for
> all of them.  I'll confer with our PCI developer to see if we can clean
> up the set of definitions in io.h.

It's CONFIG_NO_IOMEM (cfr. s390 and um), which is inverted and turned into
CONFIG_HAS_IOMEM, to be checked by drivers.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
