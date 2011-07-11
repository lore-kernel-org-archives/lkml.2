Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547Ab1GKNXz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 09:23:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52796 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757503Ab1GKNXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 09:23:52 -0400
Date: Mon, 11 Jul 2011 09:23:44 -0400
From: David Teigland <teigland@redhat.com>
To: "Dr. David Alan Gilbert" <linux@treblig.org>
Cc: jj@chaosbits.net, linux-kernel@vger.kernel.org
Subject: Re: kmallocs with swapped parameters in fs/dlm/lock.c
Message-ID: <20110711132344.GA14426@redhat.com>
References: <20110710003032.GA19951@gallifrey>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110710003032.GA19951@gallifrey>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 10, 2011 at 01:30:32AM +0100, Dr. David Alan Gilbert wrote:
> Hi David,
>   Sparse spotted a couple of places in fs/dlm/lock.c where the size/flags
> parameters to kmalloc got swapped:
> 
> The sparse output is:
> fs/dlm/lock.c:852:42: warning: incorrect type in argument 1 (different base types)
> fs/dlm/lock.c:852:42:    expected unsigned long [unsigned] [usertype] size
> fs/dlm/lock.c:852:42:    got restricted gfp_t
> fs/dlm/lock.c:852:64: warning: incorrect type in argument 2 (different base types)
> fs/dlm/lock.c:852:64:    expected restricted gfp_t [usertype] flags
> fs/dlm/lock.c:852:64:    got unsigned long
> fs/dlm/lock.c:4136:27: warning: incorrect type in argument 1 (different base types)
> fs/dlm/lock.c:4136:27:    expected unsigned long [unsigned] [usertype] size
> fs/dlm/lock.c:4136:27:    got restricted gfp_t
> fs/dlm/lock.c:4136:39: warning: incorrect type in argument 2 (different base types)
> fs/dlm/lock.c:4136:39:    expected restricted gfp_t [usertype] flags
> fs/dlm/lock.c:4136:39:    got unsigned long
> 
> Line 852 is:
>                         warned = kmalloc(GFP_KERNEL, num_nodes * sizeof(int));
> Line 4136 is:
>         ms_stub = kmalloc(GFP_KERNEL, sizeof(struct dlm_message));
> 
> and at least one of the defs of kmalloc is:
> slab_def.h:static __always_inline void *kmalloc(size_t size, gfp_t flags)
> 
> Given that I haven't got a clue how to test a dlm, it's probably
> best that you patch it.
> 
> Jesper:
>   I noticed in your patch:
> https://lkml.org/lkml/2011/7/2/90
> 
> where you had done a kmalloc->kzalloc transform you kept the swap.
> 
> This looks like new code in 3.0rc so I don't think you could quite
> call it a regression, but it should probably be fixed fairly quickly
> I guess.

Thanks, I'll get that fixed.
Dave

