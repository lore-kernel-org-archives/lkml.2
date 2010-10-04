Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364Ab0JDW7e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 18:59:34 -0400
Received: from mail.perches.com ([173.55.12.10]:2641 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752073Ab0JDW7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 18:59:32 -0400
Subject: Re: [PATCH] serial8250: ratelimit "too much work" error
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Drake <dsd@laptop.org>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Greg KH <greg@kroah.com>
In-Reply-To: <20101004152102.1e04f30a.akpm@linux-foundation.org>
References: <20101002110438.801F49D401B@zog.reactivated.net>
	 <20101004145101.b28fdc0a.akpm@linux-foundation.org>
	 <20101004150238.fbc1b6cf.akpm@linux-foundation.org>
	 <1286230259.10512.81.camel@Joe-Laptop>
	 <20101004152102.1e04f30a.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Oct 2010 15:59:29 -0700
Message-ID: <1286233169.10512.85.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-04 at 15:21 -0700, Andrew Morton wrote:
> On Mon, 04 Oct 2010 15:10:59 -0700
> Joe Perches <joe@perches.com> wrote:
> > On Mon, 2010-10-04 at 15:02 -0700, Andrew Morton wrote:
> > > On Mon, 4 Oct 2010 14:51:01 -0700
> > > Andrew Morton <akpm@linux-foundation.org> wrote:
> > > I'll give up and pronounce that users of printk_ratelimited() need to
> > > include ratelimit.h as well.
> > What I suggested several months ago was to move the
> > macro definitions to ratelimit.h
> > http://lkml.org/lkml/2010/2/18/377
> That's a bit nasty because at present ratelimit.h is purely about
> ratelimiting and knowns nothing about any of its clients.  At present
> it has only one client (printk), but it could have more in the future!

Look at the structure, it's very specific to
message logging functionality.

struct ratelimit_state {
	spinlock_t	lock;		/* protect the state */

	int		interval;
	int		burst;
	int		printed;
	int		missed;
	unsigned long	begin;
};

I think it's likely that the current ratelimit
will not be used for any other function.


