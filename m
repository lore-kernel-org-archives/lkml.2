Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932657Ab1KOWpJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 17:45:09 -0500
Received: from gate.crashing.org ([63.228.1.57]:50028 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932629Ab1KOWpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 17:45:05 -0500
Message-ID: <1321397030.3170.15.camel@pasglop>
Subject: Re: [PATCH -v2 00/16] PCI: Re-factor PCI's 'latency timer' setup
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Myron Stowe <myron.stowe@redhat.com>, linux-pci@vger.kernel.org,
        linux@arm.linux.org.uk, vapier@gentoo.org, dhowells@redhat.com,
        ysato@users.sourceforge.jp, tony.luck@intel.com, fenghua.yu@intel.com,
        monstr@monstr.eu, ralf@linux-mips.org, paulus@samba.org,
        lethal@linux-sh.org, davem@davemloft.net, cmetcalf@tilera.com,
        gxt@mprc.pku.edu.cn, tglx@linutronix.de, mingo@redhat.com,
        chris@zankel.net, linux-kernel@vger.kernel.org
Date: Wed, 16 Nov 2011 09:43:50 +1100
In-Reply-To: <20111111095930.22abd773@jbarnes-desktop>
References: <20111028214726.20088.30551.stgit@amt.stowe>
	 <20111111095930.22abd773@jbarnes-desktop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-11 at 09:59 -0800, Jesse Barnes wrote:
> On Fri, 28 Oct 2011 15:47:26 -0600
> Myron Stowe <myron.stowe@redhat.com> wrote:
> 
> > The 'latency timer' of PCI devices, both Type 0 and Type 1,
> > is setup in architecture-specific code [see: pcibios_set_master()].
> > There are two approaches being taken by all the architectures - check
> > if the 'latency timer' is currently set between 16 and 255 and if not
> > bring it within bounds, or, do nothing (and then there is the
> > gratuitously different parisc implementation).
> > 
> > There is nothing architecture-specific about PCI's 'latency timer' so
> > this patch pulls the setup functionality up into the PCI core by
> > creating a generic 'pcibios_set_master()' function using the '__weak'
> > attribute which can be used by all architectures as a default which,
> > if necessary, can then be over-ridden by architecture-specific code.
> 
> I have acks from Chris, Ralf, and Mike.  Any other arch maintainers
> want to ack or nack this before it goes into my -next branch?

I somewhat missed the original patch. As long as it's a nop for ppc, I
don't care tho :-)

Cheers,
Ben.


