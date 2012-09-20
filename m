Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432Ab2ITWXN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 18:23:13 -0400
Received: from gate.crashing.org ([63.228.1.57]:48331 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756375Ab2ITWXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 18:23:09 -0400
Message-ID: <1348179764.1132.35.camel@pasglop>
Subject: Re: linux-next: build failure after merge of the final tree
 (net-next tree related)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        David Miller <davem@davemloft.net>, mika.westerberg@linux.intel.com,
        netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 21 Sep 2012 08:22:44 +1000
In-Reply-To: <20120921081531.67db8a7d0ac1b35426b22c45@canb.auug.org.au>
References: <20120920173622.2aa7209cd241a3945f4384d4@canb.auug.org.au>
	 <20120920091013.GV15548@intel.com>
	 <20120920.164558.2281417114805373564.davem@davemloft.net>
	 <20120921081531.67db8a7d0ac1b35426b22c45@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > I think the powerpc port is at fault here.
> > 
> > Part of being able to advertise ISA_DMA_API is providing isa_virt_to_bus().

Hrm, that's ancient gunk, I'll have to dig. We potentially can support
ISA devices DMA'ing from an ISA bridge... but via the iommu, which means
isa_virt_to_bus is a non-starter.

But then, do we really care ? IE. Is there single device that actually
requires ISA_DMA_API and that is expected to work on any currently
supported powerpc hw ? :-)

We don't even support PReP anymore, so that leaves us with what ?

Anybody has an objection to turning ISA_DMA_API off ?

Cheers,
Ben.


