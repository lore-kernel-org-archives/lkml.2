Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933519Ab0HER2h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 13:28:37 -0400
Received: from kroah.org ([198.145.64.141]:42709 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388Ab0HER2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 13:28:35 -0400
Date: Thu, 5 Aug 2010 10:25:54 -0700
From: Greg KH <greg@kroah.com>
To: Thomas Renninger <trenn@suse.de>
Cc: Jason Baron <jbaron@redhat.com>, yehuda@hq.newdream.net,
        LKML <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Dynamic Debug: Introduce global fake module param
 module.ddebug
Message-ID: <20100805172554.GA12234@kroah.com>
References: <201007261414.30718.trenn@suse.de>
 <20100805153910.GB2930@redhat.com>
 <201008051805.40730.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201008051805.40730.trenn@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
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
> If not, possibly a keyword like file/module called "all" could be added.
> Then you could simply do that by ddebug_query="all +p"
> 
> > We also need to at least remove the 'dynamic_printk' doc from
> > kernel-parameters.txt.
> Don't know about this one.
> 
> So, I have your acked-by for this one?
> Let's get this pushed into a tree, with some luck it still could make it
> into 2.6.36? The other three have been taken by Pekka? He said something
> about taking them, but I haven't received any confirmation.
> Ah no, he acked-by them only.

It's too late for .36 as none of this has been tested in linux-next yet.
How about for .37?

thanks,

greg k-h
