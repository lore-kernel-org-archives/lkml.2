Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab2JDJRi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 05:17:38 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:35228 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab2JDJRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 05:17:35 -0400
Date: Thu, 4 Oct 2012 11:17:29 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Jeff Garzik <jgarzik@pobox.com>,
        Matthew Wilcox <willy@linux.intel.com>, x86@kernel.org,
        linux-pci@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH v3 -tip 1/5] x86, MSI: Support multiple MSIs in presense
 of IRQ remapping
Message-ID: <20121004091729.GA21613@gmail.com>
References: <cover.1349074231.git.agordeev@redhat.com>
 <b15a9b5242c7de5770d2315ea8d13f4dcf63c00b.1349074231.git.agordeev@redhat.com>
 <20121002045518.GA7756@gmail.com>
 <20121002110630.GA2258@dhcp-26-207.brq.redhat.com>
 <20121002112524.GA12420@gmail.com>
 <20121004075442.GD2258@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121004075442.GD2258@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander Gordeev <agordeev@redhat.com> wrote:

> On Tue, Oct 02, 2012 at 01:25:24PM +0200, Ingo Molnar wrote:
> > > > > @@ -584,8 +586,12 @@ int __irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node,
> > > > >  #define irq_alloc_desc_from(from, node)		\
> > > > >  	irq_alloc_descs(-1, from, 1, node)
> > > > >  
> > > > > +#define irq_alloc_descs_from(from, cnt, node)	\
> > > > > +	irq_alloc_descs(-1, from, cnt, node)
> > > > > +
> > > > 
> > > > Please use inlines instead of macros. Might transform the one 
> > > > above it as well in the process.
> > > 
> > > You mean here do not introduce irq_alloc_descs_from, but rather use
> > > irq_alloc_descs() directly?
> > 
> > My suggestion is to add irq_alloc_descs_from() as a (very 
> > simple) inline function and change irq_alloc_desc_from() to be 
> > an inline function as well.
> 
> These defines were added on purpose with commit ec53cf2 ("irq: 
> don't put module.h into irq.h for tracking irqgen modules.") - 
> the relevant hunk is below. I suppose we do not want to revert 
> it?

Sigh - that commit is really making a step backwards, but indeed 
you are probably right that reintroducing the inlines would 
create header dependency problems - which should be addressed in 
another patch.

So I concur with your original approach that added a macro.

Thanks,

	Ingo
