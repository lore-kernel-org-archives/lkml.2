Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632Ab2GQSk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 14:40:57 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:53361 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632Ab2GQSkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 14:40:55 -0400
MIME-Version: 1.0
In-Reply-To: <CA+icZUW+Gp9HK-6dzHjtTwSc9RaLD3sV+WPMM-vO3A6fj6frwQ@mail.gmail.com>
References: <CA+icZUXjc+13YjoJ6FjDFboX20j3mqHNtvV2Av2-H0My8V2Mgg@mail.gmail.com>
	<CA+icZUW4gNqspcJ1sjBD-3GCVee2VWVV5NPAr6Eo-aZHjp3y+Q@mail.gmail.com>
	<CA+icZUW+Gp9HK-6dzHjtTwSc9RaLD3sV+WPMM-vO3A6fj6frwQ@mail.gmail.com>
Date: Tue, 17 Jul 2012 20:40:54 +0200
Message-ID: <CACRpkdbAnBza0Nd4Qw_LinRDa4XVuzUdJFX==YeML2z7H6gzwg@mail.gmail.com>
Subject: Re: linux-next: Tree for July 17 (mfd: AB3100 - ab3100_probe:
 undefined reference to `rand_initialize_irq')
From: Linus Walleij <linus.walleij@linaro.org>
To: sedat.dilek@gmail.com
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 12:39 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Tue, Jul 17, 2012 at 12:21 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> ...looks like AB3100 is the *only* driver still using rand_initialize_irq()...
>>
>> drivers/mfd/ab3100-core.c:939:  rand_initialize_irq(client->irq);
>>
>> ...but why has random.h still this...?
>>
>> include/linux/random.h:51:extern void rand_initialize_irq(int irq);
>>
>> Just thinking "loud"...
>>
>> - Sedat -
>
> Is this attached patch OK, Ted?

You're just deleting a line from the AB3100 driver, so I guess you're
regressing the system since that IRQ will no longer contribute
to the entropy pool?

How do we simultaneously make sure that this IRQ is still
contributing to the entropy?

Yours,
Linus Walleij
