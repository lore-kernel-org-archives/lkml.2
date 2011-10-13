Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489Ab1JMCu0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 22:50:26 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36520 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408Ab1JMCuZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 22:50:25 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1110121036170.3240@ionos>
References: <1318403810-21860-1-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
 <alpine.LFD.2.02.1110121036170.3240@ionos>
From: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Date: Thu, 13 Oct 2011 11:50:04 +0900
X-Google-Sender-Auth: 5lJQnICZ1FfjUWEBUPwzCHR8rLQ
Message-ID: <CABMQnVKNraRny5hWbX+fYkPk7DTBjxBqf4_T-tLp7MuEuS2SsQ@mail.gmail.com>
Subject: Re: [PATCH] irq: Add EXPORT_SYMBOL to function of irq generic-chip
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/12 Thomas Gleixner <tglx@linutronix.de>:
> On Wed, 12 Oct 2011, Nobuhiro Iwamatsu wrote:
>
>> Although some functions of of irq generic-chip can be used,
>> since EXPORT_SYMBOL is not specified, it cannot use.
>
> This does not make sense. In which context they can't be used?
>

Yes, this is mistake. Correctly, it is undefined error.

-----
ERROR: "irq_setup_generic_chip" [drivers/gpio/gpio-pch.ko] undefined!
ERROR: "irq_alloc_generic_chip" [drivers/gpio/gpio-pch.ko] undefined!
ERROR: "irq_setup_generic_chip" [drivers/gpio/gpio-ml-ioh.ko] undefined!
ERROR: "irq_alloc_generic_chip" [drivers/gpio/gpio-ml-ioh.ko] undefined!
-----

>> This is revised that EXPORT_SYMBOL can be added and referred
>> to in functions.
>
> EXPORT_SYMBOL_GPL if at all please.
>

Sure.

> And I'd rather avoid the exports, except those
>
>> +EXPORT_SYMBOL(irq_alloc_generic_chip);
>> +EXPORT_SYMBOL(irq_setup_generic_chip);
>> +EXPORT_SYMBOL(irq_setup_alt_chip);
>> +EXPORT_SYMBOL(irq_remove_generic_chip);
>
> which are really necessary. To gain access to the various helper
> functions we're better off to create a data structure with function
> pointers.
>
> struct irq_gc_functions {
>       void (* irq_gc_noop)(...);
>       ...
> };
>
> Instantiate this structure in kernel/irq/generic-chip.c, statically
> initialize it with pointers to those helper functions and export that
> data structure. That's way more efficient than having the overhead of
> the symbol export for each of the functions.
>

OK,  I will send the patch to which this function was added.

Thanks for your comments.

Best regards,
  Nobuhiro

-- 
Nobuhiro Iwamatsu
