Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370Ab2AXSbA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 13:31:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756192Ab2AXSa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 13:30:58 -0500
Date: Tue, 24 Jan 2012 16:29:09 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: leonid.moiseichuk@nokia.com, rhod@redhat.com, riel@redhat.com,
        minchan@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, rientjes@google.com,
        kosaki.motohiro@gmail.com, hannes@cmpxchg.org,
        akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com
Subject: Re: [RFC 1/3] /dev/low_mem_notify
Message-ID: <20120124182909.GB19186@amt.cnet>
References: <CAOJsxLG4hMrAdsyOg6QUe71SPqEBq3eZXvRvaKFZQo8HS1vphQ@mail.gmail.com>
 <84FF21A720B0874AA94B46D76DB982690455978C@008-AM1MPN1-003.mgdnok.nokia.com>
 <4F175706.8000808@redhat.com>
 <alpine.LFD.2.02.1201190922390.3033@tux.localdomain>
 <4F17DCED.4020908@redhat.com>
 <CAOJsxLG3x_R5xq85hh5RvPoD+nhgYbHJfbLW=YMxCZockAXJqw@mail.gmail.com>
 <4F17E058.8020008@redhat.com>
 <84FF21A720B0874AA94B46D76DB9826904559D46@008-AM1MPN1-003.mgdnok.nokia.com>
 <20120124153835.GA10990@amt.cnet>
 <1327421440.13624.30.camel@jaguar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327421440.13624.30.camel@jaguar>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 06:10:40PM +0200, Pekka Enberg wrote:
> On Tue, 2012-01-24 at 13:38 -0200, Marcelo Tosatti wrote:
> > Having userspace specify the "sample period" for low memory notification
> > makes no sense. The frequency of notifications is a function of the
> > memory pressure.
> 
> Sure, it makes sense to autotune sample period. I don't see the problem
> with letting userspace decide it for themselves if they want to.
> 
> 			Pekka

Application polls on a file descriptor waiting for asynchronous events,
particular conditions of memory reclaim upon which an action is
necessary.

These signalled conditions are not simply percentages of free memory,
but depend on the amount of freeable cache available, etc. Otherwise
applications could monitor /proc/mem_info and act on that.

What is the point of sampling in the interface as you have it?
Application can read() from the file descriptor to retrieve the current
status, if it wishes.

The objective in this argument is to make the API as simple and easy to
use as possible.

