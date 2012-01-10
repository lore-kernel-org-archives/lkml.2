Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933631Ab2AJB6B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 20:58:01 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:62148 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932329Ab2AJB6A convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 20:58:00 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFxmj_+0eLYqKZb6qWb_Zc4E4R8WrmbsVgv5BbNwvnqouQ@mail.gmail.com>
References: <bug-41722-5003@https.bugzilla.kernel.org/>
	<201109062222.p86MMlK9023363@demeter2.kernel.org>
	<CAOtrxKO8+ukXovCiM+=c1EihbMFaYivmYnwDx4+41GggTEhyWg@mail.gmail.com>
	<CA+55aFxP-Xhz2Yb+g6VsTAPs704oC_DhbuxSqbCGmmr_CCHoPg@mail.gmail.com>
	<20120108221342.GA7058@ime.usp.br>
	<CA+55aFxmj_+0eLYqKZb6qWb_Zc4E4R8WrmbsVgv5BbNwvnqouQ@mail.gmail.com>
Date: Mon, 9 Jan 2012 23:57:59 -0200
X-Google-Sender-Auth: 3Ig5uXumHPRGj15_gqBJrHA6rMk
Message-ID: <CAOtrxKOkqxBepX19E1DJu+KSN=DJxxnWi3T9DnJR-C8pRfA-tg@mail.gmail.com>
Subject: Re: [Bug 41722] Clevo M5X0JE hangs in ACPI init
From: =?UTF-8?Q?Rog=C3=A9rio_Brito?= <rbrito@ime.usp.br>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: bugzilla-daemon@bugzilla.kernel.org,
        Edward Donovan <edward.donovan@numble.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        =?UTF-8?Q?M=C3=A1rcia_Coutinho_de_Brito?= <mcbrito@gmail.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>, Ram Pai <linuxram@us.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Linus.

On Sun, Jan 8, 2012 at 20:23, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sun, Jan 8, 2012 at 2:13 PM, Rogério Brito <rbrito@ime.usp.br> wrote:
>>
>> It doesn't boot with a vanilla kernel. It only boots when I pass the options
>> above *and* compile the kernel with the following patch applied:
>>
>> ,----[ do_not_size_subtractive_decoding_transparent_pci_to_pci_bridges.patch ]
>> | diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
>> | index 86b69f85..84543f5 100644
>> | --- a/drivers/pci/setup-bus.c
>> | +++ b/drivers/pci/setup-bus.c
>> | @@ -849,6 +849,10 @@ void __ref __pci_bus_size_bridges(struct pci_bus *bus,
>> |               break;
>> |
>> |       case PCI_CLASS_BRIDGE_PCI:
>> | +             /* don't size subtractive decoding (transparent)
>> | +              * PCI-to-PCI bridges */
>> | +             if (bus->self->transparent)
>> | +                     break;
>> |               pci_bridge_check_ranges(bus);
>> |               if (bus->self->is_hotplug_bridge) {
>> |                       additional_io_size  = pci_hotplug_io_size;
>> `----
>
> Ahh. I'd forgotten about that particular PCI patch.

Thanks for acknowledging that issue.

> I think we should try to re-do that "avoid sizing transparent bridges"
> commit, because it really should make it much easier to do PCI
> allocations under some very common situations (there's a *lot* of
> common intel transparent PCI bridges).

All this PCI stuff is alien to me, but I am learning some by osmosis
here, which is not bad at all. :)

I only fear that if the patch above is applied and proves to have ill
effects if reverting it will leave this computer (and, potentially,
some others) without booting. As I always say, I can test anything
that you guys want me to do, given some guidance.


Thanks,

-- 
Rogério Brito : rbrito@{ime.usp.br,gmail.com} : GPG key 4096R/BCFCAAAA
http://rb.doesntexist.org : Packages for LaTeX : algorithms.berlios.de
DebianQA: http://qa.debian.org/developer.php?login=rbrito%40ime.usp.br
