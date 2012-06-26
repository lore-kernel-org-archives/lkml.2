Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757037Ab2FZNU7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 09:20:59 -0400
Received: from gir.skynet.ie ([193.1.99.77]:33021 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756591Ab2FZNU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 09:20:58 -0400
Date: Tue, 26 Jun 2012 14:20:55 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Rik van Riel <riel@redhat.com>
Cc: Rafael Aquini <aquini@redhat.com>, linux-mm@kvack.org,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 1/4] mm: introduce compaction and migration for virtio
 ballooned pages
Message-ID: <20120626132055.GI8103@csn.ul.ie>
References: <cover.1340665087.git.aquini@redhat.com>
 <7f83427b3894af7969c67acc0f27ab5aa68b4279.1340665087.git.aquini@redhat.com>
 <4FE9B677.8040409@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4FE9B677.8040409@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 09:17:43AM -0400, Rik van Riel wrote:
> On 06/25/2012 07:25 PM, Rafael Aquini wrote:
> >This patch introduces helper functions that teach compaction and migration bits
> >how to cope with pages which are part of a guest memory balloon, in order to
> >make them movable by memory compaction procedures.
> >
> >Signed-off-by: Rafael Aquini<aquini@redhat.com>
> 
> The function fill_balloon in drivers/virtio/virtio_balloon.c
> should probably add __GFP_MOVABLE to the gfp mask for alloc_pages,
> to keep the pageblock where balloon pages are allocated marked
> as movable.
> 

You're right, but patch 3 is already doing that at the same time the
migration primitives are introduced. It does mean the full series has to
be applied to do anything but I think it's bisect safe.

-- 
Mel Gorman
SUSE Labs
