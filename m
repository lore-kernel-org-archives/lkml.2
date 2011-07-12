Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab1GLUuL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 16:50:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48260 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754845Ab1GLUuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 16:50:09 -0400
Date: Tue, 12 Jul 2011 16:50:01 -0400
From: Jason Baron <jbaron@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: Jim Cromie <jim.cromie@gmail.com>, linux-kernel@vger.kernel.org,
        bvanassche@acm.org, gregkh@suse.de, gnb@fmeh.org
Subject: Re: [PATCH 21/21] dynamic_debug: delete pending queries
Message-ID: <20110712205000.GA2500@redhat.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
 <1310370416-6322-1-git-send-email-jim.cromie@gmail.com>
 <1310370416-6322-22-git-send-email-jim.cromie@gmail.com>
 <1310430335.3550.3.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310430335.3550.3.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 05:25:35PM -0700, Joe Perches wrote:
> On Mon, 2011-07-11 at 01:46 -0600, Jim Cromie wrote:
> > delete pending queries by re-issuing it with disabled flags
> []
> > diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
> []
> > @@ -505,7 +505,17 @@ static int ddebug_save_pending(struct ddebug_query *query,
> >  
> >  	list_for_each_entry_safe(pq, pqnext, &pending_queries, link) {
> >  		if (queries_match(query, &pq->query)) {
> > -			/* query already in list, update flags */
> > +			/* query already in list */
> > +			if (!flags) {
> > +				/* zeroed flags, remove query */
> > +				if (verbose)
> > +					pr_info("delete pending: %s\n",
> > +						show_pending_query(pq));
> 
> I think these should be pr_debug.
> I know you're only using the current style.
> 
> Jason, any reason these can not be converted?
> 

it should be ok, although we have to be careful not to use them in the
printing path, since that will cause a recursion.

Also, if there is an issue with the dynamic debug code, it makes it more
of a pain to debug :)

-Jason
