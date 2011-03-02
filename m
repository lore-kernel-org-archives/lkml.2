Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507Ab1CBJsv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 04:48:51 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54406 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756431Ab1CBJsu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 04:48:50 -0500
Subject: Re: [PATCH] mm: prevent concurrent unmap_mapping_range() on the
 same inode
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
        hch@infradead.org, gurudas.pai@oracle.com,
        lkml20101129@newton.leun.net, rjw@sisk.pl, florian@mickler.org,
        trond.myklebust@fys.uio.no, maciej.rutecki@gmail.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <alpine.LSU.2.00.1102231448460.5732@sister.anvils>
References: <E1PsEA7-0007G0-29@pomaz-ex.szeredi.hu>
	 <AANLkTimeihuzjgR2f7Avq2PJrCw1vZxtjh=wBPXO3aHP@mail.gmail.com>
	 <alpine.LSU.2.00.1102231448460.5732@sister.anvils>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 02 Mar 2011 10:48:16 +0100
Message-ID: <1299059296.2428.13483.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-23 at 15:12 -0800, Hugh Dickins wrote:
> 
> In his [2/8] mm: remove i_mmap_mutex lockbreak patch, Peter says
> "shouldn't hold up reclaim more than lock_page() would".  But (apart
> from a write error case) we always use trylock_page() in reclaim, we
> never dare hold it up on a lock_page(). 

D'0h! I so missed that, ok fixed up the changelog.

>  So page reclaim would get
> held up on truncation more than at present - though he's right to
> point out that truncation will usually be freeing pages much faster.

*phew* :-)
