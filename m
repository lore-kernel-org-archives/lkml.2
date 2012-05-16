Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613Ab2EPPrV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 11:47:21 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:43149 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755336Ab2EPPrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 11:47:19 -0400
MIME-Version: 1.0
In-Reply-To: <201205161209.03985.arnd@arndb.de>
References: <20120515154333.6659.66479.sendpatchset@w520>
	<20120516072927.GN7988@linux-sh.org>
	<CANqRtoSSEb9jwEmvbhBuyHp-9BfUSRabQzqjrrVGTFDP-AHutQ@mail.gmail.com>
	<201205161209.03985.arnd@arndb.de>
Date: Thu, 17 May 2012 00:47:17 +0900
Message-ID: <CANqRtoT5g7zttqp6Nw58O=Xvo+hPKsBhZGXW_UGutKVh2-SD9w@mail.gmail.com>
Subject: Re: [PATCH] gpio: Emma Mobile GPIO driver V2
From: Magnus Damm <magnus.damm@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
        rjw@sisk.pl, linus.walleij@stericsson.com, linux-sh@vger.kernel.org,
        horms@verge.net.au, grant.likely@secretlab.ca, olof@lixom.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 9:09 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 16 May 2012, Magnus Damm wrote:
>> > irq_domain_add_legacy() exists for existing static ranges, which there is
>> > really no reason to be adding in new board/platform support. You don't
>> > have to worry about virq overlap since irq_create_mapping() already wraps
>> > on top of irq_alloc_desc_xxx() for lookup.
>>
>> So I intentionally made use of the legacy domain in the non-DT case.
>> This because I want to let the SoC code set the static IRQ ranges via
>> platform data.
>
> I think it's generally better to use just one code path for both cases,
> if you need both DT and non-DT support, which means you would always
> use irq_domain_add_legacy. Once you have the final patch to convert it
> to DT, you can remove the legacy domain and just convert it to linear.

Sure, I don't mind that at all - it will make the DT bits even easier.

Thanks,

/ magnus
