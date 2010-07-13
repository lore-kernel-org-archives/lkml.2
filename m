Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717Ab0GMNpL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 09:45:11 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38238 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab0GMNpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 09:45:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=PYiY5lQy4YrAcReHKIa2XmM9PATI2LKh+VOwi+d0yjVnV1os/0+GI2jB9u5e5OXnMX
         KcXfm7FMJGvKUQrgKMWzdMliHS2iDac1Gc/kAH/OnKz2Ns9sli0eAmMgpxtZIVTHVETk
         8y/pgv+mHpZDvlI1jS5eR1yfFLtLsioa/Kz2w=
MIME-Version: 1.0
In-Reply-To: <4C3C52E2.1000801@ladisch.de>
References: <AANLkTimTN3FZjRAjFDV-3pSnwq9EEPzfs5-xXBH5KomO@mail.gmail.com>
	<4C3C52E2.1000801@ladisch.de>
Date: Tue, 13 Jul 2010 21:45:06 +0800
Message-ID: <AANLkTik2qIw7pFgsM8tnWmDZabO_BqPxFtYbh9h7Ohu_@mail.gmail.com>
Subject: Re: Question on HPET timer reading from device driver?
From: Samuel Xu <samuel.xu.tech@gmail.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Clemens!
Besides calling ioremap() on specific HPET address, is there more
elegant interface, "offically" for kernel mode driver accessing HPET?


2010/7/13 Clemens Ladisch <clemens@ladisch.de>:
> Samuel Xu wrote:
>> While I failed to find a way to get time stamp value of HPET in Linux
>> kenerl (I am doing a driver and want to know elapsed cycle from driver
>> code).
>
> The HPET is x86-specific any might not be available on every machine.
>
>> I tried hpet_readl() from my driver code, while hit compiling error.
>
> This function is intended for internal use by the kernel and not for
> drivers, so it is not exported for modules.
>
> You can hack your own accessor function by calling ioremap() on the HPET
> address (0xfed00000 or 0xfefff000 or whatever) and reading from that
> memory.
>
> A more portable way to get a time stamp is getrawmonotonic().
>
>> I also read the Linux Documentation of HPET, which contain a user mode
>> demo app to generate a periodic timer via HPET, while missing the time
>> stamp reading.
>
> There is no ioctl for this; call mmap() on /dev/hpet and then read the
> main counter value from offset 0xf0 of that memory.
>
> A more portable way to get a time stamp is to use clock_gettime() with
> CLOCK_MONOTONIC_RAW.
>
>
> Regards,
> Clemens
>
