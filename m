Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab1E2MCA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 08:02:00 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54760 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177Ab1E2MB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 08:01:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=QOc5xxtl0zx992cPdm/qv2GgoZtdejHRzQXk0Tky3HC0SoGvNnHdabL04op/PIUYkV
         3A6h1J3GDHS3aFJGh+M7eibuH+DJhGXdD6mMh++qapLMCRekdLWd+CPBBVuZ/v9wGbE0
         0gEWAkUcOiqa8f4KbWRURcjFrs5TpkQ8Jp89U=
MIME-Version: 1.0
In-Reply-To: <20110529102659.GY24876@n2100.arm.linux.org.uk>
References: <1306407759.27474.207.camel@e102391-lin.cambridge.arm.com>
	<1306409575.1200.71.camel@twins>
	<1306412511.1200.90.camel@twins>
	<20110526122623.GA11875@elte.hu>
	<20110526123137.GG24876@n2100.arm.linux.org.uk>
	<20110526125007.GA27083@elte.hu>
	<BANLkTinUZ7EwN_nBCi_RQ9u8-LBcr_A74g@mail.gmail.com>
	<20110527120629.GA32617@elte.hu>
	<20110527205240.GT24876@n2100.arm.linux.org.uk>
	<20110529102119.GC9489@e102109-lin.cambridge.arm.com>
	<20110529102659.GY24876@n2100.arm.linux.org.uk>
Date: Sun, 29 May 2011 13:01:58 +0100
X-Google-Sender-Auth: Ok-Y3rNn1mMts6g_fcfnnLmg6aE
Message-ID: <BANLkTin-5+jE6U-3RrPjPiFVRMGNhvwVEw@mail.gmail.com>
Subject: Re: [BUG] "sched: Remove rq->lock from the first half of ttwu()"
 locks up on ARM
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Frank Rowand <frank.rowand@am.sony.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yong Zhang <yong.zhang0@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 29 May 2011, Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> On Sun, May 29, 2011 at 11:21:19AM +0100, Catalin Marinas wrote:
>> To avoid extra per-thread flags, we could set a per-cpu variable in
>> switch_mm() so that we know what to switch the page tables to in the
>> post-switch hook.
>
> Why do we need to add more per-cpu stuff when we already have easy access
> to the thread flags?

It could work, I was thinking that we only get an mm structure in the
post-switch hook.

BTW, we currently have a per-cpu current_mm variable in context.c
because switch_mm() is called before switch_to() and the CPU may
receive an IPI to reset the ASID in this interval. But we can remove
it entirely if we set the ASID in the post-switch hook and run the
main switch code with interrupts disabled.


-- 
Catalin
