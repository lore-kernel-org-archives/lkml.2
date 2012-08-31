Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab2HaJzP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 05:55:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7595 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751957Ab2HaJzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 05:55:14 -0400
Date: Fri, 31 Aug 2012 12:56:28 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, avi@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH v3 2/2] virtio-ring: Allocate indirect buffers from cache
 when possible
Message-ID: <20120831095628.GB24244@redhat.com>
References: <1346325718-11151-1-git-send-email-levinsasha928@gmail.com>
 <1346325718-11151-2-git-send-email-levinsasha928@gmail.com>
 <20120830133820.GC21132@redhat.com>
 <50408587.5030603@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50408587.5030603@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2012 at 11:36:07AM +0200, Sasha Levin wrote:
> On 08/30/2012 03:38 PM, Michael S. Tsirkin wrote:
> >> +static unsigned int indirect_alloc_thresh = 16;
> > Why 16?  Please make is MAX_SG + 1 this makes some sense.
> 
> Wouldn't MAX_SG mean we always allocate from the cache? Isn't the memory waste
> too big in this case?

Sorry. I really meant MAX_SKB_FRAGS + 1. MAX_SKB_FRAGS is 17 so gets us
threshold of 18. It is less than the size of an skb+shinfo itself so -
does it look too big to you? Also why do you think 16 is not too big but
18 is?  If there's a reason then I am fine with 16 too but then please
put it in code comment near where the value is set.

Yes this means virtio net always allocates from cache
but this is a good thing, isn't it? Gets us more consistent
performance.



-- 
MST
