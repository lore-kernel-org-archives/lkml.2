Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933185Ab0JRULJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 16:11:09 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:53153 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756004Ab0JRULH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 16:11:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=XPTC0PZNgLHCXSv64v76QljpNKz/EvYp88mR9bwepvexLHDyU1A4SLEZ3ohsCCQUGm6Rsa/u130ygsZBaAzJ0PxpiW8dp1AEs9d/e9KwZpdImMTS02IiO6h2DZMpPoy5;
Date: Mon, 18 Oct 2010 13:10:10 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Ram Pai <linuxram@us.ibm.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, clemens@ladisch.de,
        Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC v2 PATCH 1/1] PCI: override BIOS/firmware resource
 allocation
Message-ID: <20101018131010.0e4771eb@jbarnes-desktop>
In-Reply-To: <201010121301.54402.bjorn.helgaas@hp.com>
References: <20101006225834.GE2945@ram-laptop>
	<201010081416.57454.bjorn.helgaas@hp.com>
	<20101012070515.GA549@ram-laptop>
	<201010121301.54402.bjorn.helgaas@hp.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Oct 2010 13:01:54 -0600
Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> On Tuesday, October 12, 2010 01:05:15 am Ram Pai wrote:
> > On Fri, Oct 08, 2010 at 02:16:57PM -0600, Bjorn Helgaas wrote:
> > > On Friday, October 08, 2010 11:32:24 am Ram Pai wrote:
> > > > On Thu, Oct 07, 2010 at 03:41:04PM -0600, Bjorn Helgaas wrote:
> > > > > On Thursday, October 07, 2010 02:42:13 pm Ram Pai wrote:
> > > > > > On Wed, Oct 06, 2010 at 10:13:02PM -0600, Bjorn Helgaas wrote:
> > > > > > > On Wed, Oct 06, 2010 at 05:30:41PM -0700, Ram Pai wrote:
> > > > > > > > On Wed, Oct 06, 2010 at 05:39:53PM -0600, Bjorn Helgaas wrote:
> > > > > > > > > On Wed, Oct 06, 2010 at 03:58:34PM -0700, Ram Pai wrote:
> > > > > > > > > >         PCI: override BIOS/firmware memory resource allocation
> > > > > > > > > > 		through command line parameters
> > > > > > > > > > 
> > > > > > > > > > 	Platforms that are unaware of  SRIOV  BARs  fail to allocate MMIO
> > > > > > > > > > 	resources  to SRIOV PCIe  devices. Hence  on  such  platforms the
> > > > > > > > > > 	OS fails to  enable  SRIOV.
> > > > > > > > > > 	Some  platforms  where  BIOS/uEFI resource   allocations  conflict
> > > > > > > > > > 	the conflicting devices are disabled.
> > > > > > > > > > 
> > > > > > > > > > 	Ideally we  would  want  the  OS  to detect and fix automatically
> > > > > > > > > > 	such problems and conflicts.  However previous  attempts to do so
> > > > > > > > > > 	have led to regression on legacy platforms.
> > > > > > > > > 
> > > > > > > > > I'm sorry to be a nay-sayer, but I think we just haven't tried hard
> > > > > > > > > enough.  Our ACPI/PCI/e820 resource management is not well integrated,
> > > > > > > > > and I suspect if we straightened that out, we could avoid some of the
> > > > > > > > > regressions we saw with previous attempts.
> > > > > > > > 
> > > > > > > > Can you be more specific as to what can be done to fix it automatically?
> > > > > > > > 
> > > > > > > > Neither accepting this approach nor telling what needs to be straightened out
> > > > > > > > to automatically fix all the systems out there, is just a deadend.
> > > > > > > 
> > > > > > > Yeah, I guess that wasn't really fair, sorry.  And keep in mind that I'm
> > > > > > > not the PCI maintainer, so these are just my opinions, nothing like an
> > > > > > > official "nack."
> > > > > > > 
> > > > > > > I did look at this dmesg log from the thread you referenced:
> > > > > > >     http://marc.info/?l=linux-kernel&m=127178918128740&w=2
> > > > > > > but it looks to me like we just completely botched it.  I don't see an
> > > > > > > SRIOV device or anything else that didn't have resources, so as far as I
> > > > > > > can tell, we started with working resource assignments from the BIOS,
> > > > > > > threw them away, and started over from scratch.  We failed because we
> > > > > > > tried to assign I/O port space to bridges with nothing behind them, and
> > > > > > > there was nothing left by the time we got to the 0000:09:04.0 device
> > > > > > > that actually *did* need the space.
> > > > > > 
> > > > > > hmm.. is that possible? Yinghai's patch sized the resource requirement of each
> > > > > > of the bridges, before actually allocating them. Which means a bridge with
> > > > > > no device behind it would not get any i/o space.
> > > > > 
> > > > > Here's what I see in the dmesg log referenced above:
> > > > > 
> > > > >     ACPI: PCI Root Bridge [PCI0] (0000:00)
> > > > >     pci_root PNP0A08:00: host bridge window [io 0x0000-0x0cf7]
> > > > >     pci_root PNP0A08:00: host bridge window [io 0x0d00-0xffff]
> > > > >     pci 0000:00:1c.0: PCI bridge to [bus 04-09]
> > > > >     pci 0000:00:1c.0:   bridge window [io 0xd000-0xdfff]
> > > > >     pci 0000:04:00.0: PCI bridge to [bus 05-09]
> > > > >     pci 0000:04:00.0:   bridge window [io 0xd000-0xdfff]
> > > > >     pci 0000:05:01.0: PCI bridge to [bus 08-09]
> > > > >     pci 0000:05:01.0:   bridge window [io 0xd000-0xdfff]
> > > > >     pci 0000:08:00.0: PCI bridge to [bus 09-09]
> > > > >     pci 0000:08:00.0:   bridge window [io 0xd000-0xdfff]
> > > > >     pci 0000:09:04.0: found [13f6:8788] class 000401 header type 00
> > > > >     pci 0000:09:04.0: reg 10: [io  0xd800-0xd8ff]
> > > > >     pci 0000:05:02.0: PCI bridge to [bus 07-07]
> > > > >     pci 0000:05:02.0:   bridge window [io 0xf000-0x0000] (disabled)
> > > > >     pci 0000:05:03.0: PCI bridge to [bus 06-06]
> > > > >     pci 0000:05:03.0:   bridge window [io 0xf000-0x0000] (disabled)
> > > > >     
> > > > > The above is the state as we got it from BIOS.  Despite all the bridges,
> > > > > 09:04.0 is the only device below the 00:1c.0 bridge, and it requires only
> > > > > 0x100 I/O ports.
> > > > > 
> > > > > There are no devices on buses 06 (below 05:03.0) or 07 (below 05:02.0).
> > > > > 
> > > > > I didn't look at Yinghai's patch to figure out *why*, but it sure looks like
> > > > > we released the 09:04.0 space, then tried to assign 0x2000 ports to 05:01.0 
> > > > > (which needs 0x100 and had 0x1000 originally), 0x1000 to 05:02.0 (which needs
> > > > > none), and 0x1000 to 05:03.0 (which also needs none):
> > > > > 
> > > > >     PCI: No. 3 try to assign unassigned res
> > > > >     release child resource [io  0xd800-0xd8ff]
> > > > >     pci 0000:08:00.0: resource 7 [io 0xd000-0xdfff] released
> > > > >     pci 0000:04:00.0: BAR 7: can't assign io (size 0x4000)
> > > > >     pci 0000:05:01.0: BAR 7: can't assign io (size 0x2000)
> > > > >     pci 0000:05:02.0: BAR 7: can't assign io (size 0x1000)
> > > > >     pci 0000:05:03.0: BAR 7: can't assign io (size 0x1000)
> > > > >     pci 0000:08:00.0: BAR 7: can't assign io (size 0x1000)
> > > > 
> > > > Actually the message preceeding to them  are even more surprising:
> > > > 
> > > > Apr 20 20:31:42 [kernel] pci 0000:04:00.0: BAR 8: can't assign mem (size
> > > > 0xc00000)
> > > > Apr 20 20:31:42 [kernel] pci 0000:05:01.0: BAR 8: can't assign mem (size
> > > > 0x200000)
> > > > Apr 20 20:31:42 [kernel] pci 0000:05:01.0: BAR 9: can't assign mem pref
> > > > (size 0x200000)
> > > > Apr 20 20:31:42 [kernel] pci 0000:05:02.0: BAR 8: can't assign mem (size
> > > > 0x400000)
> > > > Apr 20 20:31:42 [kernel] pci 0000:05:03.0: BAR 7: can't assign io (size
> > > > 0x1000)
> > > > 
> > > > Do these bridges have IOV BARs and those BARs are demanding i/o resources?
> > > > Something is really funny with this machine. Or I am reading this wrong?
> > > 
> > > I don't see anything strange about the machine, but I don't understand
> > > what Yinghai's patch was doing.  The lspci output is here:
> > >     http://marc.info/?l=linux-pci&m=127184080929189&w=2
> > > 
> > > I don't see any SRIOV devices, and this kernel wasn't built with IOV
> > > support anyway.  The messages above are attempts to assign resources
> > > for bridge windows.
> > > 
> > > But the only real device in the whole hierarchy behind 00:1c.0
> > > is 09:04.0, which doesn't require memory space, so I have no idea
> > > why we're trying to open memory windows.
> > 
> > I dont understand the code much. But there is some alignment 
> > constraints on the memory and io space dictated by the PCI code in 
> > pbus_size_io() and pbus_size_mem(), a constraint that ends up 
> > associating a minimum of 4096 bytes io window and 
> > nearly about 2MB mem window to a bridge irrespective of the 
> > requirements of the devices behind the bridge. That sounds like a
> > bug to me. But I don't know if those are valid constraints either.
> > Any idea?
> 
> I think memory windows comes in 1MB chunks and I/O in 4096 port chunks.
> There are some bridges that support smaller I/O windows (search for
> "en1k" in drivers/pci/quirks.c), but it looks like we don't take that
> into account when allocating space.
> 
> And of course, there's no requirement to enable the window at all if
> we don't have any downstream devices.
> 
> > > This is what I meant about "we haven't tried hard enough yet."  I'd
> > > rather spend time fixing the problems like this, than just putting the
> > > buggy code in and adding a kernel parameter to enable it.  That
> > > guarantees that we'll never get enough testing to really shake it
> > > out.
> > 
> > Ok. I am no fan of kernel parameters either. However I am afraid 
> > we will attract furious looks as and when someone regresses. 
> 
> Yep, I'm used to that :-)

So where do we stand with this machine's problem?

Ram, do you have other machines that require your override patch?

Until we understand what's failing and why, I'm hesitant to apply a
patch that will work around the problem but require an extra kernel
parameter.

Our general approach is to avoid overwriting the BIOS provided
configuration, and when we do, to use available e820 and PnP data to
figure out where to put things, in addition to allocating space in a
similar way to Windows to avoid hitting undiscovered platform bugs
(i.e. Bjorn's recent patchset).

So while I'm not totally opposed to this patch, I'd feel much better
about it if we really understood how the failing machines were failing
before we try to workaround potential BIOS limitations.

-- 
Jesse Barnes, Intel Open Source Technology Center
