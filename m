Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759Ab1HZJAR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 05:00:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36528 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab1HZJAN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 05:00:13 -0400
Subject: Re: [PATCH 1/2] mm: convert k{un}map_atomic(p, KM_type) to
 k{un}map_atomic(p)
From: Peter Zijlstra <peterz@infradead.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, linux-arch@vger.kernel.org
Date: Fri, 26 Aug 2011 10:59:56 +0200
In-Reply-To: <1314346676.6486.25.camel@minggr.sh.intel.com>
References: <1314346676.6486.25.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314349196.26922.22.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-26 at 16:17 +0800, Lin Ming wrote:
> @@ -292,7 +292,7 @@ static unsigned int bm_bit_to_page_idx(struct drbd_bitmap *b, u64 bitnr)
>  static unsigned long *__bm_map_pidx(struct drbd_bitmap *b, unsigned int idx, const enum km_type km)
>  {
>         struct page *page = b->bm_pages[idx];
> -       return (unsigned long *) kmap_atomic(page, km);
> +       return (unsigned long *) kmap_atomic(page);
>  }
>  
>  static unsigned long *bm_map_pidx(struct drbd_bitmap *b, unsigned int idx)
> @@ -302,7 +302,7 @@ static unsigned long *bm_map_pidx(struct drbd_bitmap *b, unsigned int idx)
>  
>  static void __bm_unmap(unsigned long *p_addr, const enum km_type km)
>  {
> -       kunmap_atomic(p_addr, km);
> +       kunmap_atomic(p_addr);
>  };
>   

Stuff like that is really only a half-assed cleanup, IIRC there's more
sites like that.

In my initial massive patch I cleaned all that up as well.
