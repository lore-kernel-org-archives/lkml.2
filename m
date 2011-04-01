Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867Ab1DAPk6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 11:40:58 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:58014 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab1DAPk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 11:40:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH 0/1] new module for amba axi on-chip interconnect
Date: Fri, 1 Apr 2011 17:40:11 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, gregkh@suse.de,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arend van Spriel <arend@broadcom.com>, devel@linuxdriverproject.org,
        akpm@linux-foundation.org
References: <1301391619-4499-1-git-send-email-arend@broadcom.com> <201103302024.49921.arnd@arndb.de> <20110330190857.GC2939@n2100.arm.linux.org.uk>
In-Reply-To: <20110330190857.GC2939@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104011740.11236.arnd@arndb.de>
X-Provags-ID: V02:K0:ungQE/gAcaP9+LTBlBeqJHMKry8T8OFk9xrggVMy9uo
 ndeVngg/pSTKKKAPQHuWSxfc/R2jZLkbODYlLFttbJ5ogOKqPJ
 JwvywiyPxu0WIioL9zeIElW6LLZ4tdErvGMz3CJAR54Rp5Q50+
 aS8CLI/egjao2vMhgTjIl2c55UYZx2/HxAk8CYS4DX8+3lybzS
 CMqVfKM/TuYU7X15BCxwA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 March 2011, Russell King - ARM Linux wrote:
> On Wed, Mar 30, 2011 at 08:24:49PM +0200, Arnd Bergmann wrote:
> > On Wednesday 30 March 2011 19:40:10 Russell King - ARM Linux wrote:
> > 
> > > The reason we don't do automatic scanning (which we could on the various
> > > ARM platforms) is because of the platform data necessary to make some of
> > > the primecell drivers work.
> > > 
> > > Unfortunately, these buses are not as simple as PCI, where a device
> > > typically sits on its own card and is totally self-contained.  With
> > > primecell stuff, there's normally some interdependencies between the
> > > various primecells.
> > > 
> > > That doesn't stop there being an automatic enumeration layer, but such
> > > a layer would need some way of attaching platform specific data to
> > > specific amba devices.
> > 
> > Right, I understand that this would not completely remove the need for
> > platform devices, but I think it would be a great step in the right
> > direction if we could scan all simple devices automatically, or
> > possibly even all devices in some simple machines.
> 
> I'm not talking about platform devices at all.  I'm talking about the data
> which platforms need to supply to their drivers in order for the drivers
> to work.

Yes, I meant platform_data, not platform_device.

> This kind of data is precisely why I went down the static declaration
> route for all ARM dev platforms, despite most devices being trivially
> discoverable.  I couldn't work out a decent way to automatically scan
> the devices while ensuring that the right platform specific driver data
> was attached to its correct device.

Maybe we can look at this again. The device tree scanning code 
is able to connect properties from the device tree to e.g. PCI
devices that are probed from hardware. It may not be easy to
do, but my feeling is that there is a lot to gain if we manage
to do it.
 
> > The device tree work has shown that it's possible to describe very
> > complex hardware in simple data structures, but it would be much
> > better if we needed neither a device tree nor a board file for this.
> 
> The device tree goes against automatic device discovery - unless you
> have a shim which runs before the kernel executes to adjust the device
> tree appropriately.  Otherwise, I can't see anyway you could cope with
> (eg) a platform having MMC controllers at 0x10004000 and 0x10008000,
> and another with just one MMC controller at 0x10008000 but using the
> card detect lines from 0x10004000.

The device tree is just another way to do automatic device discovery.
Fundamentally there is not much difference between reading data in
a fixed format from a PCI config space, a hardware ROM on AMBA or
a blob passed into the kernel.

The disadvantage of the device tree is that it's harder to get it
to match the actual hardware, while the advantage is that it's
flexible enough to describe the example you just gave.

As I mentioned above, it's possible to describe devices in the
device tree format that are also detected from hardware
scanning, and to combine information from both sources.

If the information in the hardware is complete, as is usually
the case on PCI or USB buses, the device trees we use on other
architectures only list the root node of a bus that gets scanned
in hardware.

> > I remember PCI cards
> > from the 1990s that could not be probed properly and required
> > setting a lot of module parameters copied from a web site depending
> > on what hardware you had bought. The reason we don't have that 
> > as much today is that the manufacturers realized that it's impossible
> > to write proper drivers if you cannot detect the hardware.
> 
> I think you're going to be waiting a very long time for that to happen.
> No SoC vendor adds device IDs to their on-chip devices to allow them to
> be automatically discovered - it's only through ARM Ltd's development of
> their Primecells, and then vendors integrating those into their SoC (maybe
> with their own modifications) that we've started to see this kind of ID
> system appearing.
> 
> Outside of the Primecell stuff, I'm unaware of anyone adding any kind
> of discovery mechanism to SoC based devices.

I'm willing to try to keep pushing for it, once I figure out where ;-)

If we have support for automatic probing of some devices in the kernel,
that might be a way to convince hardware vendors that simply putting
correct information in the hardware can improve their time to market,
which directly translates into money.

	Arnd
