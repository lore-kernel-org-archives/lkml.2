Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353Ab0JUUic (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 16:38:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51600 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757059Ab0JUUia convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 16:38:30 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <jaxboe@fusionio.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] cfq-iosched: Fix a gcc 4.5 warning and put some comments
References: <20101021182403.GA8378@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 21 Oct 2010 16:36:20 -0400
In-Reply-To: <20101021182403.GA8378@redhat.com> (Vivek Goyal's message of
	"Thu, 21 Oct 2010 14:24:03 -0400")
Message-ID: <x497hhbe117.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> - Andi encountedred following warning with gcc 4.5
>
>   linux/block/cfq-iosched.c: In function ‘cfq_dispatch_requests’:
>   linux/block/cfq-iosched.c:2156:3: warning: array subscript is above array
>   bounds
>
> - Warning happens due to following code.
>
>   slice = group_slice * count /
> 		max_t(unsigned, cfqg->busy_queues_avg[cfqd->serving_prio],
> 		cfq_group_busy_queues_wl(cfqd->serving_prio, cfqd, cfqg));
>
>   gcc is complaining about cfqg->busy_queues_avg[] being indexed by CFQ
>   prio classes (RT, BE and IDLE) while the array size is only 2.
>
> - At run time, we never access cfqg->busy_queues_avg[IDLE] and return from
>   function before this code hits.
>
> - To fix warning increase the array size though it will remain unused. This
>   patch also puts some comments to clarify some of the confusions.
>
> - I have taken Jens's patch and modified it a bit.
>
> - Compile tested with gcc 4.4 and boot tested. I don't have gcc 4.5
>   running, Andi can you please test it with gcc 4.5 to make sure it
>   worked.
>
> Reported-by: Andi Kleen <ak@linux.intel.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Acked-by: Jeff Moyer <jmoyer@redhat.com>
