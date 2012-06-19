Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044Ab2FSUkG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 16:40:06 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:11300 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957Ab2FSUkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 16:40:04 -0400
Message-ID: <4FE0E3A2.8070008@tilera.com>
Date: Tue, 19 Jun 2012 16:40:02 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Myron Stowe <myron.stowe@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Jiri Kosina <jkosina@suse.cz>, Joe Perches <joe@perches.com>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 3/3] arch/tile: tilegx PCI root complex support
References: <201204072316.q37NGv8d019280@farm-0023.internal.tilera.com> <201204072319.q37NJlNp019384@farm-0023.internal.tilera.com> <CAMuHMdX_XYQLs7gmzYS=dNmXxkQQiU3GBNW5b6EZso9bia5JqQ@mail.gmail.com> <CAE9FiQUBh-cWnQ4MQ2Cy_BH3wn0+9GV+9AfrV-zHD0nHh3T2mA@mail.gmail.com>
In-Reply-To: <CAE9FiQUBh-cWnQ4MQ2Cy_BH3wn0+9GV+9AfrV-zHD0nHh3T2mA@mail.gmail.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/19/2012 4:07 PM, Yinghai Lu wrote:
> On Tue, Jun 19, 2012 at 12:50 PM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
>> Hi Chris,
>>
>> On Sat, Apr 7, 2012 at 11:10 PM, Chris Metcalf <cmetcalf@tilera.com> wrote:
>>> This change implements PCIe root complex support for tilegx using
>>> the kernel support layer for accessing the TRIO hardware shim.
>>> --- /dev/null
>>> +++ b/arch/tile/kernel/pci_gx.c
>>> +               bus = pci_scan_bus(0, controller->ops, controller);
>>> +               controller->root_bus = bus;
>>> +               controller->last_busno = bus->subordinate;
>> As of commit 3527ed81ca01bbaf09df952e68528377a9cd092f
>> ("PCI: remove secondary/subordinate in struct pci_bus") in linux-next, the
>> "subordinate" field no longer exists:
>>
>> http://kisskb.ellerman.id.au/kisskb/buildresult/6546355/
>> arch/tile/kernel/pci_gx.c:852:31: error: 'struct pci_bus' has no
>> member named 'subordinate'
>> make[3]: *** [arch/tile/kernel/pci_gx.o] Error 1
> could changed to be
>                    contoller->last_busno = bus->busn.end;

Yes, I saw this build failure in the linux-next logs, but I'm not sure what
to do about it.  I can't adopt Yinghai's solution in my tree since my tree
is based off of Linus's tree which doesn't have "bus->busn".  I suppose I
could publish two trees to linux-next, one based off of Bjorn's "pci" tree
(I assume) and one with all the non-PCI arch/tile stuff (my current
linux-next tree).

I admit I was lazily assuming I would just fix this once the trees collided
during the 3.6 merge window :-)

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

