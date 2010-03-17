Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab0CQOtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 10:49:19 -0400
Received: from mail-bw0-f212.google.com ([209.85.218.212]:36974 "EHLO
	mail-bw0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab0CQOtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 10:49:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=rloOdYM4trLsAkCNe7+kw2xvyyO4u/aZeD3bJygr38PPsqgu+kbE7SRPc7c0MxRWeo
         MUfDn0E3Q4Djq9o7Eh4J0atd3VitBgARKFu7VSa5/RCujQg0mb9VH21j71mW+4DINifJ
         uHtyI2LVl3fOpKwN7Jl4Vxm973oKlMsVQqSmk=
MIME-Version: 1.0
In-Reply-To: <b637ec0b1003130450n3293ee78wc58e08a9bbcefe17@mail.gmail.com>
References: <b637ec0b1003111328u5c1d7d7fw6c76c409740827c7@mail.gmail.com>
	 <71cd59b01003120049n1a9fbbf3qfd37f14f241a7f64@mail.gmail.com>
	 <b637ec0b1003121207g5d29ddb4k338f1768ed1c2759@mail.gmail.com>
	 <71cd59b01003130116h4265769v9e1dae95361629ce@mail.gmail.com>
	 <b637ec0b1003130450n3293ee78wc58e08a9bbcefe17@mail.gmail.com>
Date: Wed, 17 Mar 2010 14:49:13 +0000
Message-ID: <9b2b86521003170749t5008c5cbpc2064988b59f1507@mail.gmail.com>
Subject: Re: Possible bug in eeepc-laptop.c - EeePC 900
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Fabio Comolli <fabio.comolli@gmail.com>
Cc: Corentin Chary <corentin.chary@gmail.com>,
       ACPI mailing list <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/13/10, Fabio Comolli <fabio.comolli@gmail.com> wrote:
> Well, I'm confused.
>
> I rebooted with the "vanilla" eeepc-laptop.c and I'm sorry to say that
> the situation it's not like the one I described in the post I wrote 2
> days ago. Actually the situation with the patch reverted is the same I
> have with the patch applied.
>
> What I mean is that if I boot on AC power /proc/cpuinfo always reports
> 900MHz and 1800 bogomips. It I boot on battery /proc/cpuinfo always
> reports 630MHz and 1260 bogomips. Plugging / unplugging the AC does
> not change the situation. Only reboot does.
>
> But the cpufv interface does indeed seem to work, as glxgears and
> stellarium show the frame rate change accordingly to the powersave /
> performance selection.
>
> So my question is: what does really the cpufv interface do? Is it
> supposed to change the processor frequency?

Yes, writing to cpufv asks the BIOS to set the CPU speed.

> And if the answer to the latest question is affirmative, why
> /proc/cpuinfo seems to ignore it?

It's because eeepc-laptop doesn't register as a real cpufreq driver.
The BIOS doesn't tell us what frequency it switches to.  Theoretically
you could re-use the boot code, but I'm not sure how you would make it
co-operate with the cpufreq core.

Alan
