Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758573Ab1D2Uuo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 16:50:44 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:45032 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721Ab1D2Uum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 16:50:42 -0400
Date: Fri, 29 Apr 2011 14:50:39 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Colin Cross <ccross@google.com>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Kevin Hilman <khilman@ti.com>, LKML <linux-kernel@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, linux-sh@vger.kernel.org,
        lethal@linux-sh.org, Magnus Damm <magnus.damm@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>
Subject: Re: [Update][PATCH 7/9] PM / Runtime: Generic clock manipulation
 rountines for runtime PM (v3)
Message-ID: <20110429205039.GB7497@ponder.secretlab.ca>
References: <201104130205.26988.rjw@sisk.pl>
 <201104272348.24084.rjw@sisk.pl>
 <BANLkTimHkKq9+0z-4CZs=34GNO6Ab0wZPQ@mail.gmail.com>
 <201104280258.34694.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201104280258.34694.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 02:58:34AM +0200, Rafael J. Wysocki wrote:
> On Thursday, April 28, 2011, Colin Cross wrote:
> > On Wed, Apr 27, 2011 at 2:48 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > +void pm_runtime_clk_remove(struct device *dev, const char *con_id)
> > > +{
> > > +       struct pm_runtime_clk_data *prd = __to_prd(dev);
> > > +       struct pm_clock_entry *ce;
> > > +
> > > +       if (!prd)
> > > +               return;
> > > +
> > > +       mutex_lock(&prd->lock);
> > > +
> > > +       list_for_each_entry(ce, &prd->clock_list, node)
> > Braces
> 
> No, this is correct as is.

The code is correct, but Colin's comment is valid.  Braces do make it
easier for a reader to properly interpret the scope of large multiline
blocks, even if it does resolve to a single statement.

g.

> 
> > > +               if (!con_id && !ce->con_id) {
> > > +                       __pm_runtime_clk_remove(ce);
> > > +                       break;
> > > +               } else if (!con_id || !ce->con_id) {
> > > +                       continue;
> > > +               } else if (!strcmp(con_id, ce->con_id)) {
> > > +                       __pm_runtime_clk_remove(ce);
> > > +                       break;
> > > +               }
> > > +
> > > +       mutex_unlock(&prd->lock);
> > > +}
