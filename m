Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483Ab2AJJZh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 04:25:37 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:37156 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754882Ab2AJJZe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 04:25:34 -0500
MIME-Version: 1.0
X-Originating-IP: [71.233.110.244]
In-Reply-To: <20120108221342.GA7058@ime.usp.br>
References: <bug-41722-5003@https.bugzilla.kernel.org/> <201109062222.p86MMlK9023363@demeter2.kernel.org>
 <CAOtrxKO8+ukXovCiM+=c1EihbMFaYivmYnwDx4+41GggTEhyWg@mail.gmail.com>
 <CA+55aFxP-Xhz2Yb+g6VsTAPs704oC_DhbuxSqbCGmmr_CCHoPg@mail.gmail.com> <20120108221342.GA7058@ime.usp.br>
From: Edward Donovan <ed@numble.net>
Date: Tue, 10 Jan 2012 04:25:12 -0500
Message-ID: <CADdbW+Eq=5U2smt=QgYiEKf2amy=xd_ZdpBZ9oLD3au7KfHgNg@mail.gmail.com>
Subject: Re: [Bug 41722] Clevo M5X0JE hangs in ACPI init
To: =?ISO-8859-1?Q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?M=E1rcia_Coutinho_de_Brito?= <mcbrito@gmail.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, Ram Pai <linuxram@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rogério -

I'm glad to see you're getting help from a lot of skilled people, here.

On Sun, Jan 8, 2012 at 5:13 PM, Rogério Brito <rbrito@ime.usp.br> wrote:
> On Jan 06 2012, Linus Torvalds wrote:
>> 2012/1/6 Rogério Brito <rbrito@ime.usp.br>:
>> >
>> > For the record, *some* description of the problem is at:
>> >
>> > * https://bugzilla.kernel.org/show_bug.cgi?id=41132
>>
>> This one looks very much like the thing that Edward Donovan fixed
>> fairly recently in commit 52553ddffad7 ("genirq: fix regression in
>> irqfixup, irqpoll")
>
> It does look similar, but not quite the same. And, yes, my main desktop (the
> one that I'm using right now) was affected by Edward's commit, which, BTW,
> has my Reported-and-tested-by.


The one area I have experience with is the IRQ regression you cite in
41132.  I was bitten by the regressions in spurious IRQ handling, like
you, and this has been my first trip inside the kernel.  The patches I
sent are the sum of my kernel wisdom to date, and I don't want to
impersonate an experienced developer, even by accident. :)

At any rate: I can't tell, yet, what IRQ trouble is happening on this
notebook.  I couldn't pick any out from the description below.  And so
I can't tell, either :) , how it is similar to the bug above, but not
quite the same.

Is there an IRQ disabled, "nobody cared", problem, even with the
newest kernels?

If you have info on IRQ problems, I can look at it, hopefully soon.
Right now, it might make sense to let this PCI effort roll forward,
before opening a second front, but I can't say that for sure.  I
certainly hope we can make your mom's notebook a happy Linux box.

Thanks,

Ed


> This one is different. Here is a brief summary of the situation:
>
> # Computer description
>
> * Rebranded Clevo M5X0JE
> * nForce2 chipset
> * AMD Sempron CPU
> * NIC with driver forcedeth
> * wifi rtl8187
>
> # Booting options
>
> The current working options passed to the kernel are: `acpi=off pnpbios=off noapic`
>
> It doesn't boot with a vanilla kernel. It only boots when I pass the options
> above *and* compile the kernel with the following patch applied:
>
> ,----[ do_not_size_subtractive_decoding_transparent_pci_to_pci_bridges.patch ]
> | diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
> | index 86b69f85..84543f5 100644
> | --- a/drivers/pci/setup-bus.c
> | +++ b/drivers/pci/setup-bus.c
> | @@ -849,6 +849,10 @@ void __ref __pci_bus_size_bridges(struct pci_bus *bus,
> |               break;
> |
> |       case PCI_CLASS_BRIDGE_PCI:
> | +             /* don't size subtractive decoding (transparent)
> | +              * PCI-to-PCI bridges */
> | +             if (bus->self->transparent)
> | +                     break;
> |               pci_bridge_check_ranges(bus);
> |               if (bus->self->is_hotplug_bridge) {
> |                       additional_io_size  = pci_hotplug_io_size;
> `----
>
> Otherwise, it hangs right when trying to configure PCI, which, according to
> the dmesg log when it boots occurs approximately 0.12 seconds after the
> kernel shows its first message.
>
