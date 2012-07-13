Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490Ab2GMUms (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 16:42:48 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:35469 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab2GMUmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 16:42:46 -0400
MIME-Version: 1.0
In-Reply-To: <4FFEF71E.7080706@xenotime.net>
References: <20120712160335.9cbff13c2f18eadc7d3cb0cf@canb.auug.org.au>
	<4FFEF71E.7080706@xenotime.net>
Date: Fri, 13 Jul 2012 14:42:45 -0600
Message-ID: <CAL-B5D2D8WfDgrQoz4AVojXxavrhap2XPRyhkR3AeD4NNZHHxQ@mail.gmail.com>
Subject: Re: linux-next: Tree for July 12 (pci)
From: Myron Stowe <myron.stowe@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 10:11 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On 07/11/2012 11:03 PM, Stephen Rothwell wrote:
>
>> Hi all,
>>
>> Changes since 20120710:
>>
>>
>> The pci tree lost its conflicts.
>
>
> on x86_64:
>
> drivers/built-in.o: In function `pci_bus_add_device':
> (.text+0x4f62): undefined reference to `pci_fixup_final_inited'
>
>
> when CONFIG_PCI_QUIRKS is not enabled.
>
I just posted a patch to  resolve what you encountered.  Would you mind giving
it a try and reporting back with the results?

It's obvious what you ran into, with CONFIG_PCI_QUIRKS not enabled,
./drivers/pci/quirks.o ends up not being generated and included in the
kernel thus
the unresolved reference from ./drivers/pci/bus.o.

I tried to reproduce the failure by disabling my .config file's
CONFIG_PCI_QUIRKS
entry (which in turn required me to enable CONFIG_EXPERT) but that was not
enough to encounter the unresolved reference - although it *should* have been.

Myron
>
> --
> ~Randy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
