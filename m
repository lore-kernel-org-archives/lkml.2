Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758216Ab2CGOU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 09:20:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12959 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754837Ab2CGOU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 09:20:27 -0500
Date: Wed, 7 Mar 2012 11:18:37 -0300
From: Rafael Aquini <aquini@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Rik van Riel <riel@redhat.com>, Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH -v2] mm: SLAB Out-of-memory diagnostics
Message-ID: <20120307141836.GA2009@x61.redhat.com>
References: <20120305181041.GA9829@x61.redhat.com>
 <alpine.DEB.2.00.1203061941210.24600@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1203061941210.24600@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Howdy David,

On Tue, Mar 06, 2012 at 07:41:55PM -0800, David Rientjes wrote:
> > +		spin_lock_irqsave(&l3->list_lock, flags);
> 
> Could be spin_lock_irq(&l3->list_lock);

I don't think it would be safe making such assumption.

Note that spin_lock_irqsave() is used at slab_out_of_memory() because we cannot
guarantee that interrupts will be enabled/disabled by the time kmem_getpages()
is called in cache_grow() or fallback_alloc().

  Rafael
