Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456Ab2GDMBY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 08:01:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11384 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877Ab2GDMBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 08:01:21 -0400
Date: Wed, 4 Jul 2012 14:00:55 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, eranian@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/10] perf, x86: Making hardware events translations
 available in sysfs
Message-ID: <20120704120055.GD960@krava.redhat.com>
References: <1341352848-11833-1-git-send-email-jolsa@redhat.com>
 <1341352848-11833-5-git-send-email-jolsa@redhat.com>
 <1341397494.2507.88.camel@laptop>
 <1341397738.2507.92.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341397738.2507.92.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 04, 2012 at 12:28:58PM +0200, Peter Zijlstra wrote:
> On Wed, 2012-07-04 at 12:24 +0200, Peter Zijlstra wrote:
> > On Wed, 2012-07-04 at 00:00 +0200, Jiri Olsa wrote:
> > > +static struct attribute *events_attr[] = {
> > > +       &event_attr_cycles.attr,
> > > +       &event_attr_instructions.attr,
> > > +       &event_attr_cache_references.attr,
> > > +       &event_attr_cache_misses.attr,
> > > +       &event_attr_branch_instructions.attr,
> > > +       &event_attr_branch_misses.attr,
> > > +       &event_attr_bus_cycles.attr,
> > > +       &event_attr_stalled_cycles_frontend.attr,
> > > +       &event_attr_stalled_cycles_backend.attr,
> > > +       &event_attr_ref_cycles.attr,
> > > +       NULL,
> > > +}; 
> > 
> > Hmm, should we do:
> > 
> >   if (!config)
> >     return -EINVAL;
> > 
> > or somesuch to clearly indicate an event isn't supported?
> > 
> > Its currently a bit of a mixed bag between 0 and -1.. we might want to
> > clean that up too.
> 
> Alternatively, we'd do something like:
> 
>   for (i = 0; events_attr[i]; i++) {
>     if (x86_pmu.event_map(i))
>       continue;
> 
>     for (j = i; events_attr[j]; j++)
>       events_attr[j] = events_attr[j+1];
>   }
> 
> On init to filter out all unset events so they don't even show up in
> sysfs.
>       
> 

ok
