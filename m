Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab1CJO7t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 09:59:49 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:52308 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798Ab1CJO7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 09:59:48 -0500
Subject: Re: [PATCH R4 7/7] xen/balloon: Memory hotplug support for Xen
 balloon driver
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Daniel Kiper <dkiper@net-space.pl>
Cc: ian.campbell@citrix.com, akpm@linux-foundation.org, andi.kleen@intel.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        konrad.wilk@oracle.com, dan.magenheimer@oracle.com,
        v.tolstov@selfip.ru, pasik@iki.fi, wdauchy@gmail.com,
        rientjes@google.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20110310090207.GB13978@router-fw-old.local.net-space.pl>
References: <20110308215049.GH27331@router-fw-old.local.net-space.pl>
	 <1299628939.9014.3499.camel@nimitz>
	 <20110310090207.GB13978@router-fw-old.local.net-space.pl>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 10 Mar 2011 06:59:25 -0800
Message-ID: <1299769165.8937.2435.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-10 at 10:02 +0100, Daniel Kiper wrote:
> On Tue, Mar 08, 2011 at 04:02:19PM -0800, Dave Hansen wrote:
> > > +	mutex_lock(&balloon_mutex);
> > > +
> > > +	__balloon_append(page);
> > > +
> > > +	if (balloon_stats.hotplug_pages)
> > > +		--balloon_stats.hotplug_pages;
> > > +	else
> > > +		--balloon_stats.balloon_hotplug;
> > > +
> > > +	mutex_unlock(&balloon_mutex);
> > > +
> > > +	return NOTIFY_STOP;
> > > +}
> >
> > I'm not a _huge_ fan of these notifier chains, but I guess it works.
> 
> Could you tell me why ??? I think that in that case new
> (faster, simpler, etc.) mechanism is an overkill. I prefer
> to use something which is writen, tested and ready for usage.

Personally, I find it much harder to figure out what's going on there
than if we had some #ifdefs or plain old function calls.  

It would be one thing if we really had a large or undefined set of
things that needs to interact here, but we really just need to
conditionally free the page either in to the buddy allocator or back to
Xen.  I think that calls for a simpler mechanism than notifier_blocks.

-- Dave

