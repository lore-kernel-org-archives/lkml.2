Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758947Ab0HEXrp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 19:47:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43430 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755601Ab0HEXrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 19:47:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kevin Hilman <khilman@deeprootsystems.com>
Subject: Re: [PATCH v2] pm: Add runtime PM statistics
Date: Fri, 6 Aug 2010 01:45:28 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Arjan van de Ven <arjan@infradead.org>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Ming Lei <tom.leiming@gmail.com>
References: <20100710095254.5ab7291c@infradead.org> <4C3F2CEF.2090404@linux.intel.com> <87bp9gpryb.fsf@deeprootsystems.com>
In-Reply-To: <87bp9gpryb.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008060145.28969.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 06, 2010, Kevin Hilman wrote:
> Arjan van de Ven <arjan@linux.intel.com> writes:
> 
> > +
> > +/**
> > + * update_pm_runtime_accounting - Update the time accounting of power
> > states
> > + * @dev: Device to update the accounting for
> > + *
> > + * In order to be able to have time accounting of the various power states
> > + * (as used by programs such as PowerTOP to show the effectiveness of
> > runtime
> > + * PM), we need to track the time spent in each state.
> > + * update_pm_runtime_accounting must be called each time before the
> > + * runtime_status field is updated, to account the time in the old state
> > + * correctly.
> > + */
> > +void update_pm_runtime_accounting(struct device *dev)
> > +{
> > +    unsigned long now = jiffies;
> > +    int delta;
> > +
> > +    delta = now - dev->power.accounting_timestamp;
> > +
> > +    if (delta < 0)
> > +        delta = 0;
> > +
> > +    dev->power.accounting_timestamp = now;
> > +
> > +    if (dev->power.disable_depth > 0)
> > +        return;
> > +
> > +    if (dev->power.runtime_status == RPM_SUSPENDED)
> > +        dev->power.suspended_jiffies += delta;
> > +    else
> > +        dev->power.active_jiffies += delta;
> > +}
> 
> By using jiffies, I think we might miss events in drivers that are doing
> runtime PM transitions in short bursts.  On embedded systems with slow
> HZ, there could potentially be lots of transitions between ticks.
> 
> It would be nicer to use clocksource-based time so transitions between
> jiffies could still be factored into the accounting.

Patch please?

Rafael
