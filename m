Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab0HXSxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 14:53:41 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:23607 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752871Ab0HXSxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 14:53:39 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: FDEoHe4VM1mOmFFSZIFnh.RdDwiXGgoHyWqbn5ajyZEGX5Q
 kXEwghRhvA8P9Dl9Vrwik6GkCLIz13ZuG7BTM7SOBDg8h9XDhUZU3XNZcvHx
 QvY5ph.2v9QKOwrls1lsjONSFOda3KJqVx7tra7ZExAJo4WhyH5.jTHOpR7F
 ZPMZZ12jn.2ZtFCcqEMugQ5B97sBOnHlppTvwAiz.OaRrYHhkl_2ghgaYZEF
 W
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 24 Aug 2010 13:53:35 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: linux-next: build failure after merge of the final tree (slab
 tree related)
In-Reply-To: <4C741029.7090300@cs.helsinki.fi>
Message-ID: <alpine.DEB.2.00.1008241352240.5388@router.home>
References: <20100824120714.8918f8de.sfr@canb.auug.org.au> <4C740450.3030000@cs.helsinki.fi> <alpine.DEB.2.00.1008241256280.4763@router.home> <4C741029.7090300@cs.helsinki.fi>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Aug 2010, Pekka Enberg wrote:

> On 24.8.2010 20.59, Christoph Lameter wrote:
> > On Tue, 24 Aug 2010, Pekka Enberg wrote:
> >
> > > Thanks for the report. The problem should be fixed by this commit:
> >
> > Its not that easy. __alloc_percpu falls back to kzalloc() on UP and this
> > can result in unique bootstrap problems with UP since the bootstrap array
> > is no longer there. Does the UP kernel boot?
>
> No, I get this under kvm:

> [    0.000000] Kernel panic - not syncing: Cannot create slab kmem_cache
> size=232 realsize=256 order=0 offset=0 flags=42000

alloc per cpu result in kmalloc which fails.

Tejon: Is there some way we could get a reserved per cpu area under UP
instead of fallback to slab allocations during bootup?
