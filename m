Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966Ab0JSULz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 16:11:55 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:35065 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779Ab0JSULy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 16:11:54 -0400
Date: Tue, 19 Oct 2010 21:11:51 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ralf Baechle <ralf@linux-mips.org>
cc: Kevin Cernekee <cernekee@gmail.com>,
        Shinya Kuribayashi <skuribay@pobox.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend 5/9] MIPS: sync after cacheflush
In-Reply-To: <20101019123441.GJ27377@linux-mips.org>
Message-ID: <alpine.LFD.2.00.1010192039550.15889@eddie.linux-mips.org>
References: <17ebecce124618ddf83ec6fe8e526f93@localhost> <17d8d27a2356640a4359f1a7dcbb3b42@localhost> <4CBC4F4E.5010305@pobox.com> <AANLkTinpry=XG-ZDgXJK-VB6QkBL2TO4-vrsV5Tc1eEs@mail.gmail.com> <alpine.LFD.2.00.1010190146360.15889@eddie.linux-mips.org>
 <20101019123441.GJ27377@linux-mips.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Oct 2010, Ralf Baechle wrote:

> See R4000 User's Manual Version 2, page 326, "Uncached Loads and Stores".
> Of course this can only happen on cache coherent or multiprocessor systems.
> I guess none of the supported DEC MIPS systems is affected.

 Since none of the R4k DECstations is coherent or MP, I have not 
considered these implications.  The only MP DECsystem (there was no 
workstation variation), that is the 5800, was built with R3k chips in the 
first place and the chance we ever come across one, let alone support it, 
is epsilon.

 That said, R4k DECstations seem to perform aggressive write buffering in 
the chipset and to make sure a write has propagated to an MMIO register a 
SYNC and an uncached read operation are necessary.  The read may be from 
elsewhere apparently -- RAM at 0 seems just fine -- so the chipset seems 
to obey the SYNC semantics.

 I haven't investigated DMA dependencies and I think we currently only 
have one TURBOchannel device/driver only (that is the DEFTA/defxx FDDI 
thingy) making use of the generic DMA API on DECstations.  It seemed to 
work correctly the last time I tried; presumably either because the API 
Does The Right Thing, or by pure luck and right timings.  Note that the 
DEC/Motorola CAMEL FDDI chipset was quite an aggressive DMA agent for its 
time, certainly capable of saturating some lower-clocked implementations 
of the I/O bus.

 Then I think the onboard devices that do third-party DMA via the IOASIC 
such as the LANCE Ethernet are too obscure/arcane to consider them here 
and get any useful results -- any inconsistencies may well be masked by 
the odd sequences used to access the respective chips.  There were some 
hardly documented chipset errata too, making the whole thing yet more 
complicated and causing some "impossible" error scenarios.

  Maciej
