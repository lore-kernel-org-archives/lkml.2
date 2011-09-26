Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058Ab1IZRZT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 13:25:19 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:29006 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab1IZRZR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 13:25:17 -0400
MIME-Version: 1.0
Message-ID: <827ee42e-14e5-468c-b8a2-a24baa251b2d@default>
Date: Mon, 26 Sep 2011 10:24:45 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Konrad Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        David Vrabel <david.vrabel@citrix.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: RE: [PATCH] xen: Fix selfballooning and ensure it doesn't go too far
References: <9827a70d-dfb2-4bbc-9df6-207b10c835ac@default
 20110926172307.GA9973@phenom.oracle.com>
In-Reply-To: <20110926172307.GA9973@phenom.oracle.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4E80B579.00AB:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Konrad Rzeszutek Wilk
> Sent: Monday, September 26, 2011 11:23 AM
> To: Dan Magenheimer
> Cc: linux-kernel@vger.kernel.org; xen-devel@lists.xensource.com; David Vrabel; Jeremy Fitzhardinge
> Subject: Re: [PATCH] xen: Fix selfballooning and ensure it doesn't go too far
> 
> On Sat, Sep 24, 2011 at 01:58:08PM -0700, Dan Magenheimer wrote:
> > [PATCH] xen: Fix selfballooning and ensure it doesn't go too far
> >
> > The balloon driver's "current_pages" is very different from
> > totalram_pages.  Self-ballooning needs to be driven by
> > the latter.  Also, Committed_AS doesn't account for pages
> > used by the kernel so enforce a floor for when there
> > are little or no user-space threads using memory.
> 
> Hey Dan,
> ..
> > +		floor_pages = totalreserve_pages +
> > +				(roundup_pow_of_two(max_pfn) >> 5);
> 
> Would it make sense to make the shift be a runtime argument
> in case some users report problems with that calculation?

Good idea.  I'll take a look at that.

> > +		/* don't balloon too far, lest OOMs occur... */
> > +		if (tgt_pages < floor_pages)
> > +			tgt_pages = floor_pages;
> > +		balloon_set_new_target(tgt_pages +
> > +			balloon_stats.current_pages - totalram_pages);
> >  		reset_timer = true;
> >  	}
> >  #ifdef CONFIG_FRONTSWAP
> 
> Otherwise it looks OK to me. Would you like me to queue it up
> for 3.1-rc7?

Will let you know when I have that change done/tested.

Thanks,
Dan
