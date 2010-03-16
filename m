Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937473Ab0CPGyX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 02:54:23 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:63037 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937447Ab0CPGyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 02:54:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ijCNW+A4JmakYfaXtkRL5tjLo+zhtUvN+y6l/SqpVy+2JUZ/PjlFf36xjIrljTd/sD
         DjLJEin7j5dvu8Mg9O2IxvHKARhswIk0K/rQv8pbjUT+DpUxrQ7EeLx1IDI9r2MHkypI
         YXRBqmuyqvZ4HqqODbaBCtg/17QL5lGrBVUFg=
MIME-Version: 1.0
In-Reply-To: <b637ec0b1003130450n3293ee78wc58e08a9bbcefe17@mail.gmail.com>
References: <b637ec0b1003111328u5c1d7d7fw6c76c409740827c7@mail.gmail.com>
	 <71cd59b01003120049n1a9fbbf3qfd37f14f241a7f64@mail.gmail.com>
	 <b637ec0b1003121207g5d29ddb4k338f1768ed1c2759@mail.gmail.com>
	 <71cd59b01003130116h4265769v9e1dae95361629ce@mail.gmail.com>
	 <b637ec0b1003130450n3293ee78wc58e08a9bbcefe17@mail.gmail.com>
Date: Tue, 16 Mar 2010 07:54:17 +0100
Message-ID: <71cd59b01003152354h64d18c0fq2083f60e399313c8@mail.gmail.com>
Subject: Re: Possible bug in eeepc-laptop.c - EeePC 900
From: Corentin Chary <corentin.chary@gmail.com>
To: Fabio Comolli <fabio.comolli@gmail.com>
Cc: ACPI mailing list <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 13, 2010 at 1:50 PM, Fabio Comolli <fabio.comolli@gmail.com> wrote:
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
> supposed to change the processor frequency? Or does it change
> something else?
>
> And if the answer to the latest question is affirmative, why
> /proc/cpuinfo seems to ignore it?
>
> Sorry for the confusion.
> Regards,
> Fabio
>

Here is what I can read in your DSDT:

When INIT or _Q31 is called, the bios check the the battery is
present, and call FSBA(0) or FSBA(1).
_Q31 seems to be called by an hotkey, could you run "acpi_listen" and
search the hotkey that generate 0x50 or 0x51 ?

FSBA is the method called by CFVS. When you do "echo 1 > cpufv" it
calls CFVS(1), then FSBA(1).
FSBA got 2 presets on 900.

Using these presets, is write some bytes to the EC and to something
wich sounds like clock (RCLK, WCKB, WLCK)
By the name it seems that it set the FSB, it may also surely change
the CPU Clock.

Now, I don't know why cpuinfo always show the same value, maybe
because the cpu clock is not changed
by a cpufreq driver.

-- 
Corentin Chary
http://xf.iksaif.net
