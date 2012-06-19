Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936Ab2FSUHc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 16:07:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42068 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902Ab2FSUHb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 16:07:31 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdX_XYQLs7gmzYS=dNmXxkQQiU3GBNW5b6EZso9bia5JqQ@mail.gmail.com>
References: <201204072316.q37NGv8d019280@farm-0023.internal.tilera.com>
	<201204072319.q37NJlNp019384@farm-0023.internal.tilera.com>
	<CAMuHMdX_XYQLs7gmzYS=dNmXxkQQiU3GBNW5b6EZso9bia5JqQ@mail.gmail.com>
Date: Tue, 19 Jun 2012 13:07:30 -0700
X-Google-Sender-Auth: T9hdaZd3oEXczCcWJKjlyvTduSg
Message-ID: <CAE9FiQUBh-cWnQ4MQ2Cy_BH3wn0+9GV+9AfrV-zHD0nHh3T2mA@mail.gmail.com>
Subject: Re: [PATCH 3/3] arch/tile: tilegx PCI root complex support
From: Yinghai Lu <yinghai@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Myron Stowe <myron.stowe@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Jiri Kosina <jkosina@suse.cz>, Joe Perches <joe@perches.com>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 12:50 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> Hi Chris,
>
> On Sat, Apr 7, 2012 at 11:10 PM, Chris Metcalf <cmetcalf@tilera.com> wrote:
>> This change implements PCIe root complex support for tilegx using
>> the kernel support layer for accessing the TRIO hardware shim.
>
>> --- /dev/null
>> +++ b/arch/tile/kernel/pci_gx.c
>
>> +               bus = pci_scan_bus(0, controller->ops, controller);
>> +               controller->root_bus = bus;
>> +               controller->last_busno = bus->subordinate;
>
> As of commit 3527ed81ca01bbaf09df952e68528377a9cd092f
> ("PCI: remove secondary/subordinate in struct pci_bus") in linux-next, the
> "subordinate" field no longer exists:
>
> http://kisskb.ellerman.id.au/kisskb/buildresult/6546355/
> arch/tile/kernel/pci_gx.c:852:31: error: 'struct pci_bus' has no
> member named 'subordinate'
> make[3]: *** [arch/tile/kernel/pci_gx.o] Error 1

could changed to be
                   contoller->last_busno = bus->busn.end;

Thanks

Yinghai
