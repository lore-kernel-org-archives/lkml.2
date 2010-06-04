Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab0FDLrZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 07:47:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809Ab0FDLrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 07:47:24 -0400
Date: Fri, 4 Jun 2010 14:42:05 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       kvm@vger.kernel.org, qemu-devel@nongnu.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCHv3 1/2] virtio: support layout with avail ring before idx
Message-ID: <20100604114205.GA22599@redhat.com>
References: <cover.1275403477.git.mst@redhat.com> <201006041204.57973.rusty@rustcorp.com.au> <20100604103543.GA22270@redhat.com> <201006042046.49872.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201006042046.49872.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 04, 2010 at 08:46:49PM +0930, Rusty Russell wrote:
> On Fri, 4 Jun 2010 08:05:43 pm Michael S. Tsirkin wrote:
> > On Fri, Jun 04, 2010 at 12:04:57PM +0930, Rusty Russell wrote:
> > > On Wed, 2 Jun 2010 12:17:12 am Michael S. Tsirkin wrote:
> > > > This adds an (unused) option to put available ring before control (avail
> > > > index, flags), and adds padding between index and flags. This avoids
> > > > cache line sharing between control and ring, and also makes it possible
> > > > to extend avail control without incurring extra cache misses.
> > > > 
> > > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > 
> > > No no no no.  254?  You're trying to Morton me![1]
> > 
> > Hmm, I wonder what will we do if we want a 3rd field on
> > a separate chacheline. But ok.
> > 
> > > How's this (untested):
> > 
> > I think we also want to put flags there as well,
> > they are used on interrupt path, together with last used index.
> 
> I'm uncomfortable with moving a field.
> 
> We haven't done that before and I wonder what will break with old code.

With e.g. my patch, We only do this conditionally when bit is negotitated.

> Should we instead just abandon the flags field and use last_used only?
> Or, more radically, put flags == last_used when the feature is on?
> 
> Thoughts?
> Rusty.

Hmm, e.g. with TX and virtio net, we almost never want interrupts,
whatever the index value.

-- 
MST
