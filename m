Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416Ab1BLAuk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 19:50:40 -0500
Received: from router-fw.net-space.pl ([89.174.63.77]:44055 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842Ab1BLAuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 19:50:39 -0500
Date: Sat, 12 Feb 2011 01:50:04 +0100
From: Daniel Kiper <dkiper@net-space.pl>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Daniel Kiper <dkiper@net-space.pl>, jeremy@goop.org,
        xen-devel@lists.xensource.com, ian.campbell@citrix.com,
        haicheng.li@linux.intel.com, linux-kernel@vger.kernel.org,
        dan.magenheimer@oracle.com, v.tolstov@selfip.ru,
        dave@linux.vnet.ibm.com, linux-mm@kvack.org, rientjes@google.com,
        andi.kleen@intel.com, akpm@linux-foundation.org,
        fengguang.wu@intel.com, wdauchy@gmail.com
Subject: Re: [Xen-devel] Re: [PATCH R3 5/7] xen/balloon: Protect against CPU exhaust by event/x proces
Message-ID: <20110212005004.GA10853@router-fw-old.local.net-space.pl>
References: <20110203162851.GH1364@router-fw-old.local.net-space.pl> <20110210155142.GC12087@dumpdata.com> <20110210171020.GB3993@dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110210171020.GB3993@dumpdata.com>
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 12:10:20PM -0500, Konrad Rzeszutek Wilk wrote:
> On Thu, Feb 10, 2011 at 10:51:42AM -0500, Konrad Rzeszutek Wilk wrote:
> > On Thu, Feb 03, 2011 at 05:28:51PM +0100, Daniel Kiper wrote:
> > > Protect against CPU exhaust by event/x process during
> > > errors by adding some delays in scheduling next event.
> > >
> > > Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
> > > ---
> > >  drivers/xen/balloon.c |   99 +++++++++++++++++++++++++++++++++++++++---------
> > >  1 files changed, 80 insertions(+), 19 deletions(-)
> > >
> > > diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
> > > index 4223f64..ed103d4 100644
> > > --- a/drivers/xen/balloon.c
> > > +++ b/drivers/xen/balloon.c
> > > @@ -66,6 +66,20 @@
> > >
> > >  #define BALLOON_CLASS_NAME "xen_memory"
> > >
> > > +/*
> > > + * balloon_process() state:
> > > + *
> > > + * BP_ERROR: error, go to sleep,
> > > + * BP_DONE: done or nothing to do,
> > > + * BP_HUNGRY: hungry.
> > > + */
> > > +
> > > +enum bp_state {
> > > +	BP_ERROR,
> >
> > BP_EAGAIN?
> >
> > So if we fail to increase the first hour, we would keep on trying to
> > increase forever (with a 32 second delay between each call). Do you
> > think it makes sense (as a future patch, not tied in with this patchset)
> > to printout a printk(KERN_INFO that we have been trying to increase
> > for the last X hours, seconds and have not gone anywhere (and perhaps
> > stop trying to allocate more memory?).
>
> Duh, you did that in the next patch with the mh_policy.

No problem. You showed me that I could improve that. Thx.

Daniel
