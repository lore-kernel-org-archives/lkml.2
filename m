Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030Ab1GTN4c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 09:56:32 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:31304 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751616Ab1GTN4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 09:56:31 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: HM_M604VM1m26as.8um_87fmmUAzcN0VYIE9bGwOdijLYLv
 Eg._bwjPeCYPE3mDTilG0A0iS1H7okdBXcEZ2ifXyXq3gLKFf8Ljv8RBx8on
 z5c_m2T4NOZrFuMK4Kpb1gOzCngvl2MmHZFT2OQNXjcq_2KaGxtAsxEK2Gaj
 2rMRXr4bTVWPhaQLK9iM85nE0uZCuv.BPDvvHrB0XBA0xCfWQwy8tP_3mbOf
 k7mX7UJwHOtpxwjSS6OYgnSUx8oo0ZfDgUyfBurrpoANputp0oXuHmdF_h4C
 BXhsoGjsCCzW4_6bHRskQJpqVlBHUMlOFmRdh91tlS2CWkVEONWvi1G2_0Fu
 4ZA1V1.MKsCzX1i_V9Oi4DGoW
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 20 Jul 2011 08:56:27 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mel Gorman <mgorman@suse.de>
cc: Pekka Enberg <penberg@kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH] mm-slab: allocate kmem_cache with __GFP_REPEAT
In-Reply-To: <20110720134342.GK5349@suse.de>
Message-ID: <alpine.DEB.2.00.1107200854390.32737@router.home>
References: <20110720121612.28888.38970.stgit@localhost6> <alpine.DEB.2.00.1107201611010.3528@tiger> <20110720134342.GK5349@suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jul 2011, Mel Gorman wrote:

> > The changelog isn't that convincing, really. This is
> > kmem_cache_create() so I'm surprised we'd ever get NULL here in
> > practice. Does this fix some problem you're seeing? If this is
> > really an issue, I'd blame the page allocator as GFP_KERNEL should
> > just work.
> >
>
> Besides, is allocating from cache_cache really a
> PAGE_ALLOC_COSTLY_ORDER allocation? On my laptop at least, it's an
> order-2 allocation which is supporting up to 512 CPUs and 512 nodes.

Slab's kmem_cache is configured with an array of NR_CPUS which is the
maximum nr of cpus supported. Some distros support 4096 cpus in order to
accomodate SGI machines. That array then will have the size of 4096 * 8 =
32k

