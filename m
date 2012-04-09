Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549Ab2DIViT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 17:38:19 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:10287 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755551Ab2DIViR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 17:38:17 -0400
Message-ID: <4F8356C7.60706@tilera.com>
Date: Mon, 9 Apr 2012 17:38:15 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Myron Stowe <myron.stowe@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Joe Perches <joe@perches.com>, David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 3/3] arch/tile: tilegx PCI root complex support
References: <201204072316.q37NGv8d019280@farm-0023.internal.tilera.com> <201204072319.q37NJlNp019384@farm-0023.internal.tilera.com> <201204091359.13059.arnd@arndb.de>
In-Reply-To: <201204091359.13059.arnd@arndb.de>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/9/2012 9:59 AM, Arnd Bergmann wrote:
> On Saturday 07 April 2012, Chris Metcalf wrote:
>> This change implements PCIe root complex support for tilegx using
>> the kernel support layer for accessing the TRIO hardware shim.
>>
>> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
> Hi Chris,
>
> I don't know if we discussed it during the initial merge, but I notice that the PIO
> accessors (inb/outb and friends) are still not implemented in this patch. Normally
> PIO can just be mapped into the MMIO address space, so that inb() becomes
> a call to readb() with an offset on the address.

I asked our PCI expert here, who said, "My understanding is that if someone
wants to use inb/outb to access MMIO space, he'll get the MMIO, as opposed
to methods implemented with I/O instructions which are not supported by
TILE.  If the driver is dependent on the I/O instructions, it won't work on
TILE. These drivers are legacy PC drivers, e.g. ATA devices, which are not
supported by TILE."

Should we just arrange to #include <asm-generic/io.h> to pick up inb/outb
et al?  Any reason to think a non-zero offset should be part of the
solution?  (I don't really understand how inb/outb are used by modern drivers.)

> Using mdelay is generally considered very rude. Since you are not in
> atomic context here, just use msleep() instead.

Done.

Thanks for all your reviews!

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

