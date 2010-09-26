Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676Ab0IZA5E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 20:57:04 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:42760 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754013Ab0IZA5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 20:57:02 -0400
Date: Sat, 25 Sep 2010 17:56:36 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Nishanth Menon <nm@ti.com>, linux-pm <linux-pm@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        linux-omap <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v4] power: introduce library for device-specific OPPs
Message-ID: <20100926005636.GB3396@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1285332640-16736-1-git-send-email-nm@ti.com>
 <20100924193742.GJ2375@linux.vnet.ibm.com>
 <201009252255.20933.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009252255.20933.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 25, 2010 at 10:55:20PM +0200, Rafael J. Wysocki wrote:
> On Friday, September 24, 2010, Paul E. McKenney wrote:
> > On Fri, Sep 24, 2010 at 07:50:40AM -0500, Nishanth Menon wrote:
> ...
> > 
> > Looks like a good start!!!  Some questions and suggestions about RCU
> > usage interspersed below.
> ...
> > > + * Locking: RCU reader.
> > > + */
> > > +int opp_get_opp_count(struct device *dev)
> > > +{
> > > +	struct device_opp *dev_opp;
> > > +	struct opp *temp_opp;
> > > +	int count = 0;
> > > +
> > > +	dev_opp = find_device_opp(dev);
> > > +	if (IS_ERR(dev_opp))
> > > +		return PTR_ERR(dev_opp);
> > > +
> > > +	rcu_read_lock();
> > > +	list_for_each_entry_rcu(temp_opp, &dev_opp->opp_list, node) {
> > > +		if (temp_opp->available)
> > > +			count++;
> > > +	}
> > > +	rcu_read_unlock();
> > 
> > This one is OK as well.  You are returning a count, so if all of the
> > counted structures are freed at this point, no problem.  The count was
> > valid when it was accumulated, and the fact that it might now be obsolete
> > is (usually) not a problem.
> 
> However, it looks like it should run rcu_read_lock() before calling
> find_device_opp(dev), shouldn't it?

Indeed it does appear that you are right -- good catch!!!

							Thanx, Paul
