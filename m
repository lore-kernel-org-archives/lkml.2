Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460Ab2HNUad (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 16:30:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1568 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757398Ab2HNUac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 16:30:32 -0400
Date: Tue, 14 Aug 2012 23:31:23 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rafael Aquini <aquini@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>, Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH v7 2/4] virtio_balloon: introduce migration primitives to
 balloon pages
Message-ID: <20120814203123.GC28990@redhat.com>
References: <cover.1344619987.git.aquini@redhat.com>
 <f19b63dfa026fe2f8f11ec017771161775744781.1344619987.git.aquini@redhat.com>
 <20120813084123.GF14081@redhat.com>
 <20120814182244.GB13338@t510.redhat.com>
 <20120814195139.GA28870@redhat.com>
 <20120814201113.GE22133@t510.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120814201113.GE22133@t510.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 05:11:13PM -0300, Rafael Aquini wrote:
> On Tue, Aug 14, 2012 at 10:51:39PM +0300, Michael S. Tsirkin wrote:
> > What I think you should do is use rcu for access.
> > And here sync rcu before freeing.
> > Maybe an overkill but at least a documented synchronization
> > primitive, and it is very light weight.
> > 
> 
> I liked your suggestion on barriers, as well.
> 
> Rik, Mel ?

Further instead of simple assignment I would add an api
in mm to set/clear the balloon mapping, with proper locking.

This could fail if already set, and thus fix crash with
many ballons.
