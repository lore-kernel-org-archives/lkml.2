Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001Ab1GUSOG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 14:14:06 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:48548 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab1GUSOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 14:14:02 -0400
Date: Thu, 21 Jul 2011 22:13:00 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Christoph Lameter <cl@linux.com>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Greg Kroah-Hartman <gregkh@suse.de>, Al Viro <viro@zeniv.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC v3 2/5] slab: implement slab object boundaries assertion
Message-ID: <20110721181300.GA23960@albatros>
References: <1311252815-6733-1-git-send-email-segoon@openwall.com>
 <alpine.DEB.2.00.1107211127050.3995@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1107211127050.3995@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 21, 2011 at 11:28 -0500, Christoph Lameter wrote:
> On Thu, 21 Jul 2011, Vasiliy Kulikov wrote:
> 
> > +bool slab_access_ok(const void *ptr, unsigned long len)
> > +{
> > +	struct page *page;
> > +	struct kmem_cache *s = NULL;
> 
> Useless assignment.
> 
> > +	unsigned long offset;
> > +
> > +	if (!virt_addr_valid(ptr))
> > +		return true;
> > +	page = virt_to_head_page(ptr);
> > +	if (!PageSlab(page))
> > +		return true;
> > +
> > +	s = page->slab;
> > +	offset = (ptr - page_address(page)) % s->size;
> > +	if (offset <= s->objsize && len <= s->objsize - offset)
> > +		return true;
> 
> I thought this was going to be offset < s->objectsize ...?

Looks like I did these 2 things in SLAB only, left SLUB untouched.
Will fix, thanks.

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
