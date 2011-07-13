Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834Ab1GMU5a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 16:57:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33784 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751501Ab1GMU53 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 16:57:29 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1107131640280.9546@x980>
References: <alpine.LFD.2.02.1103301819250.31342@x980> <20110414090854.GB9248@elte.hu>
 <alpine.LFD.2.02.1104150202310.29365@x980> <20110415101712.GB28007@elte.hu> <alpine.LFD.2.02.1107131640280.9546@x980>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 13 Jul 2011 13:49:06 -0700
Message-ID: <CA+55aFxBkgwBbnqwO7DuizsWiVcULYtPzqr-mYrT6aHmXV0zZw@mail.gmail.com>
Subject: Re: [PATCH] x86 intel power: Initialize MSR_IA32_ENERGY_PERF_BIAS
To: Len Brown <lenb@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ack. Let's just do this. Ingo?

            Linus

On Wed, Jul 13, 2011 at 1:44 PM, Len Brown <lenb@kernel.org> wrote:
>
>> So how about informing users, how about making it non-silent? An informative
>> printk that also mentions the power configuration tool, etc. This solves the
>> concerns i mentioned.
>
> Something like this?
>
>                rdmsrl(MSR_IA32_ENERGY_PERF_BIAS, epb);
>                if ((epb & 0xF) == 0) {
>                        printk_once(KERN_WARN, "x86: updated energy_perf_bias"
>                                " to 'normal' from 'performance'\n"
>                                "You can view and update epb via utility,"
>                                " such as x86_energy_perf_policy(8)\n");
>                        epb = (epb & ~0xF) | ENERGY_PERF_BIAS_NORMAL;
>                        wrmsrl(MSR_IA32_ENERGY_PERF_BIAS, epb);
>                }
>
>
