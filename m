Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab2AJClU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 21:41:20 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:39188 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755952Ab2AJClT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 21:41:19 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQVwbkxXbi4yFR4CCdpNr-bm2Bn13Jxap7mX6OrYbM+_kg@mail.gmail.com>
References: <bug-41722-5003@https.bugzilla.kernel.org/>
	<201109062222.p86MMlK9023363@demeter2.kernel.org>
	<CAOtrxKO8+ukXovCiM+=c1EihbMFaYivmYnwDx4+41GggTEhyWg@mail.gmail.com>
	<CA+55aFxP-Xhz2Yb+g6VsTAPs704oC_DhbuxSqbCGmmr_CCHoPg@mail.gmail.com>
	<20120108221342.GA7058@ime.usp.br>
	<CA+55aFxmj_+0eLYqKZb6qWb_Zc4E4R8WrmbsVgv5BbNwvnqouQ@mail.gmail.com>
	<20120109112207.7f993845@jbarnes-desktop>
	<CA+55aFzmL0FTp_w7RWA0+mqS7YBL5HoNS1WY=2zxURgnvkOcjw@mail.gmail.com>
	<CAE9FiQVwbkxXbi4yFR4CCdpNr-bm2Bn13Jxap7mX6OrYbM+_kg@mail.gmail.com>
Date: Tue, 10 Jan 2012 00:41:17 -0200
X-Google-Sender-Auth: ul1GpswuQmY6cwBAZ7EtTB8R4dI
Message-ID: <CAOtrxKMH2iyWOOtYTYCsK5eH_ZZm9zrJyh30H_7HG-36+8k_iA@mail.gmail.com>
Subject: Re: [Bug 41722] Clevo M5X0JE hangs in ACPI init
From: =?UTF-8?Q?Rog=C3=A9rio_Brito?= <rbrito@ime.usp.br>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        bugzilla-daemon@bugzilla.kernel.org,
        Edward Donovan <edward.donovan@numble.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        =?UTF-8?Q?M=C3=A1rcia_Coutinho_de_Brito?= <mcbrito@gmail.com>,
        Ram Pai <linuxram@us.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Yinghai,

On Mon, Jan 9, 2012 at 23:32, Yinghai Lu <yinghai@kernel.org> wrote:
> in pci_bus_alloc_resource(),  we already have
>
>        /* don't allocate too high if the pref mem doesn't support 64bit*/
>        if (!(res->flags & IORESOURCE_MEM_64))
>                max = PCIBIOS_MAX_MEM_32;
>
> So it should allocate to range below 4G to unassigned children devices.
>
> but need to make sure (peer) root bus does have valid resource range at first.
>
> Rogério,
>
> Do you have bootlog with "debug ignore_loglevel pci=earlydump" ?

I have posted some information to bugzilla (see [0]), but not with
pci=earlydump. It seems that bugzilla doesn't want to mail me a reset
e-mail, but while I am waiting, I posted this on my homepage (see
[1]).

Please, note that this boot log was taken with the patch that I
e-mailed earlier (i.e., the one that makes things work). If you want
me to send a log with a vanilla kernel, just let me know and I will
grab more information.


Thanks,
Rogério.

[0]: https://bugzilla.kernel.org/show_bug.cgi?id=41622
[1]: http://www.ime.usp.br/~rbrito/linux/clevo/clevo-dmesg-with-earlydump-2012-01-10.txt

-- 
Rogério Brito : rbrito@{ime.usp.br,gmail.com} : GPG key 4096R/BCFCAAAA
http://rb.doesntexist.org : Packages for LaTeX : algorithms.berlios.de
DebianQA: http://qa.debian.org/developer.php?login=rbrito%40ime.usp.br
