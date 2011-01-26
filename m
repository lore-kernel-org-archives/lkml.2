Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012Ab1AZUAS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 15:00:18 -0500
Received: from smtp-out.google.com ([74.125.121.67]:19457 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843Ab1AZUAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 15:00:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=UatIJsBfdf7EDSXaM0gOrEamdLUtGrJWpdk+oKF5VTwhgUZl8wKT69hyJBuRSjJSHJ
         vPPhMG5EMJCwNSOpeuEQ==
Date: Wed, 26 Jan 2011 12:00:08 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Ralf Baechle <ralf@linux-mips.org>, Kyle McMartin <kyle@redhat.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Randy Dunlap <randy.dunlap@oracle.com>, x86@kernel.org,
        linux-arch@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] kconfig: unify GENERIC_ISA_DMA and ISA_DMA_API
In-Reply-To: <20110126112908.GD2562@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.00.1101261158490.13163@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1101251706040.9641@chino.kir.corp.google.com> <20110126112908.GD2562@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Jan 2011, Russell King - ARM Linux wrote:

> On Tue, Jan 25, 2011 at 05:06:28PM -0800, David Rientjes wrote:
> > CONFIG_GENERIC_ISA_DMA and CONFIG_ISA_DMA_API usually have dependencies
> > on one another depending on the architecture and generic kernel code uses
> > either to determine whether an ISA-style DMA API is configured.
> 
> Wrong.
> 
> GENERIC_ISA_DMA enables support for the standard ISA DMA allocator found
> in kernel/dma.c
> 
> ISA_DMA_API says that a platform supports the ISA DMA interfaces.
> 
> An architecture can provide the ISA DMA interfaces, but not use the
> standard ISA DMA allocator found in kernel/dma.c.  Such as the one in
> arch/arm/kernel/dma.c.
> 
> So on ARM, we have platforms where ISA_DMA_API=y but GENERIC_ISA_DMA=n.
> 

Ok, fair enough.  Thanks for pointing that out.  I'll work to resolve the 
existing dependency chain on x86 that cause build failures when one is 
disabled and another is not and add Kconfig dependencies on drivers that 
require GENERIC_ISA_DMA.
