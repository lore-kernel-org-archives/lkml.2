Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750990Ab1FGFnE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 01:43:04 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:49264 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835Ab1FGFnB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 01:43:01 -0400
Date: Tue, 7 Jun 2011 07:42:56 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Joe Perches <joe@perches.com>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>, cocci <cocci@diku.dk>,
        vinod.koul@intel.com, dan.j.williams@intel.com,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Cocci] [RFC] Convert "resource->end - resource->start + 1" to
 resource_size(resource) via coccinelle
In-Reply-To: <1307424738.1651.7.camel@Joe-Laptop>
Message-ID: <Pine.LNX.4.64.1106070741510.18329@ask.diku.dk>
References: <201106061349.00474.hartleys@visionengravers.com> 
 <1307397174.4994.26.camel@Joe-Laptop>  <Pine.LNX.4.64.1106070706000.18329@ask.diku.dk>
 <1307424738.1651.7.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Jun 2011, Joe Perches wrote:

> On Tue, 2011-06-07 at 07:07 +0200, Julia Lawall wrote:
> > On Mon, 6 Jun 2011, Joe Perches wrote:
> > > Perhaps do a treewide update via:
> > > $ cat resource.cocci
> > > @@
> > > struct resource *ptr;
> > > @@
> > > - ptr->end - ptr->start + 1
> > > + resource_size(ptr)
> > > $ spatch -sp_file resource.cocci linux-2.6/
> > There might be some cases that have the +1 in a different place, or that 
> > have some parentheses.
> > I suspect that a lot of these non-uses of resource_size still exist.
> 
> True enough.
> 
> Cocci already handles the parens case
> "(foo->end-foo->start)+1"

If you put parentheses, it will consider removing them.  But I don't think 
it would go the other way around.

julia

> There are some uses of end+1-start and
> 1+end-start that weren't converted by
> the patch I sent.

