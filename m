Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545Ab2HNUxg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 16:53:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23227 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757401Ab2HNUxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 16:53:35 -0400
Date: Tue, 14 Aug 2012 23:54:26 +0300
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
Message-ID: <20120814205426.GA29162@redhat.com>
References: <cover.1344619987.git.aquini@redhat.com>
 <f19b63dfa026fe2f8f11ec017771161775744781.1344619987.git.aquini@redhat.com>
 <20120813084123.GF14081@redhat.com>
 <20120814182244.GB13338@t510.redhat.com>
 <20120814195139.GA28870@redhat.com>
 <20120814195916.GC28870@redhat.com>
 <20120814200830.GD22133@t510.redhat.com>
 <20120814202401.GB28990@redhat.com>
 <20120814202949.GF22133@t510.redhat.com>
 <20120814204906.GD28990@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120814204906.GD28990@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 11:49:06PM +0300, Michael S. Tsirkin wrote:
> On Tue, Aug 14, 2012 at 05:29:50PM -0300, Rafael Aquini wrote:
> > On Tue, Aug 14, 2012 at 11:24:01PM +0300, Michael S. Tsirkin wrote:
> > > On Tue, Aug 14, 2012 at 05:08:31PM -0300, Rafael Aquini wrote:
> > > > On Tue, Aug 14, 2012 at 10:59:16PM +0300, Michael S. Tsirkin wrote:
> > > > > > > > What if there is more than one balloon device?
> > > > > > > 
> > > > > > > Is it possible to load this driver twice, or are you foreseeing a future case
> > > > > > > where this driver will be able to manage several distinct memory balloons for
> > > > > > > the same guest?
> > > > > > > 
> > > > > > 
> > > > > > Second.
> > > > > > It is easy to create several balloons they are just
> > > > > > pci devices.
> > > > >  
> > > > > 
> > > > > 
> > > > > and it might not be too important to make it work but
> > > > > at least would be nice not to have a crash in this
> > > > > setup.
> > > > >
> > > > Fair enough. For now, as I believe it's safe to assume we are only inflating one
> > > > balloon per guest, I'd like to propose this as a future enhancement. Sounds
> > > > good?
> > > >  
> > > 
> > > Since guest crashes when it's not the case, no it doesn't, sorry :(.
> > >
> > Ok, but right now this driver only takes care of 1 balloon per guest,
> 
> It does? Are you sure? There is no global state as far as I can see. So
> I can create 2 devices and driver will happily create two instances,
> each one can be inflated/deflated independently.
> 
> > so how
> > could this approach crash it? 
> 
> Add device. inflate. Add another device. inflate. deflate. unplug.
> Now you have pointer to freed memory and when mm touches
> page from first device, you ge use after free.
> 
> > Your point is a good thing to be on a to-do list for future enhancements, but
> > it's not a dealbreaker for the present balloon driver implementation, IMHO.
> > 
> 
> Yes it looks like a dealbreaker to me.

To clarify, the global state that this patch adds, is ugly
even if we didn't support multiple balloons yet.
So I don't think I can accept such a patch.
Rusty has a final word here, maybe he thinks differently.

> -- 
> MST 
