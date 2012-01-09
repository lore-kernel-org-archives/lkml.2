Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab2AIEVN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 23:21:13 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:57524 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753557Ab2AIEVM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 23:21:12 -0500
MIME-Version: 1.0
In-Reply-To: <20120108222722.GB7058@ime.usp.br>
References: <bug-41722-5003@https.bugzilla.kernel.org/> <201109062222.p86MMlK9023363@demeter2.kernel.org>
 <CAOtrxKO8+ukXovCiM+=c1EihbMFaYivmYnwDx4+41GggTEhyWg@mail.gmail.com>
 <CA+55aFxP-Xhz2Yb+g6VsTAPs704oC_DhbuxSqbCGmmr_CCHoPg@mail.gmail.com>
 <CADdbW+HvKQRFJgcofZCjJrTtaPDpDhcw4UStuhyTUe1aKnD2JQ@mail.gmail.com> <20120108222722.GB7058@ime.usp.br>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Sun, 8 Jan 2012 21:20:50 -0700
Message-ID: <CAErSpo6CEfSC=--Tkn2LofZuJ-TXPAMCO9qMcwovzj_k_rMiig@mail.gmail.com>
Subject: Re: [Bug 41722] Clevo M5X0JE hangs in ACPI init
To: =?ISO-8859-1?Q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
Cc: Edward Donovan <edward.donovan@numble.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        bugzilla-daemon@bugzilla.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?M=E1rcia_Coutinho_de_Brito?= <mcbrito@gmail.com>
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 8, 2012 at 3:27 PM, Rogério Brito <rbrito@ime.usp.br> wrote:
> I bisected the PCI stuff and ended up with a bad commit 12c22d6ef299ccf0955,
> which was made by Linus:
>
> ,----[ git show 12c22d6ef299ccf0955e5756eb57d90d7577ac68 ]
> | commit 12c22d6ef299ccf0955e5756eb57d90d7577ac68
> | Author: Linus Torvalds <torvalds@linux-foundation.org>
> | Date:   Wed Mar 26 11:22:40 2008 -0700
> |
> |     Revert "PCI: remove transparent bridge sizing"
> | (...)
> `----
>
> The patch that I am using to make this laptop boot at least is essentially a
> revert of that commit.
>
> Just for the sake of documentation, I am attaching here the patch that makes
> things work (at least partially).

Your patch avoids sizing transparent bridges.  I don't have an opinion
on whether that's a good idea in general.

However, I am curious about what breaks on your system when we do size
the transparent bridge.  It seems like sizing it should *work*, even
if it's not strictly necessary, so I wonder if this hang is telling us
about some other PCI allocation issue we should fix.  Would you mind
opening a bugzilla for this, since the current tree is broken for you,
and attaching a log or digital photo of the hang?

Bjorn
