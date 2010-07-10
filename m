Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614Ab0GJOwK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 10:52:10 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60686 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab0GJOwH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 10:52:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=haEB0yMGg7Ayi3tg+nLmMR6WSgLzfKiu4OfASwFbYR1IjMW6eextoVENyuPySKdNSB
         YUqK9gLgMe3XxxJ+SXJcQ3iGXi8ES+Af2XwaL8s4HaqZhWFzvLqQ4AUtDKIyasCE9ZWJ
         +QhmgBGRoQh45FfWWK7y2Kslw/zLHi8vowbB0=
MIME-Version: 1.0
In-Reply-To: <AANLkTilQ0w6EfbrXl5LklPJ46FMWQG6Q3W5twJY74RtE@mail.gmail.com>
References: <AANLkTilPtW_hOG01qvQHBWMC4b0QJZ8SAL0bZi6j56ns@mail.gmail.com>
	<AANLkTilQ0w6EfbrXl5LklPJ46FMWQG6Q3W5twJY74RtE@mail.gmail.com>
Date: Sat, 10 Jul 2010 15:52:04 +0100
Message-ID: <AANLkTinLjhLoQJ8URiuCKqgntiLEKxCesNEPZ8b24uLu@mail.gmail.com>
Subject: Re: [2.6.35-rc3] select useful number of entries for DMA debugging...
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 July 2010 22:33, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Mon, Jul 5, 2010 at 1:35 AM, Daniel J Blueman
> <daniel.blueman@gmail.com> wrote:
>> When booting 2.6.35-rc3 on some different x86 boxes with DMA debugging
>> enabled, I've consistently seen it exhaust the allocated entries during
>> boot, giving 'DMA-API: debugging out of memory - disabling'.
>>
>> Increase number of entries to allow DMA debugging again.
>
> Rather than increase the default that gets allocated whenever anybody
> enables the DMA debugging, I'd really prefer to see people use the
> kernel command line option if they run out. After all, it's a (pretty
> esoteric) debug option, and the number of required entries depends on
> machine configuration. I'd rather not make the default cover a huge
> number, when you could just add
>
>   dma_debug_entries=65536
>
> on the kernel boot command line instead for machines that want/need it..

That said, I am seeing the DMA pool exhaust on a single socket Core i5
system with Intel graphics and no other adapters - seems like a fairly
common case. If eg 25% of developers will be using similar to this,
maybe it's good to make DMA debugging less immediately esoteric?

On the other hand, I would immediately agree if the exhaustion
occurred on an atypical setup.
-- 
Daniel J Blueman
