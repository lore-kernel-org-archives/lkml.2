Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505Ab0FEU0b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 16:26:31 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39458 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707Ab0FEU03 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 16:26:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xWAzAMlAmGlyQjTntrrVpbaknnaLOgVToKl4yauvstmkJul8vFpLZkfPtVLFfJs7Pn
         u7K9MQKKWPZeqsbhPRbFrp9HuhnlSeKQm5AbhuhTWUIcrFakaHAGmJxkJdeN/Yyg9mYP
         bcg8p24opBesk5fBhuWnNTKew8DsnzNNUe/z8=
MIME-Version: 1.0
In-Reply-To: <20100605220143.08774900@schatten.dmk.lab>
References: <Pine.LNX.4.44L0.1005271253240.3239-100000@iolanthe.rowland.org>
	<201005302202.39511.rjw@sisk.pl>
	<AANLkTilUQ2AG76nbK6LwI8_7zw0_yMSoAOr9pmuz7xrt@mail.gmail.com>
	<201005312347.24251.rjw@sisk.pl>
	<AANLkTilvOgSFTDFtXbjJobMZWxgfvsC97TqC7_a_NHBX@mail.gmail.com>
	<alpine.LFD.2.00.1006011411200.2933@localhost.localdomain>
	<AANLkTikZHmF6baP7dEXEGFE8YsbEteRjlhb5wqZX8ll1@mail.gmail.com>
	<alpine.LFD.2.00.1006020905410.2933@localhost.localdomain>
	<AANLkTinDm3FIrbS1jqEzW15THmr1hdd7ox0Mllm1VLjZ@mail.gmail.com>
	<1275471561.27810.30865.camel@twins>
	<AANLkTilLmAb2c9fQwuguzWtjcHfuTZvPUTbUx7vuwFI6@mail.gmail.com>
	<AANLkTikna-Vs_phy2VrJs0I8gIsdSmwuxTJ67gQ_2oTt@mail.gmail.com>
	<20100605220143.08774900@schatten.dmk.lab>
Date: Sat, 5 Jun 2010 23:26:27 +0300
Message-ID: <AANLkTindQjsQRMUkxKNx-NqSiMlxUirmK2GO6zE7n0rf@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Florian Mickler <florian@mickler.org>
Cc: =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Stern <stern@rowland.harvard.edu>, Paul@smtp1.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 5, 2010 at 11:01 PM, Florian Mickler <florian@mickler.org> wrote:
> On Sat, 5 Jun 2010 20:44:24 +0300
> Felipe Contreras <felipe.contreras@gmail.com> wrote:
>
>> 2010/6/2 Arve Hjønnevåg <arve@android.com>:
>> > 2010/6/2 Peter Zijlstra <peterz@infradead.org>:
>> >> (and please don't mention @#$@ up x86 ACPI again, Intel knows, they're
>> >> fixing it, get over it already).
>> >>
>> >
>> > I don't think it is realistic to drop support for all existing hardware.
>>
>> We are talking about mainline here, there's no support for suspend
>> blockers, so nothing is dropped.
>>
>> In the mind of everybody, suspend blockers is for opportunistic
>> suspend, which only makes sense on sensible hw (not current x86). So
>> in the mind of everybody, x86 should be out of scope for the analysis
>> of suspend blockers.
>>
>> Are you seriously suggesting that one of the strong arguments in favor
>> of suspend blockers is x86 usage (nobody agrees)? If not, then drop
>> it.
>
> I think they have an advantage over the
> 30-minute-screensaver-then-suspend that current desktops do. Because
> you can define what keeps the system up. I.e. the
> screensaver/powermanager is not limited to keyboard- and
> mouse-inactivity.

What prevents you from defining other things keeping the system up
right now? Nothing. It's up to user-space to decide when to suspend.
In fact applications already block suspend; Transmission has the
option to block suspend when downloading torrents.

>> If I enable suspend blockers on my laptop, I have to modify my
>> user-space. Otherwise my system will behave horribly.
>>
>
> In the simplest case you have a shell script which takes a suspend
> blocker and reads from stdinput. When you write "mem" to it, it
> releases the suspend blocker and acquires it back again. Voila, forced
> suspend reimplemented on top of opportunistic suspend.
>
> That wasn't hard, was it?

Not hard, but still a modification of user-space, and a pretty bad one
because it will prevent typical forced suspend, and typical suspend
delaying (like with Transmission). Supposing the opportunistic suspend
doesn't block the forced suspend, still, absolutely nothing will be
achieved by enabling suspend blockers.

If you want to take even a minimal advantage of suspend blockers you
need serious modifications to user-space.

Supposing there's a perfect usage of suspend blockers from user-space
on current x86 platforms (in theory Android would have that), is the
benefit that big to consider this a strong argument in favor of
suspend blockers? Considering the small amount of x86 platforms using
Android (is there any?), the fact that nobody else will use suspend
blockers, and that x86 is already being fixed (as mentioned many times
before) so dynamic PM is possible, I don't think we should be
considering current x86 at all for suspend blockers.

-- 
Felipe Contreras
