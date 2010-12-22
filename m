Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867Ab0LVRsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 12:48:19 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:21720 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919Ab0LVRsS (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 22 Dec 2010 12:48:18 -0500
Date: Wed, 22 Dec 2010 12:47:28 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jeremy@goop.org" <jeremy@goop.org>, "hpa@zytor.com" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Jan Beulich <JBeulich@novell.com>
Subject: Re: [Xen-devel] [PATCH 07/10] xen/mmu: Work with 1-1 mappings when
 allocating new top/middle entries.
Message-ID: <20101222174728.GA24483@dumpdata.com>
References: <1292967460-15709-1-git-send-email-konrad.wilk@oracle.com>
 <1292967460-15709-8-git-send-email-konrad.wilk@oracle.com>
 <1293008071.3998.41.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293008071.3998.41.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 08:54:31AM +0000, Ian Campbell wrote:
> On Tue, 2010-12-21 at 21:37 +0000, Konrad Rzeszutek Wilk wrote: 
> > We were not properly taking under advisement the 1-1 mappings
> > when a large area of memory was ballooned out.
> 
> Are we lazily allocating the p2m tree nodes for regions initially
> covered by the balloon? (perhaps we have always done this and it isn't
> new with this series)

Before: Yes
Now: Yes.
> 
> Would it be simpley to always populate enough tree nodes to cover the
> ballooned area as well as nr_pages at start of day and therefore avoid
> worrying about it later on (except for memory hotplug which is special
> in this way already)?

Tried that, ran out of reserved_brk space :-) But not sure what
we would gain for this - it is not always guaranteed that we will populate
up to the memory 'maxmem' region.

