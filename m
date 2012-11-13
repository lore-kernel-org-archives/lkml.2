Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab2KMInv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 03:43:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15967 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811Ab2KMInu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 03:43:50 -0500
Date: Tue, 13 Nov 2012 09:43:42 +0100 (CET)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
X-X-Sender: lukas@localhost
To: Jens Axboe <axboe@kernel.dk>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Lukas Czerner <lczerner@redhat.com>, dchinner@redhat.com,
        jmoyer@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] loop: Limit the number of requests in the bio list
In-Reply-To: <509CB1EB.4080408@kernel.dk>
Message-ID: <alpine.LFD.2.00.1211130942160.3577@localhost>
References: <1350379305-13858-1-git-send-email-lczerner@redhat.com> <20121108111418.bcaad11d.akpm@linux-foundation.org> <509CB1EB.4080408@kernel.dk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Nov 2012, Jens Axboe wrote:

> Date: Fri, 09 Nov 2012 08:34:03 +0100
> From: Jens Axboe <axboe@kernel.dk>
> To: Andrew Morton <akpm@linux-foundation.org>
> Cc: Lukas Czerner <lczerner@redhat.com>, dchinner@redhat.com,
>     jmoyer@redhat.com, linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v2] loop: Limit the number of requests in the bio list
> 
> On 2012-11-08 20:14, Andrew Morton wrote:
> > On Tue, 16 Oct 2012 11:21:45 +0200
> > Lukas Czerner <lczerner@redhat.com> wrote:
> > 
> >> Currently there is not limitation of number of requests in the loop bio
> >> list. This can lead into some nasty situations when the caller spawns
> >> tons of bio requests taking huge amount of memory. This is even more
> >> obvious with discard where blkdev_issue_discard() will submit all bios
> >> for the range and wait for them to finish afterwards. On really big loop
> >> devices and slow backing file system this can lead to OOM situation as
> >> reported by Dave Chinner.
> >>
> >> With this patch we will wait in loop_make_request() if the number of
> >> bios in the loop bio list would exceed 'nr_requests' number of requests.
> >> We'll wake up the process as we process the bios form the list. Some
> >> threshold hysteresis is in place to avoid high frequency oscillation.
> >>
> > 
> > What's happening with this?
> 
> Sorry I didn't reply to this yet. My initial thought is that we had
> something like this for loop back in the 2.4 days, and it was deadlock
> prone. Can't seem to remember all the details on that yet.
> 
> v2 is a nice improvement, though. With 1:1 bio and wakeups, you would
> get tons of context switches. The batched approach is much better.
> 
> Lukas, have you beaten on this with a file backed loop and heavy traffic
> on a file system on top?

Hi Jeff,

sorry for the delay. Yes, I've tested this with xfstests using loop
driver for both test and scratch disk.

I'll resend the updated version hopefully later today.

Thanks!
-Lukas
