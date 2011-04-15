Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab1DOPVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 11:21:18 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:38248 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754969Ab1DOPVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 11:21:14 -0400
Subject: Re: [PATCH] fix sparse happy borkage when including gfp.h
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-sparse@vger.kernel.org
In-Reply-To: <20110415143259.F7BD.A69D9226@jp.fujitsu.com>
References: <20110415121424.F7A6.A69D9226@jp.fujitsu.com>
	 <1302844066.16562.1953.camel@nimitz>
	 <20110415143259.F7BD.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Fri, 15 Apr 2011 07:27:54 -0700
Message-ID: <1302877674.16562.3089.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-15 at 14:33 +0900, KOSAKI Motohiro wrote:
> Hello,
> > On Fri, 2011-04-15 at 12:14 +0900, KOSAKI Motohiro wrote:
> > > >  #ifdef CONFIG_DEBUG_VM
> > > > -             BUG_ON((GFP_ZONE_BAD >> bit) & 1);
> > > > +     BUG_ON((GFP_ZONE_BAD >> bit) & 1);
> > > >  #endif
> > > > -     }
> > > >       return z;
> > > 
> > > Why don't you use VM_BUG_ON?
> > 
> > I was just trying to make a minimal patch that did a single thing.
> > 
> > Feel free to submit another one that does that.  I'm sure there are a
> > couple more places that could use similar love.
> 
> I posted another approach patches a second ago. Could you please see it?

Those both look sane to me.  Those weren't biting me in particular, and
they don't fix the issue I was seeing.  But, they do seem necessary to
reduce some of the noise.

CC'ing the sparse mailing list.  We're seeing a couple of cases where
some gcc-isms are either stopping sparse from finding real bugs:

	http://marc.info/?l=linux-mm&m=130282454732689&w=2

or creating a lot of noise on some builds:

	http://marc.info/?l=linux-mm&m=130284428614058&w=2
	http://marc.info/?l=linux-mm&m=130284431014077&w=2

-- Dave

