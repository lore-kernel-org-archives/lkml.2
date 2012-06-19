Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab2FSTu5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 15:50:57 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:51290 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648Ab2FSTuz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 15:50:55 -0400
MIME-Version: 1.0
In-Reply-To: <201204072319.q37NJlNp019384@farm-0023.internal.tilera.com>
References: <201204072316.q37NGv8d019280@farm-0023.internal.tilera.com>
	<201204072319.q37NJlNp019384@farm-0023.internal.tilera.com>
Date: Tue, 19 Jun 2012 21:50:54 +0200
X-Google-Sender-Auth: R5wZqFUPxmRRjOyktx93BVxydXU
Message-ID: <CAMuHMdX_XYQLs7gmzYS=dNmXxkQQiU3GBNW5b6EZso9bia5JqQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] arch/tile: tilegx PCI root complex support
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chris Metcalf <cmetcalf@tilera.com>, Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Myron Stowe <myron.stowe@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Jiri Kosina <jkosina@suse.cz>, Joe Perches <joe@perches.com>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

On Sat, Apr 7, 2012 at 11:10 PM, Chris Metcalf <cmetcalf@tilera.com> wrote:
> This change implements PCIe root complex support for tilegx using
> the kernel support layer for accessing the TRIO hardware shim.

> --- /dev/null
> +++ b/arch/tile/kernel/pci_gx.c

> +               bus = pci_scan_bus(0, controller->ops, controller);
> +               controller->root_bus = bus;
> +               controller->last_busno = bus->subordinate;

As of commit 3527ed81ca01bbaf09df952e68528377a9cd092f
("PCI: remove secondary/subordinate in struct pci_bus") in linux-next, the
"subordinate" field no longer exists:

http://kisskb.ellerman.id.au/kisskb/buildresult/6546355/
arch/tile/kernel/pci_gx.c:852:31: error: 'struct pci_bus' has no
member named 'subordinate'
make[3]: *** [arch/tile/kernel/pci_gx.o] Error 1

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
