Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab1JJT1n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 15:27:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28064 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754325Ab1JJT1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 15:27:42 -0400
Date: Mon, 10 Oct 2011 15:27:32 -0400
From: Jason Baron <jbaron@redhat.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: jim.cromie@gmail.com, joe@perches.com, bart.vanassche@gmail.com,
        greg@kroah.com, linux-kernel@vger.kernel.org, trenn@suse.de
Subject: Re: [PATCH 23/26] dynamic_debug: document pending queries,
 flags-filter, multiple queries
Message-ID: <20111010192732.GB2413@redhat.com>
References: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
 <1316642115-20029-24-git-send-email-jim.cromie@gmail.com>
 <20111010125445.3a1248e4@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111010125445.3a1248e4@bike.lwn.net>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 12:54:45PM -0600, Jonathan Corbet wrote:
> > +
> > +Queries submitted with 'a' are applied to current callsites as above,
> > +but are also added to a pending list.  When a module is loaded later,
> > +pending queries are applied to the module in the order given.
> > +
> > +This is done before the module_init() routine is run, so pr_debug()s
> > +can be active during initialization.  To better support module
> > +debugging, pending queries remain on the list through modprobe-rmmod
> > +cycles.
> 
> So this functionality seems to be the whole point of much of this patch
> set.  That's a lot of stuff to turn on printks during module_init().  I
> can't help but wonder: wouldn't it be easier and better to just recognize
> the ddebug_query= parameter at module load time?  Then you could drop this
> whole pending queries mechanism, the expanded syntax, new control file, and
> so on...?  What am I missing?
> 

Hi,

Thanks for providing feedback on these patches. There was indeed an
earlier approach to do this as a module parameter:

https://lkml.org/lkml/2010/9/15/397

This never quite got merged b/c I believe there were some build issues,
that never got completely resolved. I've added Thomas Renninger, the
author of that earlier appraoch to the 'cc list here.

One concern with the module parameter approach was that it reserves a
module parameter name for all modules, but perhaps if its
'ddebug_query=' that is ok. Also, I think the implmentation was
basically pass 'ddebug' as module param and it becomes:
'ddebug_query=module foo +p'. So perhaps, we could have it pass on a
full query string.

But yes, I agree the module param approach may be simpler...

Thanks,

-Jason
