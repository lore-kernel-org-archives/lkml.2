Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107Ab1LTP4h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 10:56:37 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:52205 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab1LTP4Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 10:56:16 -0500
MIME-Version: 1.0
In-Reply-To: <1318607132.3018.30.camel@dabdike.int.hansenpartnership.com>
References: <20111014042142.23504.70417.stgit@bhelgaas.mtv.corp.google.com>
 <1318605254.3018.20.camel@dabdike.int.hansenpartnership.com>
 <CAErSpo7d3hHeJU87zYo=yJoG3eqOZ4QggkOyNnu7xuJe8oG9Qg@mail.gmail.com> <1318607132.3018.30.camel@dabdike.int.hansenpartnership.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 20 Dec 2011 08:55:53 -0700
Message-ID: <CAErSpo7yoWOg8P1NAi70HJX=OMyO6XUwnUBxVq3P0YK87eP5tw@mail.gmail.com>
Subject: Re: [PATCH v2 00/29] Create PCI root buses with correct resources
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 9:45 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Fri, 2011-10-14 at 09:33 -0600, Bjorn Helgaas wrote:
>> On Fri, Oct 14, 2011 at 9:14 AM, James Bottomley
>> <James.Bottomley@hansenpartnership.com> wrote:
>> > On Thu, 2011-10-13 at 22:27 -0600, Bjorn Helgaas wrote:
>> >> The most generic way to create a PCI root bus is with pci_scan_bus(), but
>> >> that doesn't allow you to specify what resources are available on the bus,
>> >> i.e., what the host bridge apertures are.
>> >
>> > Do you have an actual tree for this?  The PARISC pieces look a bit
>> > non-trivial and I'd like to test them out on the various sba/astro/dino
>> > systems.
>>
>> I don't yet, but it'd be great if you were willing to test them out,
>> so I'll set one up.
>>
>> While this is on your mind, I'm dubious about the pci_enable_bridges()
>> call in lba_driver_probe() and the pci_bus_assign_resources() call in
>> dino_probe().  These stand out as exceptions because no other arches
>> do that.
>>
>> If they weren't there, both places could use pci_scan_root_bus() like
>> most other arches.
>
> Right, the dino code actually has to rearrange some of the PCI resources
> to make sure we get our apertures correct.  That's the specific bit I
> was planning to test.  I think it's only relevant for dino SBA cards
> where the bridge doesn't set up the card correctly so we have to do it
> after the fact.

This series has been in linux-next for a while now (via Jesse's PCI
tree), so this would be a good time to try it out if you haven't
already.

I know ia64 has been exercised a bit (thanks, Tony), but I haven't
heard anything about arm, mips, parisc, powerpc, sparc, etc.

There is one outstanding bug fix for alpha that Jesse hasn't
integrated yet, but as far as I know, everything else is in good
shape.

Bjorn
