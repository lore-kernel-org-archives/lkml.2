Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757817Ab0CPUbl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 16:31:41 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:53678 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757635Ab0CPUbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 16:31:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Bvp+7TYWqojoweD+MQ8pByL6aXUN2fwM2nkUOvfxdDMHVvjwLGE4muSOfvcHwSc9g8
         M8SQj1OAmpqDzu4Dit+72O6eY9kEH65IqpsxuaaEwZt4RPDa1ssjSi49d5C1F3IE8zqz
         1UNNT2NhxHqdeF05pH07Yf/fNz7sa5l+LPJK4=
MIME-Version: 1.0
In-Reply-To: <71cd59b01003152354h64d18c0fq2083f60e399313c8@mail.gmail.com>
References: <b637ec0b1003111328u5c1d7d7fw6c76c409740827c7@mail.gmail.com>
	 <71cd59b01003120049n1a9fbbf3qfd37f14f241a7f64@mail.gmail.com>
	 <b637ec0b1003121207g5d29ddb4k338f1768ed1c2759@mail.gmail.com>
	 <71cd59b01003130116h4265769v9e1dae95361629ce@mail.gmail.com>
	 <b637ec0b1003130450n3293ee78wc58e08a9bbcefe17@mail.gmail.com>
	 <71cd59b01003152354h64d18c0fq2083f60e399313c8@mail.gmail.com>
Date: Tue, 16 Mar 2010 21:31:14 +0100
Message-ID: <b637ec0b1003161331y680418e0p6549504165a45701@mail.gmail.com>
Subject: Re: Possible bug in eeepc-laptop.c - EeePC 900
From: Fabio Comolli <fabio.comolli@gmail.com>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: ACPI mailing list <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Tue, Mar 16, 2010 at 7:54 AM, Corentin Chary
<corentin.chary@gmail.com> wrote:
> On Sat, Mar 13, 2010 at 1:50 PM, Fabio Comolli <fabio.comolli@gmail.com> wrote:
>> Well, I'm confused.
>>
>> I rebooted with the "vanilla" eeepc-laptop.c and I'm sorry to say that
>> the situation it's not like the one I described in the post I wrote 2
>> days ago. Actually the situation with the patch reverted is the same I
>> have with the patch applied.
>>
>> What I mean is that if I boot on AC power /proc/cpuinfo always reports
>> 900MHz and 1800 bogomips. It I boot on battery /proc/cpuinfo always
>> reports 630MHz and 1260 bogomips. Plugging / unplugging the AC does
>> not change the situation. Only reboot does.
>>
>> But the cpufv interface does indeed seem to work, as glxgears and
>> stellarium show the frame rate change accordingly to the powersave /
>> performance selection.
>>
>> So my question is: what does really the cpufv interface do? Is it
>> supposed to change the processor frequency? Or does it change
>> something else?
>>
>> And if the answer to the latest question is affirmative, why
>> /proc/cpuinfo seems to ignore it?
>>
>> Sorry for the confusion.
>> Regards,
>> Fabio
>>
>
> Here is what I can read in your DSDT:
>
> When INIT or _Q31 is called, the bios check the the battery is
> present, and call FSBA(0) or FSBA(1).
> _Q31 seems to be called by an hotkey, could you run "acpi_listen" and
> search the hotkey that generate 0x50 or 0x51 ?

This is the output requested.

hotkey ATKD 0000002e 00000000
hotkey ATKD 0000002f 00000000
hotkey ATKD 00000030 00000000
hotkey ATKD 00000012 00000000
hotkey ATKD 00000013 00000000
hotkey ATKD 00000014 00000000
hotkey ATKD 00000015 00000000
hotkey ATKD 00000010 00000000
button/sleep SLPB 00000080 00000001
hotkey ATKD 00000010 00000001

>
> FSBA is the method called by CFVS. When you do "echo 1 > cpufv" it
> calls CFVS(1), then FSBA(1).
> FSBA got 2 presets on 900.
>
> Using these presets, is write some bytes to the EC and to something
> wich sounds like clock (RCLK, WCKB, WLCK)
> By the name it seems that it set the FSB, it may also surely change
> the CPU Clock.
>
> Now, I don't know why cpuinfo always show the same value, maybe
> because the cpu clock is not changed
> by a cpufreq driver.

Well, the cpuinfo frequency value seems to be set only at boot: 630 if
booting from battery, 900 from AC.

>
> --
> Corentin Chary
> http://xf.iksaif.net
>

Thanks,
Fabio
