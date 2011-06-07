Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750885Ab1FGFcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 01:32:21 -0400
Received: from mail.perches.com ([173.55.12.10]:2588 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705Ab1FGFcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 01:32:20 -0400
Subject: Re: [Cocci] [RFC] Convert "resource->end - resource->start + 1" to
 resource_size(resource) via coccinelle
From: Joe Perches <joe@perches.com>
To: Julia Lawall <julia@diku.dk>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>, cocci <cocci@diku.dk>,
        vinod.koul@intel.com, dan.j.williams@intel.com,
        Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1106070706000.18329@ask.diku.dk>
References: <201106061349.00474.hartleys@visionengravers.com>
	 <1307397174.4994.26.camel@Joe-Laptop>
	 <Pine.LNX.4.64.1106070706000.18329@ask.diku.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Jun 2011 22:32:18 -0700
Message-ID: <1307424738.1651.7.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-07 at 07:07 +0200, Julia Lawall wrote:
> On Mon, 6 Jun 2011, Joe Perches wrote:
> > Perhaps do a treewide update via:
> > $ cat resource.cocci
> > @@
> > struct resource *ptr;
> > @@
> > - ptr->end - ptr->start + 1
> > + resource_size(ptr)
> > $ spatch -sp_file resource.cocci linux-2.6/
> There might be some cases that have the +1 in a different place, or that 
> have some parentheses.
> I suspect that a lot of these non-uses of resource_size still exist.

True enough.

Cocci already handles the parens case
"(foo->end-foo->start)+1"

There are some uses of end+1-start and
1+end-start that weren't converted by
the patch I sent.


