Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab0EJM1g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 08:27:36 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38491 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab0EJM1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 08:27:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iTyqwncqdDMHZcUbFIclzHRdcKOmpO6t3f/6yqdzv3Cu3o5IZrCjsYPRMiExvEmiHh
         jwjp9mmW0PeUwMiybkftz47AAg5gY13/dFg4ZGNJ+PYMSVeZHfl5M3/V6TA3FuIbga43
         ZVG7GNeUVq9cmvJBG6wgHKWs3mHJngKdYVcMc=
Date: Mon, 10 May 2010 14:27:30 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 2/9] perf: core, remove hw_perf_event_init
Message-ID: <20100510122728.GB5563@nowhere>
References: <1273483595.15998.56.camel@minggr.sh.intel.com> <1273484430.5605.3334.camel@twins> <1273486670.15998.80.camel@minggr.sh.intel.com> <1273486769.5605.3343.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273486769.5605.3343.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 10, 2010 at 12:19:29PM +0200, Peter Zijlstra wrote:
> On Mon, 2010-05-10 at 18:17 +0800, Lin Ming wrote:
> > On Mon, 2010-05-10 at 17:40 +0800, Peter Zijlstra wrote:
> > > On Mon, 2010-05-10 at 17:26 +0800, Lin Ming wrote:
> > > > +static struct pmu *perf_event_lookup_pmu(struct perf_event *event)
> > > > +{
> > > > +       struct pmu *pmu;
> > > > +       int pmu_id = event->attr.pmu_id;
> > > > +
> > > > +       list_for_each_entry(pmu, &pmus, entry) {
> > > > +               if (pmu->id == pmu_id)
> > > > +                       return pmu;
> > > > +       }
> > > > +
> > > > +       return NULL;
> > > > +}
> > > 
> > > > +void perf_event_register_pmu(struct pmu *pmu)
> > > > +{
> > > > +       pmu->id = pmu_id_curr++;
> > > > +       list_add_tail(&pmu->entry, &pmus);
> > > > +} 
> > > 
> > > That will be wanting some sort of synchronization
> > 
> > Will add a mutex to protect the list of pmus.
> 
> I'm thinking RCU might be better suited, a mutex for lookup doesn't
> sound ideal.


Is it really needed? I expect this function to be called on boot
only.

In fact I would even suggest to tag it as __init.

