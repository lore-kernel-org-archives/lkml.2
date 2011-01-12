Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132Ab1ALQxh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 11:53:37 -0500
Received: from relais.videotron.ca ([24.201.245.36]:28771 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214Ab1ALQxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 11:53:35 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Wed, 12 Jan 2011 11:53:31 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>
Subject: Re: [RFC] arm: Defer lookup of machine_type and vet of atags to setup.c
In-reply-to: <AANLkTinwGd9pa7YQ=5hXfarw=MB=YdpBuN7xJAd+Ps4f@mail.gmail.com>
Message-id: <alpine.LFD.2.00.1101121145430.24532@xanadu.home>
References: <20110111015409.18291.87166.stgit@localhost6.localdomain6>
 <20110111104051.GA11039@n2100.arm.linux.org.uk>
 <20110111153630.GB2707@angua.secretlab.ca>
 <20110111154833.GF11039@n2100.arm.linux.org.uk>
 <AANLkTi=29LB66j123ufMHQk=46hGYdmR4nZZQFnN=Tku@mail.gmail.com>
 <20110112155215.GB11039@n2100.arm.linux.org.uk>
 <AANLkTinwGd9pa7YQ=5hXfarw=MB=YdpBuN7xJAd+Ps4f@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Jan 2011, Grant Likely wrote:

> Actually it looks like the real problem is that the mmu has been
> turned on, but the virtual mappings for devices have not yet been
> established, and so the debug macros aren't using a valid address.

A temporary virtual mapping should be there -- look for addruart in 
head.S.

> I'm using printk to get output into the ring buffer in my patch to
> rework lookup_machine_type() in C, and that does indeed output to the
> ring buffer, but the kernel cannot spit stuff out the serial port.
> 
> It looks like I'd need to get past paging_init() in order to get
> ll_debug working between turning on the mmu and paging_init(), but
> paging_init() needs the mdesc pointer, and the whole point of the
> error message is that the mdesc pointer is unknown!  I don't see any
> code that sets up a debug mapping of the uart before paging_init time.

See above.

>  I could try to implement something like that, but it is looking to be
> more complicated than it is worth when the current code works just
> fine.

My bet is that there is a bug with the current code that you are 
exposing.

> Let me know if I've missed something, but I think I should drop the
> removal of __lookup_machine_type from head.S from my patch.

It's not the location of that code which is a problem.  Even if you 
leave that code in place, you want to call it later and I bet that the 
display would be broken even if __lookup_machine_type doesn't move.


Nicolas
