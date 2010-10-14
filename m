Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938Ab0JNISA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 04:18:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754662Ab0JNIR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 04:17:58 -0400
Date: Thu, 14 Oct 2010 10:11:34 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Maciej Sosnowski <maciej.sosnowski@intel.com>,
        "David S. Miller" <davem@davemloft.net>, stable@kernel.org
Subject: Re: [PATCH] dma: fix error handling on out of memory
Message-ID: <20101014081132.GA11095@redhat.com>
References: <20101011094416.GA3771@redhat.com>
 <AANLkTimi4vo_trVGxO9eeaYsfnRkjweG0irCGek=75Yu@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimi4vo_trVGxO9eeaYsfnRkjweG0irCGek=75Yu@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 05:10:25PM -0700, Dan Williams wrote:
> On Mon, Oct 11, 2010 at 2:44 AM, Michael S. Tsirkin <mst@redhat.com> wrote:
> > get_user_pages might return less pages than requested. If this happens
> > for the first iovec in dma_pin_iovec_pages, then nr_iovecs is 0 and so
> > dma_unpin_iovec_pages will not unpin any pages, leaking pinned memory.
> > A similar off by one would trigger for any of the following entries.
> >
> > Fix by updating nr_iovecs and nr_pages in this case.
> >
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >
> > Error handling in dma_pin_iovec_pages still looks wrong to me.  Am I
> > missing something?
> 
> Still looks wrong it what way?  You make sure that nr_iovecs is
> incremented so that the partial page list is freed, and we only walk
> the initialized entries in pinned_list.

In that before the patch, if get_user_pages returns less pages than
requested, we would leak pinned memory. Right?

> --
> Dan
