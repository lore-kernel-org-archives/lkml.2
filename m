Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668Ab0JVKu4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 06:50:56 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:60010 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754160Ab0JVKuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 06:50:55 -0400
/m: 
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 7bit
Date: Fri, 22 Oct 2010 12:50:49 +0200
From: Richard Weinberger <richard@nod.at>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: <peterz@infradead.org>, <hpa@zytor.com>, <mingo@elte.hu>,
        <linux-kernel@vger.kernel.org>, <linux-next@vger.kernel.org>
Subject: Re: linux-next: User Mode Linux broken
In-Reply-To: <alpine.LFD.2.00.1010220900230.3467@localhost6.localdomain6>
References: <201010211315.26679.richard@nod.at>
 <201010212122.38437.richard@nod.at>
 <alpine.LFD.2.00.1010212143300.3467@localhost6.localdomain6>
 <201010212227.12919.richard@nod.at>
 <alpine.LFD.2.00.1010220900230.3467@localhost6.localdomain6>
Message-ID: <ed248baebfad9b050f53a6832435a9a5@radon2.swed.at>
User-Agent: RoundCube Webmail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Oct 2010 09:03:44 +0200 (CEST), Thomas Gleixner
<tglx@linutronix.de> wrote:
> On Thu, 21 Oct 2010, Richard Weinberger wrote:
>> Am Donnerstag 21 Oktober 2010, 21:45:35 schrieb Thomas Gleixner:
>> > Why shold it solve it ? irq_enable is set to compat_irq_enable which
>> > in turn calls chip->enable.
>> >
>> > So how's that different ?
>>
>> I took a closer look on the issue.
>>
>> check_irq_resend() gets called before irq_chip_set_defaults().
>> In the first call to check_irq_resend() desc->irq_data.chip->irq_enable is
>> NULL. UML dies due to a NULL-pointer dereference...
>>
>> I don't know why check_irq_resend() is called before irq_chip_set_defaults().
>> It's your code. ;-)
> 
> Well, but it only gets called via enable_irq(). So that means
> something is calling enable_irq _before_ request/setup_irq().
> 
> arch/um/kernel/irq.c:init_IRQ() does that :)

Sorry I'm not very familiar with the IRQ stuff.
Does that mean init_IRQ() is not allowed to call enable_irq()?

Thanks,
//richard

> Thanks,
> 
> 	tglx

