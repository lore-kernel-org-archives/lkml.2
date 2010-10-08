Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758822Ab0JHPx5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 11:53:57 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:48344 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758700Ab0JHPx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 11:53:56 -0400
Date: Fri, 8 Oct 2010 21:23:43 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [PATCH] kvm: add oom notifier for virtio balloon
Message-ID: <20101008155343.GD5327@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20101005124521.GA2602@darkstar>
 <20101008130916.GC5327@balbir.in.ibm.com>
 <AANLkTimd2Z3Yy9yxHZA6raeFxp6L7Wtvy5rLSrMyjEU1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <AANLkTimd2Z3Yy9yxHZA6raeFxp6L7Wtvy5rLSrMyjEU1@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dave Young <hidave.darkstar@gmail.com> [2010-10-08 21:33:02]:

> On Fri, Oct 8, 2010 at 9:09 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > * Dave Young <hidave.darkstar@gmail.com> [2010-10-05 20:45:21]:
> >
> >> Balloon could cause guest memory oom killing and panic.
> >>
> >> Add oom notify to leak some memory and retry fill balloon after 5 minutes.
> >>
> >> At the same time add a mutex to protect balloon operations
> >> because we need leak balloon in oom notifier and give back freed value.
> >>
> >> Thanks Anthony Liguori for his sugestion about inflate retrying.
> >> Sometimes it will cause endless inflate/oom/delay loop,
> >> so I think next step is to add an option to do noretry-when-oom balloon.
> >>
> >> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
> >
> > Won't __GFP_NORETRY prevent OOM? Could you please describe how you
> > tested the patch?
> 
> I have not tried __GFP_NORETRY, it should work, but balloon thread
> will keep wasting cpu resource to allocating.
> 
> 
> To test the patch, just balloon to small than minimal memory.
> 
> I use "balloon 30" in qemu monitor to limit slackware guest memory
> usage. The normal memory used is ~40M.
> 
> Actually we need to differentiate the process which caused oom. If it
> is balloon thread we should just stop ballooning, if it is others we
> can do something like this patch, e.g. retry ballooning after 5
> minutes.

Ideally the balloon thread should never OOM with __GFP_NORETRY (IIRC).
The other situation should be dealt with, we should free up any pages
we have. I wonder if the timeout should be a sysctl tunable.

-- 
	Three Cheers,
	Balbir
