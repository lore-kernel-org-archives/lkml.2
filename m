Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760258Ab2FUUgU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 16:36:20 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39294 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269Ab2FUUgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 16:36:19 -0400
Date: Thu, 21 Jun 2012 13:36:15 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Josh Hunt <joshhunt00@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
Subject: Re: multi-second application stall in open()
Message-ID: <20120621203615.GE4642@google.com>
References: <CAKA=qzaHqwZ8eqpLNFjxnO2fX-tgAOjmpvxgBFjv6dJeQaOW1w@mail.gmail.com>
 <CAKA=qzZQ0YkWXpi4gKYe5yFrR9EF3+G1Wq=kWybreLXx7D30oQ@mail.gmail.com>
 <20120307162851.GC13430@redhat.com>
 <4F57AF4A.6080703@kernel.dk>
 <CAKA=qzak6N-6oHVjDozJ6KLMSWXEgzZf1xaC_1cgnoaUCyw8Ag@mail.gmail.com>
 <CAKA=qzaHJ0OcbvtT-mwKBUBvzPkxE4r-bW6gDvicKhoQeyFWEg@mail.gmail.com>
 <20120308234016.GA925@redhat.com>
 <CAKA=qzbsL9UVYLZ3=hoT-1jfp=v=_Sr=h+YeHu0qAA=Ko_7P6w@mail.gmail.com>
 <CAKA=qzbqoK5_3GXM8DZhbQ5cTU=DTg5DFFJ+46OrD7y=XrMLTg@mail.gmail.com>
 <20120621203217.GC14095@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120621203217.GC14095@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Vivek.

On Thu, Jun 21, 2012 at 04:32:17PM -0400, Vivek Goyal wrote:
> Here we deleted queue 20720 and did nothing for .6 seconds and from
> previous logs it is visible that writes are pending and queued.
> 
> For some reason cfq_schedule_dispatch() did not lead to kicking queue
> or queue was kicked but somehow write queue was not selected for
> dispatch (A case of corrupt data structures?).
> 
> Are you able to reproduce this issue on latest kernels (3.5-rc2?). I would
> say put some logs in select_queue() and see where did it bail out. That
> will confirm that select queue was called and can also give some details 
> why we did not select async queue for dispatch. (Note: select_queue is called
> multiple times so putting trace point there makes logs very verbose).

Some people are putting in watchdog timers in block layer to kick cfq
when it stalls with pending requests.  The cfq code there has diverged
quite a bit from upstream so I have no idea whether it's caused by the
same issue.  The symptom sounds exactly the same tho.  So, yeah, I
think it isn't too unlikely that we have a cfq logic bug leading to
stalls.  :(

-- 
tejun
