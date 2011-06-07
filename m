Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432Ab1FGFHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 01:07:42 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:34913 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752242Ab1FGFHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 01:07:41 -0400
Date: Tue, 7 Jun 2011 07:07:35 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Joe Perches <joe@perches.com>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>, cocci <cocci@diku.dk>,
        vinod.koul@intel.com, dan.j.williams@intel.com,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Cocci] [RFC] Convert "resource->end - resource->start + 1" to
 resource_size(resource) via coccinelle
In-Reply-To: <1307397174.4994.26.camel@Joe-Laptop>
Message-ID: <Pine.LNX.4.64.1106070706000.18329@ask.diku.dk>
References: <201106061349.00474.hartleys@visionengravers.com>
 <1307397174.4994.26.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Jun 2011, Joe Perches wrote:

> On Mon, 2011-06-06 at 13:49 -0700, H Hartley Sweeten wrote:
> > Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> > Cc: Dan Williams <dan.j.williams@intel.com> (supporter:ASYNCHRONOUS TRAN...)
> > Cc: Vinod Koul <vinod.koul@intel.com> (supporter:DMA GENERIC OFFLO...)
> 
> Perhaps do a treewide update via:
> 
> $ cat resource.cocci
> @@
> struct resource *ptr;
> @@
> 
> - ptr->end - ptr->start + 1
> + resource_size(ptr)
> 
> $ spatch -sp_file resource.cocci linux-2.6/

There might be some cases that have the +1 in a different place, or that 
have some parentheses.

I suspect that a lot of these non-uses of resource_size still exist.

julia
