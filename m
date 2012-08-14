Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab2HNVhk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 17:37:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25852 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752324Ab2HNVhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 17:37:39 -0400
Date: Wed, 15 Aug 2012 00:38:32 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: Rafael Aquini <aquini@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>, Mel Gorman <mel@csn.ul.ie>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH v7 2/4] virtio_balloon: introduce migration primitives to
 balloon pages
Message-ID: <20120814213832.GA29180@redhat.com>
References: <20120813084123.GF14081@redhat.com>
 <20120814182244.GB13338@t510.redhat.com>
 <20120814195139.GA28870@redhat.com>
 <20120814195916.GC28870@redhat.com>
 <20120814200830.GD22133@t510.redhat.com>
 <20120814202401.GB28990@redhat.com>
 <20120814202949.GF22133@t510.redhat.com>
 <20120814204906.GD28990@redhat.com>
 <20120814205426.GA29162@redhat.com>
 <502ABB9B.90108@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <502ABB9B.90108@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 04:56:59PM -0400, Rik van Riel wrote:
> On 08/14/2012 04:54 PM, Michael S. Tsirkin wrote:
> 
> >To clarify, the global state that this patch adds, is ugly
> >even if we didn't support multiple balloons yet.
> >So I don't think I can accept such a patch.
> >Rusty has a final word here, maybe he thinks differently.
> 
> Before deciding that "does not support multiple balloon drivers
> at once" is an issue, is there any use case at all for having
> multiple balloon drivers active at a time?
> 
> I do not see any.

For example, we had a proposal for a page-cache backed
device. So it could be useful to have two, a regular balloon
and a pagecache backed one.
There could be other uses - it certainly looks like it
works so how can you be sure it's useless?

And even ignoring that, global pointer to a device
is an ugly hack and ugly hacks tend to explode.

And even ignoring estetics, and if we decide we are fine
with a single balloon, it needs to fail gracefully not
crash like it does now.

> -- 
> All rights reversed
