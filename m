Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751764Ab1DKMle (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 08:41:34 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38485 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab1DKMld convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 08:41:33 -0400
Subject: Re: Q. locking order of dcache_lru_lock
From: Peter Zijlstra <peterz@infradead.org>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
        Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org
In-Reply-To: <9823.1302525232@jrobl>
References: <9769.1302268831@jrobl> <1302369133.2388.1.camel@twins>
	 <29946.1302498571@jrobl> <1302510651.2388.8.camel@twins>
	 <9823.1302525232@jrobl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 11 Apr 2011 14:41:24 +0200
Message-ID: <1302525684.2388.90.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-11 at 21:33 +0900, J. R. Okajima wrote:
> Peter Zijlstra:
> > Not really a problem, locking order is simply a tool/scheme to avoid
> > deadlocks. Since there is no deadlock potential its fine to 'violate'
> > locking order.
> 
> I see.
> Then lockdep always ignore all tyrlocks?

For tracking dependencies, yes. It does register we hold the lock when
the trylock is successful.
