Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933148Ab0HER0z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 13:26:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39502 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754117Ab0HER0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 13:26:53 -0400
Date: Thu, 5 Aug 2010 13:26:15 -0400
From: Jason Baron <jbaron@redhat.com>
To: Thomas Renninger <trenn@suse.de>, greg@kroah.com
Cc: yehuda@hq.newdream.net, LKML <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Dynamic Debug: Introduce global fake module param
	module.ddebug
Message-ID: <20100805172615.GC2930@redhat.com>
References: <201007261414.30718.trenn@suse.de> <20100805153910.GB2930@redhat.com> <201008051805.40730.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201008051805.40730.trenn@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 06:05:40PM +0200, Thomas Renninger wrote:
> On Thursday 05 August 2010 17:39:10 Jason Baron wrote:
> > On Mon, Jul 26, 2010 at 02:14:30PM +0200, Thomas Renninger wrote:
> > > This patch is based on 2.6.35-rc5 + this patchset I posted recently:                                                           
> > > [patch 0/3] Dynamic Debug providing early boot debug messages via
> > > boot parameter
> > > 
> > > It would be great to see these getting merged into 2.6.36...
> ... 
> > patch looks pretty good to me. I'm not sure how we reserve the
> > 'ddebug' keyword.
> Yep, I also was not sure about that.
> > However, I think its probably ok, if we mention it
> > in 'kernel-parameters.txt' and in the dynamic debug documentation.
> I added some documentation to the dynamic debug docu file and posted
> the patch again (as a reply on my initial post, should be the same mail
> thread).
> 
> > Also, ddebug could show up in /sys/module/$(modulename}/parameters/ ,
> > but this can probably be done in a followup patch.
> This was intentional.
> At the time /sys is available one can also use 
> /sys/kernel/debug/dynamic_debug/control
> echo "module my_module_to_debug +p"
>           >/sys/kernel/debug/dynamic_debug/control
> would exactly do the same as /sys/module/$(modulename}/parameters
> The advantage of not having it, is it saves quite some resources, in 
> fact it uses none.
> Otherwise every module would have an addtional parameter added with a
> sysfs file associated with it with no additional functional gain.
> 
> > Also, if 'ddebug' alone is set on the kernel command line, i'd like to
> > see us enable all debug statements. We could implement this by adding
> > a special 'meta' module to the control file which is just has a module
> > name of of 'All' or something like that. This could also be done in a
> > subsequent patch.
> Is there a single query which could do it?

I don't think so.

> If not, possibly a keyword like file/module called "all" could be added.
> Then you could simply do that by ddebug_query="all +p"
> 

ok. that makes sense. I would make the all mode apply to all future
modules that get loaded as well, just to be clear...

> > We also need to at least remove the 'dynamic_printk' doc from
> > kernel-parameters.txt.
> Don't know about this one.
> 
> So, I have your acked-by for this one?

Acked-by: Jason Baron <jbaron@redhat.com>

> Let's get this pushed into a tree, with some luck it still could make it
> into 2.6.36? The other three have been taken by Pekka? He said something
> about taking them, but I haven't received any confirmation.
> Ah no, he acked-by them only.
> 
> As these are rather general ones, which tree should they go through, 
> possibly Andrew could take them?
> I can resubmit, if someone could tell me a list/maintainer that fits 
> best, so that they really make it in...
> 
> Thanks,
> 
>          Thomas

right, originally Greg KH, pulled these into his tree. Greg, can you take
a look at pulling these into your tree? So it would be this patch, and the
thread:

Subject: [patch 0/3] Dynamic Debug providing early boot debug messages via boot parameter

thanks,

-Jason
