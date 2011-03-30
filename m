Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932878Ab1C3UEf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 16:04:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47105 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754227Ab1C3UEe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 16:04:34 -0400
MIME-Version: 1.0
In-Reply-To: <20110330202628.5dc8db5f@lxorguk.ukuu.org.uk>
References: <4D937FDC.4090607@danielpalmer.co.uk> <20110330202628.5dc8db5f@lxorguk.ukuu.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 30 Mar 2011 12:36:16 -0700
Message-ID: <AANLkTimokmN5++Qghz-2pTDa7KLnRn_YBW-ox_9tP+XO@mail.gmail.com>
Subject: Re: PATA_ARTOP reads byte from PCI IO port without mapping it to the
 right address.
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Daniel Palmer <me@danielpalmer.co.uk>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 12:26 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> unsigned long io = pci_resource_start(pdev, 4);           // This
>> returns 0x1400 on my machine
>
> That is the PCI port address.
>
>>                  u8 reg;
>>
>>                  ppi[0] = &info_628x;
>>                  if (inb(io) & 0x10)
>>          // This reads from 0x1400, which isn't were the port actually
>> is in the processors address
>
> This reads from I/O port 0x1400 - your inb logic and I/O port mapping on
> the platform is responsible for making that work.

Indeed. We do _not_ expect inb/outb to do the equivalent of ioremap()
etc, since the IO port range is just 64kB. The arch code is supposed
to do whatever mapping it needs statically at bootup, and just make
inb/outb honor that mapping.

                          Linus
