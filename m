Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758811Ab1IJIl0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 04:41:26 -0400
Received: from frankvm.xs4all.nl ([83.163.148.79]:38989 "EHLO
	janus.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758469Ab1IJIlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 04:41:24 -0400
Date: Sat, 10 Sep 2011 10:41:23 +0200
From: Frank van Maarseveen <frankvm@frankvm.com>
To: Lin Ming <mlin@ss.pku.edu.cn>
Cc: Andrew Morton <akpm@linux-foundation.org>, Lin Ming <ming.m.lin@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: 3.0.3 kernel BUG at kernel/timer.c:1035
Message-ID: <20110910084123.GA23171@janus>
References: <20110824130238.GA24543@janus>
 <20110902011058.c5bad476.akpm@linux-foundation.org>
 <20110905123813.GA29763@janus>
 <CAF1ivSYui_=tHbxHiy15a9wfiphHcpoY+J1MmAJ=dMQsAfEVLw@mail.gmail.com>
 <1315320518.4235.3.camel@hp6530s>
 <20110907102425.GA3423@janus>
 <1315398979.2938.0.camel@hp6530s>
 <20110907143006.0d0922dd.akpm@linux-foundation.org>
 <CAF1ivSbWFahCM79uBD24yA2+KwRV=RC-n=E8ev4nLCUyFVeaEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAF1ivSbWFahCM79uBD24yA2+KwRV=RC-n=E8ev4nLCUyFVeaEQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 09, 2011 at 10:21:36PM +0800, Lin Ming wrote:
> On Thu, Sep 8, 2011 at 5:30 AM, Andrew Morton <akpm@linux-foundation.org> wrote:

(...)

> >
> > Probably this will "fix" it:
> 
> Frank,
> 
> Does Andrew's patch help?
> 
> Lin Ming
> 
> >
> > --- a/block/blk-sysfs.c~a
> > +++ a/block/blk-sysfs.c
> > @@ -4,6 +4,7 @@
> >  #include <linux/kernel.h>
> >  #include <linux/slab.h>
> >  #include <linux/module.h>
> > +#include <linux/timer.h>
> >  #include <linux/bio.h>
> >  #include <linux/blkdev.h>
> >  #include <linux/blktrace_api.h>
> > @@ -486,7 +487,7 @@ static void blk_release_queue(struct kob
> >                __blk_queue_free_tags(q);
> >
> >        blk_trace_shutdown(q);
> > -
> > +       del_timer_sync(&q->backing_dev_info.wb.wakeup_timer);
> >        bdi_destroy(&q->backing_dev_info);
> >        kmem_cache_free(blk_requestq_cachep, q);
> >  }
> > _
> >

I have no physical access to the machines showing the issue for a day
or 10 and it appears to be not very reproducable on my own machines:
I got only one trace so far (with a pristine 3.0.4 tree). I try to make
it more reproducable before trying out the above patch. So, it will take
some time before I have conclusive information on this.

-- 
Frank
