Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990Ab2HHLvy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 07:51:54 -0400
Received: from www.linutronix.de ([62.245.132.108]:57999 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757505Ab2HHLvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 07:51:52 -0400
Message-ID: <502252C8.3090600@linutronix.de>
Date: Wed, 08 Aug 2012 13:51:36 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Grant Likely <grant.likely@secretlab.ca>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/dt: use linear irq domain for ioapic(s).
References: <1343890270-13007-1-git-send-email-thierry.reding@avionic-design.de> <20120806073811.GA3261@breakpoint.cc> <20120808104629.GA20296@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20120808104629.GA20296@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2012 12:46 PM, Thierry Reding wrote:
>> +	id = irq_domain_add_linear(np, num,
>> +			&ioapic_irq_domain_ops,
>> +			(void *)ioapic_num);
>
> This fits on two lines instead of three.

k

>> +				pr_err("Error creating mapping for the "
>> +						"remaining  irqs: %d\n", ret);
>
> There's an extra space between "remaining" and "irqs". Also other places
> use the spelling IRQ and IRQs respectively in strings, so it may be nice
> to stay consistent.

I see.

> Besides the above nitpicks:
>
> Reviewed-by: Thierry Reding<thierry.reding@avionic-design.de>
> Tested-by: Thierry Reding<thierry.reding@avionic-design.de>

Thanks for testing.

> On another note, I saw that you've used the "intel,ce4100" prefix in
> various places and I wonder if it would be useful to replace them with
> something more generic like "intel,hpet", "intel,lapic" and
> "intel,ioapic" respectively. The hardware that I use is based on an Atom
> N450 and works with the current code, so it really isn't ce4100-
> specific.

No. You do have a compatible entry. It first appeared on the ce4100
CPU. If it happens to also work on the n450 then it seems to be
compatible with that one. "This" is documented somewhere…
Usually you add 'compatible = "your cpu", "generic binding"' in case
you need a fixup / errata whatever for "your cpu". Even if you compare
all hpets from Intel there is the one or other difference / errata.

> Thierry

Sebastian
