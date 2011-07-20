Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907Ab1GTNyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 09:54:17 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:34067 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751103Ab1GTNyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 09:54:14 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: hPI7MJ0VM1nRJy0aSQd8tmq_7jw1mS2MbXrlho09qn1f4Xi
 TNvcyxf_uhJxzofaS7KZ9.8VuEUCY3m.jsNeS8XAsEf0LB8vhcHK7tOUyoaR
 XA9J2ykVNj_pbiLTUHQrvtdwU6uR61lyS3xr2XLdyoEjFQjmSXVI0O0iMih1
 uz6nOuS8N1HHKDpxN0gPNNlT498P8bcy6VPiShLMApfqK1uxa_0hroIIzmn_
 TjkHKC0erkg4SHTtayoRu0O4NjR2ojEfuIjeHojIWozljJPUOqmvHN7Jk2KL
 SbSQG4Pc0x4OA.eKhLpXfVhk9j.edNPg6gOmpMCfFce1WECGp
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 20 Jul 2011 08:54:10 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: Konstantin Khlebnikov <khlebnikov@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matt Mackall <mpm@selenic.com>, "mgorman@suse.de" <mgorman@suse.de>
Subject: Re: [PATCH] mm-slab: allocate kmem_cache with __GFP_REPEAT
In-Reply-To: <alpine.DEB.2.00.1107201638520.4921@tiger>
Message-ID: <alpine.DEB.2.00.1107200852590.32737@router.home>
References: <20110720121612.28888.38970.stgit@localhost6> <alpine.DEB.2.00.1107201611010.3528@tiger> <4E26D7EA.3000902@parallels.com> <alpine.DEB.2.00.1107201638520.4921@tiger>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jul 2011, Pekka Enberg wrote:

> On Wed, 20 Jul 2011, Konstantin Khlebnikov wrote:
> > > The changelog isn't that convincing, really. This is kmem_cache_create()
> > > so I'm surprised we'd ever get NULL here in practice. Does this fix some
> > > problem you're seeing? If this is really an issue, I'd blame the page
> > > allocator as GFP_KERNEL should just work.
> >
> > nf_conntrack creates separate slab-cache for each net-namespace,
> > this patch of course not eliminates the chance of failure, but makes it more
> > acceptable.
>
> I'm still surprised you are seeing failures. mm/slab.c hasn't changed
> significantly in a long time. Why hasn't anyone reported this before? I'd
> still be inclined to shift the blame to the page allocator... Mel, Christoph?

There was a lot of recent fiddling with the reclaim logic. Maybe some of
those changes caused the problem?
