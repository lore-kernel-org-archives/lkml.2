Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132Ab2LCQWi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 11:22:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50995 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754293Ab2LCQWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 11:22:36 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Zach Brown <zab@redhat.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch] bdi: add a user-tunable cpu_list for the bdi flusher threads
References: <x49boehtipu.fsf@segfault.boston.devel.redhat.com>
	<20121130221542.GM18574@lenny.home.zabbo.net>
	<x49zk1vnnju.fsf@segfault.boston.devel.redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 03 Dec 2012 11:22:31 -0500
In-Reply-To: <x49zk1vnnju.fsf@segfault.boston.devel.redhat.com> (Jeff Moyer's
	message of "Mon, 03 Dec 2012 10:49:25 -0500")
Message-ID: <x49vccjnm0o.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Moyer <jmoyer@redhat.com> writes:

>>> +		bdi->flusher_cpumask = kmalloc(sizeof(cpumask_t), GFP_KERNEL);
>>> +		if (!bdi->flusher_cpumask)
>>> +			return -ENOMEM;
>>
>> The bare GFP_KERNEL raises an eyebrow.  Some bdi_init() callers like
>> blk_alloc_queue_node() look like they'll want to pass in a gfp_t for the
>> allocation.
>
> I'd be surprised if that was necessary, seeing how every single caller
> of blk_alloc_queue_node passes in GFP_KERNEL.  I'll make the change,
> though, there aren't too many callers of bdi_init out there.

No other callers of bdi_init want anything but GFP_KERNEL.  In the case
of blk_alloc_queue_node, even *it* doesn't honor the gfp_t passed in!
Have a look at blkcg_init_queue (called from blk_alloc_queue_node) to
see what I mean.  Maybe that's a bug?

I've written the patch to modify bdi_init to take a gfp_t, but I'm
actually not in favor of this change, so I'm not going to post it
(unless, of course, you can provide a compelling argument).  :-)

Cheers,
Jeff
