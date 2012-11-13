Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439Ab2KMBNe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 20:13:34 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:34149 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727Ab2KMBNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 20:13:33 -0500
Date: Mon, 12 Nov 2012 20:13:29 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Joonsoo Kim <js1304@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 4/4] bootmem: fix wrong call parameter for free_bootmem()
Message-ID: <20121113011329.GF10092@cmpxchg.org>
References: <1352737915-30906-1-git-send-email-js1304@gmail.com>
 <1352737915-30906-4-git-send-email-js1304@gmail.com>
 <20121113011027.GE10092@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121113011027.GE10092@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2012 at 08:10:27PM -0500, Johannes Weiner wrote:
> On Tue, Nov 13, 2012 at 01:31:55AM +0900, Joonsoo Kim wrote:
> > It is somehow strange that alloc_bootmem return virtual address
> > and free_bootmem require physical address.
> > Anyway, free_bootmem()'s first parameter should be physical address.
> > 
> > There are some call sites for free_bootmem() with virtual address.
> > So fix them.
> > 
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > Signed-off-by: Joonsoo Kim <js1304@gmail.com>
> 
> Found another one, attached below.  The free_bootmem() in
> arch/powerpc/platforms/82xx/pq2ads-pci-pic.c looks also fishy, since
> it's applied to memory from kzalloc().  Ben?

Eh, missed the smu.c one in Joonsoo's patch.  powerpc one still
strange.
