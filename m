Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758569Ab2AMR3f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 12:29:35 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55448 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab2AMR3c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 12:29:32 -0500
MIME-Version: 1.0
In-Reply-To: <20120113115946.GA10615@ime.usp.br>
References: <CA+55aFxP-Xhz2Yb+g6VsTAPs704oC_DhbuxSqbCGmmr_CCHoPg@mail.gmail.com>
	<20120108221342.GA7058@ime.usp.br>
	<CA+55aFxmj_+0eLYqKZb6qWb_Zc4E4R8WrmbsVgv5BbNwvnqouQ@mail.gmail.com>
	<20120109112207.7f993845@jbarnes-desktop>
	<CA+55aFzmL0FTp_w7RWA0+mqS7YBL5HoNS1WY=2zxURgnvkOcjw@mail.gmail.com>
	<CAE9FiQVwbkxXbi4yFR4CCdpNr-bm2Bn13Jxap7mX6OrYbM+_kg@mail.gmail.com>
	<CAOtrxKMH2iyWOOtYTYCsK5eH_ZZm9zrJyh30H_7HG-36+8k_iA@mail.gmail.com>
	<CAE9FiQWg8k-_eHH-Erwn+iZgs-rDfPcSc7uPcF_h+1+mXVEVXQ@mail.gmail.com>
	<CAOtrxKOZ1yuWaAYxjPLE2obwTkCfRytRFyQc3VuK9JmJLYVrqw@mail.gmail.com>
	<CAE9FiQXCJobMuFWbyoWQpVup_pvKMuGpu7eotF0EJAx2_Ee7OQ@mail.gmail.com>
	<20120113115946.GA10615@ime.usp.br>
Date: Fri, 13 Jan 2012 09:29:31 -0800
X-Google-Sender-Auth: x6S2yiGH6PYuVBEB0VoMw6076UE
Message-ID: <CAE9FiQX_koTHsjP8w=FyiSaBgY6QnzyWD43AVUW1d4MzViJXCg@mail.gmail.com>
Subject: Re: [Bug 41722] Clevo M5X0JE hangs in ACPI init
From: Yinghai Lu <yinghai@kernel.org>
To: =?ISO-8859-1?Q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Edward Donovan <edward.donovan@numble.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?M=E1rcia_Coutinho_de_Brito?= <mcbrito@gmail.com>,
        Ram Pai <linuxram@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 3:59 AM, Rogério Brito <rbrito@ime.usp.br> wrote:
> Dear Yinghai,
>
> On Jan 11 2012, Yinghai Lu wrote:
>> On Tue, Jan 10, 2012 at 11:04 PM, Rogério Brito <rbrito@ime.usp.br> wrote:
>> > On Tue, Jan 10, 2012 at 03:07, Yinghai Lu <yinghai@kernel.org> wrote:
>> >>   git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
>> >> for-pci2
>> >>
>> >> also please boot with "debug ignore_loglevel"
>> >
>> > Grabbing it right now. Will report it after I get some sleep (5AM here).
>>
>> please try attached patch, it will fix one bios wrong setting.
>
> Should I use this patch agains which tree?
>
> Right now, I have Linus's tree, yours (cited above) and I am, up to now,
> I had been compiling everything from Linus's v3.2 tag: both a vanilla
> kernel, as asked by Bjorn and with the patch that I mentioned to Linus ("the
> one that makes things boot").
>
> If it applies (and newer kernels don't have things which your patch needs),
> I will keep working with Linus's v3.2 tag.

No problem, I will put that patch into for-pci2 for your conveniences.

>
> When I compiled from your branch for-pci2 from linux-yinghai.git (without
> any extra patches), it *did* boot, but noticed one thing weird: using htop
> and in single user mode, it reported 100% of CPU in use. With regular top, a
> more fine grained output revealed that no processes were using the CPU, but
> that almost all of the time was spent in kernel mode.
>
> Anyway, as you asked, I put the log of what I see at
>
>    http://www.ime.usp.br/~rbrito/linux/clevo/2012-01-13-0951-yanghai-for-pci2-branch/

[    0.165615] pci 0000:05:07.0: CardBus bridge to [bus 06-09]
[    0.165682] pci 0000:05:07.0:   bridge window [io  0x0001-0x0000]
[    0.165751] pci 0000:05:07.0:   bridge window [io  0x0001-0x0000]
[    0.165821] pci 0000:05:07.0:   bridge window [mem
0x00000001-0x00000000 pref]
[    0.165904] pci 0000:05:07.0:   bridge window [mem 0x00000001-0x00000000]
[    0.165975] pci 0000:00:10.0: PCI bridge to [bus 05-06]
[    0.166043] pci 0000:00:10.0:   bridge window [mem 0xb3200000-0xb32fffff]
[    0.166259] pci 0000:00:10.0: setting latency timer to 64
[    0.166329] pci 0000:05:07.0: device not available (can't reserve
[io  0x0001-0x0000])
[    0.166412] pci 0000:05:07.0: Error enabling bridge (-22), continuing

We have some problems with handling cardbus bridge as optional resources.

will produce some patches and update for-pci2 branch for your test.

Thanks

Yinghai
