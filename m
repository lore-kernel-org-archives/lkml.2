Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab0JSPGF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 11:06:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753345Ab0JSPGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 11:06:00 -0400
Date: Tue, 19 Oct 2010 11:05:16 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, Andi Kleen <andi@firstfloor.org>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix array overflow in CFQ
Message-ID: <20101019150516.GE857@redhat.com>
References: <1287479450-11447-1-git-send-email-andi@firstfloor.org>
 <4CBD6C84.3020309@kernel.dk>
 <20101019114933.GA857@redhat.com>
 <20101019123320.GB857@redhat.com>
 <4CBD9BCA.2060200@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CBD9BCA.2060200@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 03:23:22PM +0200, Andi Kleen wrote:
> 
> >         slice = group_slice * count /
> >                 max_t(unsigned, cfqg->busy_queues_avg[cfqd->serving_prio],
> >                       cfq_group_busy_queues_wl(cfqd->serving_prio, cfqd,
> >cfqg));
> >
> >So for IDLE class, we return immediately from the function and never
> >execute cfqg->busy_queues_avg[IDLE].
> 
> Hmm that's true. But why do you put this into a global variable
> anyways, can't it
> just be a local?

We keep track of average number of queues per group per prio class. So it
can't be local as it historical data.

> >Now to remove the gcc warning we can increase the size of busy_queues_avg[]
> >array but third field should always remain unused.
> >
> It's better to increase the field still I think.

Agreed.

Jens, do you want me to regenerate your patch so that we increase the
size of ->busy_queues_avg[CFQ_PRIO_NR] but not ->service_trees[][].

Thanks
Vivek
