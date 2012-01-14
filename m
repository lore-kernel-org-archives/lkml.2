Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824Ab2ANVF6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 16:05:58 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33391 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756717Ab2ANVF4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 16:05:56 -0500
MIME-Version: 1.0
In-Reply-To: <CAOtrxKM_ijORTP_5C4z0R79jy5O=_eX5iNJ_GmAqXf6d8OGe9g@mail.gmail.com>
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
	<CAE9FiQX_koTHsjP8w=FyiSaBgY6QnzyWD43AVUW1d4MzViJXCg@mail.gmail.com>
	<CAOtrxKN4FQSPUJpP47=4+XzjTpcOQj=Dy+MUWBVYu7mQHNaSXA@mail.gmail.com>
	<CAOtrxKM_ijORTP_5C4z0R79jy5O=_eX5iNJ_GmAqXf6d8OGe9g@mail.gmail.com>
Date: Sat, 14 Jan 2012 13:05:54 -0800
X-Google-Sender-Auth: M-IjY58Fhfncnimg0rHK9eiv-zM
Message-ID: <CAE9FiQWbtByxJopU_SHLpiAJt_91qTs_=9dBFTYDHFh5OQQydg@mail.gmail.com>
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

On Fri, Jan 13, 2012 at 11:09 PM, Rogério Brito <rbrito@ime.usp.br> wrote:
> Dear Yinghai and other people,
>
> On Sat, Jan 14, 2012 at 00:01, Rogério Brito <rbrito@ime.usp.br> wrote:
>> On Fri, Jan 13, 2012 at 15:29, Yinghai Lu <yinghai@kernel.org> wrote:
>>> On Fri, Jan 13, 2012 at 3:59 AM, Rogério Brito <rbrito@ime.usp.br> wrote:
>>>> If it applies (and newer kernels don't have things which your patch needs),
>>>> I will keep working with Linus's v3.2 tag.
>>>
>>> No problem, I will put that patch into for-pci2 for your conveniences.
>>
>> Thanks. That's definitely easier for me. I'm grabbing it to compile
>> and will report in a moment.
>
> Just to clarify, my "definitely easier for me" means "I know what to
> do (or, at least, I'm closer this way not doing wrong things)".
>
>>>> When I compiled from your branch for-pci2 from linux-yinghai.git (without
>>>> any extra patches), it *did* boot, but noticed one thing weird: using htop
>>>> and in single user mode, it reported 100% of CPU in use. With regular top, a
>>>> more fine grained output revealed that no processes were using the CPU, but
>>>> that almost all of the time was spent in kernel mode.
>>>>
>>>> Anyway, as you asked, I put the log of what I see at
>>>>
>>>>    http://www.ime.usp.br/~rbrito/linux/clevo/2012-01-13-0951-yanghai-for-pci2-branch/
>>>
>>> [    0.165615] pci 0000:05:07.0: CardBus bridge to [bus 06-09]
>>> [    0.165682] pci 0000:05:07.0:   bridge window [io  0x0001-0x0000]
>>> [    0.165751] pci 0000:05:07.0:   bridge window [io  0x0001-0x0000]
>>> [    0.165821] pci 0000:05:07.0:   bridge window [mem
>>> 0x00000001-0x00000000 pref]
>>> [    0.165904] pci 0000:05:07.0:   bridge window [mem 0x00000001-0x00000000]
>>> [    0.165975] pci 0000:00:10.0: PCI bridge to [bus 05-06]
>>> [    0.166043] pci 0000:00:10.0:   bridge window [mem 0xb3200000-0xb32fffff]
>>> [    0.166259] pci 0000:00:10.0: setting latency timer to 64
>>> [    0.166329] pci 0000:05:07.0: device not available (can't reserve
>>> [io  0x0001-0x0000])
>>> [    0.166412] pci 0000:05:07.0: Error enabling bridge (-22), continuing
>>>
>>> We have some problems with handling cardbus bridge as optional resources.
>>>
>>> will produce some patches and update for-pci2 branch for your test.
>>
>> OK. Will try that as soon as my download completes.
>
> Just for the record, I have grabbed your for-pci2 branch with HEAD
> being 5db4211 and this is what I get:
>
>    http://www.ime.usp.br/~rbrito/linux/clevo/boot-yinghai-for-pci2-g5db4211.m4v
>
> A warning, though is that there were some options regarding PCI buses
> which I did not know exactly how to answer. I can post my config here
> if you are interested in that. Well, actually, I can give you ssh
> access to this notebook if you want to hack on it. Just let me know
> what times you (or anyone else) are online and I will try to arrange
> everything.
>

Please enable CONFIG_BOOT_PRINTK_DELAY in your .config

and boot with "boot_delay=1000" or even "boot_delay=5000"

then video capture could help.

Thanks

Yinghai
