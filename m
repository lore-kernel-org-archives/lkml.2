Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962Ab1DKIbE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 04:31:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34070 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462Ab1DKIbC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 04:31:02 -0400
Subject: Re: Q. locking order of dcache_lru_lock
From: Peter Zijlstra <peterz@infradead.org>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
        Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org
In-Reply-To: <29946.1302498571@jrobl>
References: <9769.1302268831@jrobl> <1302369133.2388.1.camel@twins>
	 <29946.1302498571@jrobl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 11 Apr 2011 10:30:51 +0200
Message-ID: <1302510651.2388.8.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-11 at 14:09 +0900, J. R. Okajima wrote:
> Peter Zijlstra:
> > On Fri, 2011-04-08 at 22:20 +0900, J. R. Okajima wrote:
> > >=20
> > > When spin_trylock(&dentry->d_lock) successfully acquired d_lock, does
> > > the violation of locking order happen (or a deadlock, in worse case)?=20
> >
> > No, since a trylock never actually blocks a deadlock cannot occur.
> 
> Ah, exactly. I had to be sleeping when I wrote about deadlock.
> How about the locking order? Do you think d_lock after dcache_lru_lock
> is a problem?

Not really a problem, locking order is simply a tool/scheme to avoid
deadlocks. Since there is no deadlock potential its fine to 'violate'
locking order.

This is a common pattern with trylocks. In situations where you would
need somewhat expensive lock operations to grab the locks in the right
order, you can trylock to see if you can get them in the wrong order. If
the trylock succeeds, yay! you got it cheap. If not, bummer, and you
have to try the expensive way.


