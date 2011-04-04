Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751057Ab1DDX6d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 19:58:33 -0400
Received: from gate.crashing.org ([63.228.1.57]:46585 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906Ab1DDX6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 19:58:21 -0400
Subject: Re: [RFC/PATCH] of: Match PCI devices to OF nodes generically
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-arch@vger.kernel.org, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
In-Reply-To: <BANLkTimBD=NfFKGpy0ZTnT9Dcu=dkTHxZg@mail.gmail.com>
References: <1301882694.2549.53.camel@pasglop>
	 <1301887630.2549.71.camel@pasglop> <1301902664.2549.76.camel@pasglop>
	 <BANLkTimBD=NfFKGpy0ZTnT9Dcu=dkTHxZg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Apr 2011 09:58:08 +1000
Message-ID: <1301961488.2549.105.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-04 at 09:25 -0600, Bjorn Helgaas wrote:
> Some of this is reminiscent of the ACPI/PCI binding we do on x86/ia64,
> e.g., acpi_get_pci_dev() and the stuff in drivers/acpi/glue.c.  Have
> you looked at that to see if there's any hope of covering both OF and
> ACPI with something more generic?

Hrm, the ACPI stuff is quite different (to some extent akin to what
power used to do) form what I can tell. You basically traverse the ACPI
tree do perform a matching after the fact.

The idea with my patch is really to populate things as they get
discovered, which makes the code much simpler. Since we have the pointer
to the OF device node in the generic struct device nowadays, if we
populate things that way, by the time we discover a device we already
have at hand the OF device node of the parent bus, so it's a
single/simpler one level search to locate the device itself and populate
it's node as well, done once for all.

I suppose you could do something similar for ACPI, but I wouldn't try to
make a "common infrastructure" at that point, especially since there is
the possibility on x86 to have both OF device-trees and ACPI :-)

Note that I don't really provide a direct/good equivalent of your
acpi_get_pci_dev() ... the matching is mostly used the other way around,
ie a driver for a pci_dev wanting to peek a some properties in the
corresponding OF device_node. ppc32 has some reverse mapping stuff but
it's pretty crappy (and on my to-fixup list for after that patch goes
in) and in fact it would be reasonably easy from now on to implement it
as well, but so far there is no real demand.

Cheers,
Ben.


