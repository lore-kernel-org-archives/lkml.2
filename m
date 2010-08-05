Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933616Ab0HEQC2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 12:02:28 -0400
Received: from cantor.suse.de ([195.135.220.2]:47940 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933577Ab0HEQC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 12:02:26 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH] Dynamic Debug: Introduce global fake module param module.ddebug
Date: Thu, 5 Aug 2010 18:05:40 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.31.5-0.1-desktop; KDE/4.4.3; x86_64; ; )
Cc: yehuda@hq.newdream.net, LKML <linux-kernel@vger.kernel.org>,
        greg@kroah.com, Pekka Enberg <penberg@cs.helsinki.fi>,
        Andrew Morton <akpm@linux-foundation.org>
References: <201007261414.30718.trenn@suse.de> <20100805153910.GB2930@redhat.com>
In-Reply-To: <20100805153910.GB2930@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008051805.40730.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 August 2010 17:39:10 Jason Baron wrote:
> On Mon, Jul 26, 2010 at 02:14:30PM +0200, Thomas Renninger wrote:
> > This patch is based on 2.6.35-rc5 + this patchset I posted recently:                                                           
> > [patch 0/3] Dynamic Debug providing early boot debug messages via
> > boot parameter
> > 
> > It would be great to see these getting merged into 2.6.36...
... 
> patch looks pretty good to me. I'm not sure how we reserve the
> 'ddebug' keyword.
Yep, I also was not sure about that.
> However, I think its probably ok, if we mention it
> in 'kernel-parameters.txt' and in the dynamic debug documentation.
I added some documentation to the dynamic debug docu file and posted
the patch again (as a reply on my initial post, should be the same mail
thread).

> Also, ddebug could show up in /sys/module/$(modulename}/parameters/ ,
> but this can probably be done in a followup patch.
This was intentional.
At the time /sys is available one can also use 
/sys/kernel/debug/dynamic_debug/control
echo "module my_module_to_debug +p"
          >/sys/kernel/debug/dynamic_debug/control
would exactly do the same as /sys/module/$(modulename}/parameters
The advantage of not having it, is it saves quite some resources, in 
fact it uses none.
Otherwise every module would have an addtional parameter added with a
sysfs file associated with it with no additional functional gain.

> Also, if 'ddebug' alone is set on the kernel command line, i'd like to
> see us enable all debug statements. We could implement this by adding
> a special 'meta' module to the control file which is just has a module
> name of of 'All' or something like that. This could also be done in a
> subsequent patch.
Is there a single query which could do it?
If not, possibly a keyword like file/module called "all" could be added.
Then you could simply do that by ddebug_query="all +p"

> We also need to at least remove the 'dynamic_printk' doc from
> kernel-parameters.txt.
Don't know about this one.

So, I have your acked-by for this one?
Let's get this pushed into a tree, with some luck it still could make it
into 2.6.36? The other three have been taken by Pekka? He said something
about taking them, but I haven't received any confirmation.
Ah no, he acked-by them only.

As these are rather general ones, which tree should they go through, 
possibly Andrew could take them?
I can resubmit, if someone could tell me a list/maintainer that fits 
best, so that they really make it in...

Thanks,

         Thomas
