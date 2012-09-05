Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733Ab2IEO0j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 10:26:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46659 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579Ab2IEO0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 10:26:38 -0400
Date: Wed, 5 Sep 2012 17:27:57 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Sasha Levin <levinsasha928@gmail.com>, rusty@rustcorp.com.au,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 2/2] virtio-ring: Allocate indirect buffers from cache
 when possible
Message-ID: <20120905142757.GA10925@redhat.com>
References: <1346325718-11151-1-git-send-email-levinsasha928@gmail.com>
 <1346325718-11151-2-git-send-email-levinsasha928@gmail.com>
 <20120830133820.GC21132@redhat.com>
 <50408587.5030603@gmail.com>
 <20120831095628.GB24244@redhat.com>
 <50462D8B.7040004@redhat.com>
 <20120904184122.GA3602@redhat.com>
 <50475FD8.1090109@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50475FD8.1090109@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 05:21:12PM +0300, Avi Kivity wrote:
> On 09/04/2012 09:41 PM, Michael S. Tsirkin wrote:
> > On Tue, Sep 04, 2012 at 07:34:19PM +0300, Avi Kivity wrote:
> >> On 08/31/2012 12:56 PM, Michael S. Tsirkin wrote:
> >> > On Fri, Aug 31, 2012 at 11:36:07AM +0200, Sasha Levin wrote:
> >> >> On 08/30/2012 03:38 PM, Michael S. Tsirkin wrote:
> >> >> >> +static unsigned int indirect_alloc_thresh = 16;
> >> >> > Why 16?  Please make is MAX_SG + 1 this makes some sense.
> >> >> 
> >> >> Wouldn't MAX_SG mean we always allocate from the cache? Isn't the memory waste
> >> >> too big in this case?
> >> > 
> >> > Sorry. I really meant MAX_SKB_FRAGS + 1. MAX_SKB_FRAGS is 17 so gets us
> >> > threshold of 18. It is less than the size of an skb+shinfo itself so -
> >> > does it look too big to you? Also why do you think 16 is not too big but
> >> > 18 is?  If there's a reason then I am fine with 16 too but then please
> >> > put it in code comment near where the value is set.
> >> > 
> >> > Yes this means virtio net always allocates from cache
> >> > but this is a good thing, isn't it? Gets us more consistent
> >> > performance.
> >> 
> >> kmalloc() also goes to a cache.  Is there a measurable difference?
> > 
> > Yes see 0/2 and followup discussion.
> 
> I don't see 0/2, looks like this was not threaded properly.  What was
> the subject line?

My mistake, there is no 0/2, the resolts where in the followup thread
of the previous version:
	[PATCH v2 2/2] virtio-ring: Allocate indirect buffers from cache when possible

Sasha, could you please accompany the next version
with a cover letter 0/2) including performance results?

> 
> -- 
> error compiling committee.c: too many arguments to function
