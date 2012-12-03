Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673Ab2LCHb0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 02:31:26 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:18596 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab2LCHbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 02:31:25 -0500
Date: Mon, 3 Dec 2012 10:31:09 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: JoonSoo Kim <js1304@gmail.com>
Cc: devel@driverdev.osuosl.org, Robert Love <rlove@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Colin Cross <ccross@android.com>, linux-kernel@vger.kernel.org,
        Dima Zavin <dima@android.com>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [RFC PATCH] staging, android, ashmem: invalidate pin/unpin ioctl
 for private map
Message-ID: <20121203073109.GD6568@mwanda>
References: <1354297557-24486-1-git-send-email-js1304@gmail.com>
 <20121201183929.GA6568@mwanda>
 <CAAmzW4NM5prCnVeaGXGzkvZzg=oQMMC2oKpjEcXuDgfebZe_Pw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAmzW4NM5prCnVeaGXGzkvZzg=oQMMC2oKpjEcXuDgfebZe_Pw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2012 at 09:09:59AM +0900, JoonSoo Kim wrote:
> Hello, Dan.
> 
> 2012/12/2 Dan Carpenter <dan.carpenter@oracle.com>:
> > On Sat, Dec 01, 2012 at 02:45:57AM +0900, Joonsoo Kim wrote:
> >> @@ -614,21 +616,35 @@ static int ashmem_pin_unpin(struct ashmem_area *asma, unsigned long cmd,
> >>       pgstart = pin.offset / PAGE_SIZE;
> >>       pgend = pgstart + (pin.len / PAGE_SIZE) - 1;
> >>
> >> -     mutex_lock(&ashmem_mutex);
> >> +     if (asma->shared_mapping) {
> >> +             mutex_lock(&ashmem_mutex);
> >
> > Wouldn't we need to hold the mutex while we check the
> > ->shared_mapping?
> 
> I doesn't fully understand ashmem's lock semantic.
> Code for retrieving some value of asma instance doesn't hold the mutex, now.
> For example, in ashmem_ioctl(), asma->size, asma->prot_mask.
> And in ashmem_pin_unpin(), there is asma->file, asma->size which is
> retrieved without the mutex.
> According to this semantic, the mutex doesn't need for checking
> asma->shared_mapping.

The ashmem_ioctl() is clearly racy.  :P  asma->size can be modified
and read at the same time.  It's not an example to follow.

regards,
dan carpenter

