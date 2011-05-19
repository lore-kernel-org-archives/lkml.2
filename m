Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933314Ab1ESOJI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 10:09:08 -0400
Received: from service87.mimecast.com ([94.185.240.25]:51158 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756945Ab1ESOJG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 10:09:06 -0400
Subject: Re: early kernel crash when kmemleak is enabled
From: Catalin Marinas <catalin.marinas@arm.com>
To: Tejun Heo <tj@kernel.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20110519135425.GI627@htj.dyndns.org>
References: <20110515105505.GA21631@joi.lan>
	 <20110519134218.GH627@htj.dyndns.org>
	 <1305812924.26710.41.camel@e102109-lin.cambridge.arm.com>
	 <20110519135425.GI627@htj.dyndns.org>
Organization: ARM Limited
Date: Thu, 19 May 2011 15:08:53 +0100
Message-ID: <1305814133.26710.69.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 19 May 2011 14:09:00.0592 (UTC) FILETIME=[4D2BBB00:01CC162E]
X-MC-Unique: 111051915085806501
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-19 at 14:54 +0100, Tejun Heo wrote:
> On Thu, May 19, 2011 at 02:48:44PM +0100, Catalin Marinas wrote:
> > Thanks for tracking this down. Untested (I can add a log afterwards):
> >
> > diff --git a/init/main.c b/init/main.c
> > index 4a9479e..48df882 100644
> > --- a/init/main.c
> > +++ b/init/main.c
> > @@ -580,8 +580,8 @@ asmlinkage void __init start_kernel(void)
> >  #endif
> >       page_cgroup_init();
> >       enable_debug_pagealloc();
> > -     kmemleak_init();
> >       debug_objects_mem_init();
> > +     kmemleak_init();
> >       setup_per_cpu_pageset();
> >       numa_policy_init();
> >       if (late_time_init)
> 
> Heh, that was swift.  Yeap, seems to work here.  Please feel free to
> add my Tested-by.

Thanks. I have two other minor kmemleak fixes, so I'll send Linus a pull
request in the next day or so.

-- 
Catalin


