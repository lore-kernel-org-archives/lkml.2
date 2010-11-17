Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570Ab0KQKrp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 05:47:45 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51738 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065Ab0KQKro convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 05:47:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=qjH88YmowjnzvUBPXAHZlXxF0DzXbK5SeiU7StqdyL96sbGCDbprY2zBIIYTqFs52y
         fEZzIq081QOoyMc45XwRej94CrgVGWX82Aplxo3ZSNRNqQGsB6fL1/8MxDvA18V0rWny
         SgFPtp3MI7tFCTliDVuJMM8tKzPCO2JfrArVU=
MIME-Version: 1.0
In-Reply-To: <20101116193335.GD21926@n2100.arm.linux.org.uk>
References: <1289842829-3027-1-git-send-email-catalin.marinas@arm.com>
	<1289842829-3027-16-git-send-email-catalin.marinas@arm.com>
	<4CE2D811.50701@codeaurora.org>
	<20101116193335.GD21926@n2100.arm.linux.org.uk>
Date: Wed, 17 Nov 2010 10:47:43 +0000
X-Google-Sender-Auth: O2olmY_M1FZmD0Y30PP3zN0D7hU
Message-ID: <AANLkTinDGk2HPg7py9nzsqmM3_AbSG_GJJYwsiMr+wQL@mail.gmail.com>
Subject: Re: [PATCH v3 15/20] ARM: LPAE: use phys_addr_t instead of unsigned
 long for physical addresses
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Stephen Boyd <sboyd@codeaurora.org>, Will Deacon <will.deacon@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 November 2010 19:33, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Tue, Nov 16, 2010 at 11:14:25AM -0800, Stephen Boyd wrote:
>> On 11/15/2010 09:40 AM, Catalin Marinas wrote:
>> > @@ -188,21 +189,21 @@
>> >   * translation for translating DMA addresses.  Use the driver
>> >   * DMA support - see dma-mapping.h.
>> >   */
>> > -static inline unsigned long virt_to_phys(void *x)
>> > +static inline phys_addr_t virt_to_phys(void *x)
>> >  {
>> >     return __virt_to_phys((unsigned long)(x));
>> >  }
>>
>> As you're already in the area can you mark the argument to
>> virt_to_phys() as const? I ran into a compiler warning due to that the
>> other day.
>
> It may make sense to mark it const volatile, as that's the most
> permissive set of attributes possible (iow, it'll accept any pointer
> without warning.)  However, might be an idea to check what other
> arches do.

The majority of architectures use volatile and a few add both const
and volatile.

I usually use the generic headers as reference for function prototypes
and that's just using volatile without a const (cc'ing Arnd for any
view on this).

-- 
Catalin
