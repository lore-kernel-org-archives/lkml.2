Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753Ab2AaCRx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 21:17:53 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39063 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799Ab2AaCRv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 21:17:51 -0500
MIME-Version: 1.0
In-Reply-To: <20120130222643.GH30245@redhat.com>
References: <1327842831.2718.2.camel@edumazet-laptop>
	<20120129161058.GA13156@localhost>
	<CANejiEW86b7btiOcVFF3qVhqU1t6FRosvgfiydWwU5zgeDFOqw@mail.gmail.com>
	<20120130071346.GM29272@MAIL.13thfloor.at>
	<1327908158.21268.3.camel@sli10-conroe>
	<20120130073621.GN29272@MAIL.13thfloor.at>
	<1327911142.21268.7.camel@sli10-conroe>
	<CANejiEXwt7zdWRD0gTg1JXNPZ52vU1Z4cQsb3xztqDLccyTPSQ@mail.gmail.com>
	<20120130142837.GA21750@localhost>
	<1327935109.2297.1.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<20120130222643.GH30245@redhat.com>
Date: Tue, 31 Jan 2012 03:17:51 +0100
Message-ID: <CAL4WiiohOtcxkd9RLnJM0guN93SdPJy8Nzi6cV-fZ0-gVnTrQA@mail.gmail.com>
Subject: Re: Bad SSD performance with recent kernels
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Wu Fengguang <wfg@linux.intel.com>, Shaohua Li <shaohua.li@intel.com>,
        Herbert Poetzl <herbert@13thfloor.at>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 30 janvier 2012 23:26, Vivek Goyal <vgoyal@redhat.com> a écrit :
>
> Can you please run the blktrace again with this patch applied. I am curious
> to see how does traffic pattern look like now.
>
> In your previous trace, there were so many small 8 sector requests which
> were merged into 512 sector requests before dispatching to disk. (I am
> not sure why those requests are not bigger. Shouldn't readahead logic
> submit a bigger request?) Now with plug/unplug logic removed, I am assuming
> we should be doing less merging and dispatching more smaller requests. May be
> that is helping and cutting down on disk idling time.
>
> In previous logs, 512 sector request seems to be taking around 1ms to
> complete after dispatch. In between requests disk seems to be idle
> for around .5 to .6 ms. Out of this .3 ms seems to be gone in just
> coming up with new request after completion of previous one and another
> .3ms seems to be consumed in merging the smaller IOs. So if we don't wait
> for merging, it should keep disk busier for .3ms more which is 30% of time
> it takes to complete 512 sector request. So theoritically it can give
> 30% boost for this workload. (Assuming request size will not impact the
> disk throughput very severely).
>
> Anyway, some blktrace data will shed some light..
>
> Thanks
> Vivek


I'll do that when I have access to the machine again, in 6 hours or so :)

Thanks !
