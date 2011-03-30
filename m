Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932981Ab1C3UYo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 16:24:44 -0400
Received: from tomato.cardboardbox.org.uk ([174.143.157.65]:37373 "EHLO
	tomato.cardboardbox.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754957Ab1C3UYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 16:24:43 -0400
Message-ID: <4D93917F.6090309@danielpalmer.co.uk>
Date: Wed, 30 Mar 2011 21:24:31 +0100
From: Daniel Palmer <me@danielpalmer.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110303 Icedove/3.0.11
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: PATA_ARTOP reads byte from PCI IO port without mapping it to
 the right address.
References: <4D937FDC.4090607@danielpalmer.co.uk> <20110330202628.5dc8db5f@lxorguk.ukuu.org.uk> <4D93890A.60307@danielpalmer.co.uk> <201103302200.47052.arnd@arndb.de>
In-Reply-To: <201103302200.47052.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Is this an ARM machine? The platform specific mach/io.h header

Sorry, I should have mentioned it more explicitly.
The machine is an SH4 based (The processor model is SH7751R, board is 
landisk.. in /arch/sh/include/mach-landisk/).

> You have to ioremap() the physical address 0xfe240000 to a virtual
> address, and then add the base address to the number inside of the
> __io macro, e.g.
>
>
>    
-- snip --

Ok, that makes a lot of sense.  This is the first time I've ever touched 
PCI.
I've looked around and I can't right now see where that matches up with 
the SH/board specific code but I'll have a better look later.

We've been trying to work this out for a few days.. we were fudging the 
io port base address in arch/sh/kernel/ioport.c to the start of the PCI 
space. But we didn't think that was the right thing to be doing.
We have another board with the same processor and e100 NIC that uses the 
same mapping to 0x1400 and uses io ports but worked fine. So we guessed 
it was pata_artops use of inb() .. the person that did a lot of changes 
to this board's code recently also wrote that he thought it was 
pata_artops fault when I asked on the linux-sh list.


