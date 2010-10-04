Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421Ab0JDXeI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 19:34:08 -0400
Received: from mail.perches.com ([173.55.12.10]:2647 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757409Ab0JDXeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 19:34:07 -0400
Subject: Re: [PATCH] serial8250: ratelimit "too much work" error
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Drake <dsd@laptop.org>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Greg KH <greg@kroah.com>
In-Reply-To: <20101004161139.2a988b85.akpm@linux-foundation.org>
References: <20101002110438.801F49D401B@zog.reactivated.net>
	 <20101004145101.b28fdc0a.akpm@linux-foundation.org>
	 <20101004150238.fbc1b6cf.akpm@linux-foundation.org>
	 <1286230259.10512.81.camel@Joe-Laptop>
	 <20101004152102.1e04f30a.akpm@linux-foundation.org>
	 <1286233169.10512.85.camel@Joe-Laptop>
	 <20101004161139.2a988b85.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Oct 2010 16:34:05 -0700
Message-ID: <1286235245.10512.91.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-04 at 16:11 -0700, Andrew Morton wrote:
> On Mon, 04 Oct 2010 15:59:29 -0700
> Joe Perches <joe@perches.com> wrote:
> > On Mon, 2010-10-04 at 15:21 -0700, Andrew Morton wrote:
> > > On Mon, 04 Oct 2010 15:10:59 -0700
> > > Joe Perches <joe@perches.com> wrote:
> > > > On Mon, 2010-10-04 at 15:02 -0700, Andrew Morton wrote:
> > > > > On Mon, 4 Oct 2010 14:51:01 -0700
> > > > > Andrew Morton <akpm@linux-foundation.org> wrote:
> > > > > I'll give up and pronounce that users of printk_ratelimited() need to
> > > > > include ratelimit.h as well.
> > > > What I suggested several months ago was to move the
> > > > macro definitions to ratelimit.h
> > > > http://lkml.org/lkml/2010/2/18/377
> > > That's a bit nasty because at present ratelimit.h is purely about
> > > ratelimiting and knowns nothing about any of its clients.  At present
> > > it has only one client (printk), but it could have more in the future!
> > 
> > Look at the structure, it's very specific to
> > message logging functionality.
> > 
> > struct ratelimit_state {
> > 	spinlock_t	lock;		/* protect the state */
> > 
> > 	int		interval;
> > 	int		burst;
> > 	int		printed;
> > 	int		missed;
> > 	unsigned long	begin;
> > };
> 
> s/printed/hit/there,fixed
> 
> This is at present a quite general facility.
> 
> > I think it's likely that the current ratelimit
> > will not be used for any other function.
> 
> Filling it up with printk-specific stuff will help ensure that.

Interval too because it is in seconds and likely
should be in timespec or jiffies.

For what other facility could you see ratelimit_state
be used for?

Putting the printk specific uses in the .h file
would make sure that the users of ratelimit use
the proper file and reduce the #include dependencies.



