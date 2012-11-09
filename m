Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676Ab2KIUPr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 15:15:47 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:37293 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079Ab2KIUPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 15:15:46 -0500
Subject: Re: [PATCH v3 1/9] net: core: use this_cpu_ptr per-cpu helper
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Shan Wei <shanwei88@gmail.com>, David Miller <davem@davemloft.net>,
        timo.teras@iki.fi, steffen.klassert@secunet.com,
        NetDev <netdev@vger.kernel.org>,
        Kernel-Maillist <linux-kernel@vger.kernel.org>
In-Reply-To: <0000013ae6c9e81a-eabe295b-72a5-4ebd-85c5-231bec1a70c5-000000@email.amazonses.com>
References: <509C686F.20400@gmail.com>
	 <0000013ae6c9e81a-eabe295b-72a5-4ebd-85c5-231bec1a70c5-000000@email.amazonses.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Nov 2012 12:15:44 -0800
Message-ID: <1352492144.19779.811.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-09 at 20:08 +0000, Christoph Lameter wrote:
> On Fri, 9 Nov 2012, Shan Wei wrote:
> 
> > diff --git a/net/core/flow.c b/net/core/flow.c
> > index e318c7e..b0901ee 100644
> > --- a/net/core/flow.c
> > +++ b/net/core/flow.c
> > @@ -327,11 +327,9 @@ static void flow_cache_flush_tasklet(unsigned long data)
> >  static void flow_cache_flush_per_cpu(void *data)
> >  {
> >  	struct flow_flush_info *info = data;
> > -	int cpu;
> >  	struct tasklet_struct *tasklet;
> >
> > -	cpu = smp_processor_id();
> > -	tasklet = &per_cpu_ptr(info->cache->percpu, cpu)->flush_tasklet;
> > +	tasklet = this_cpu_ptr(&info->cache->percpu->flush_tasklet);
> >  	tasklet->data = (unsigned long)info;
> 
> this_cpu_write(info->cache->percpu->flush_tasklet->data, (unsigned
> 	long)info);
> 
> should also do the trick in less instructions and get rid of all temporary
> variables as well.

Its not the case.

We need the _pointer_ to call :

tasklet_schedule(tasklet);




