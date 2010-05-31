Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab0EaNep (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 09:34:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753964Ab0EaNeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 09:34:44 -0400
Date: Mon, 31 May 2010 16:29:50 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       qemu-devel@nongnu.org
Subject: Re: [PATCHv2-RFC 0/2] virtio: put last seen used index into ring
	itself
Message-ID: <20100531132950.GC1704@redhat.com>
References: <cover.1274903328.git.mst@redhat.com> <4BFF9366.5090103@redhat.com> <20100530112220.GA27611@redhat.com> <4C0366E0.6040203@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C0366E0.6040203@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 09:36:00AM +0200, Jes Sorensen wrote:
> On 05/30/10 13:22, Michael S. Tsirkin wrote:
> > On Fri, May 28, 2010 at 11:56:54AM +0200, Jes Sorensen wrote:
> >> It looks pretty good to me, however one thing I have been thinking of
> >> while reading through it:
> >>
> >> Rather than storing a pointer within the ring struct, pointing into a
> >> position within the same struct. How about storing a byte offset instead
> >> and using a cast to get to the pointer position? That would avoid the
> >> pointer dereference, which is less effective cache wise and harder for
> >> the CPU to predict.
> >>
> >> Not sure whether it really matters performance wise, just a thought.
> > 
> > I think this won't work: when PUBLUSH_USED_IDX is negotiated,
> > the pointer is to within the ring.
> 
> Hmmm shame, it would be a nice optimization.
> 
> Maybe it's time to introduce the v2 ring format, rather than having
> adding more kludges to the existing one?
> 
> Cheers,
> Jes

There has been discussion about a ring format that does not
use indexes at all. My guess is that would be a good point
for v2 ring format. But making that a product
and tuning might take a while. So definitely something to
keep in mind but I would not want that to block this optimization.

-- 
MST
