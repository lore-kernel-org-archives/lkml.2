Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759024Ab0FRUT7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 16:19:59 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:47030 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753887Ab0FRUT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 16:19:58 -0400
Date: Fri, 18 Jun 2010 16:19:53 -0400
From: Andres Salomon <dilinger@queued.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
       Mitch Bradley <wmb@laptop.org>
Subject: Re: [PATCH] x86: OLPC: add support for calling into OpenFirmware
 (v5)
Message-ID: <20100618161953.4a72a126@dev.queued.net>
In-Reply-To: <4C1BCDD5.5040805@zytor.com>
References: <20100618154245.2e00af2a@dev.queued.net>
	<4C1BCDD5.5040805@zytor.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.12.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jun 2010 12:49:41 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 06/18/2010 12:42 PM, Andres Salomon wrote:
> > +
> > +	/* install OFW's PDE permanently into the kernel's pgtable
> > */
> > +	set_pgd(&swapper_pg_dir[OLPC_OFW_PDE_NR], *ofw_pde);
> > +	flush_tlb();
> > +	early_iounmap(base, sizeof(olpc_ofw_pgd) * PTRS_PER_PGD);
> 
> I just realized... this flush_tlb() is actually not necessary since on
> x86 it is always legal to go from a less permissive configuration to a
> more permissive, and the initial configuration is "not present" which
> is maximally nonpermissive.
> 
> Could you take it out and make sure it still works?
> 
> 	-hpa

Yep, seems to work fine w/out it.  Anything else before I send off v6
of the patch?
