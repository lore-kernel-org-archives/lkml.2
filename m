Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab1GROuw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 10:50:52 -0400
Received: from mail.perches.com ([173.55.12.10]:4121 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529Ab1GROut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 10:50:49 -0400
Subject: Re: [PATCH 11/11 re-post] dynamic_debug: use a single printk() to
 emit msgs
From: Joe Perches <joe@perches.com>
To: Jason Baron <jbaron@redhat.com>
Cc: Bart Van Assche <bvanassche@acm.org>, jim.cromie@gmail.com,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <20110718143036.GB2457@redhat.com>
References: <cover.1310657068.git.jbaron@redhat.com>
	 <3667c0a87dd8fd64fdf1b1e8107b130a9b41096e.1310657068.git.jbaron@redhat.com>
	 <CAO+b5-qA3s92YX2izXzvzt3MOrzRaPcZtDtK0cDte0ZXnRWxhA@mail.gmail.com>
	 <1310744914.7582.36.camel@Joe-Laptop>
	 <CAO+b5-p2B74+oVQRGcGxMp5ULZy8ZmF215Lz4qhbU=C4RnG8dw@mail.gmail.com>
	 <20110715160417.GB2493@redhat.com>
	 <CAO+b5-qgrV=gfZAczxfPbGqVtv4ZD_zZHOn-BMVY9wnJytbrtw@mail.gmail.com>
	 <1310746580.7582.50.camel@Joe-Laptop> <20110715195903.GA7470@redhat.com>
	 <1310773591.10603.9.camel@Joe-Laptop>  <20110718143036.GB2457@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jul 2011 07:50:48 -0700
Message-ID: <1311000648.2286.66.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-18 at 10:30 -0400, Jason Baron wrote:
> On Fri, Jul 15, 2011 at 04:46:31PM -0700, Joe Perches wrote:
> > On Fri, 2011-07-15 at 15:59 -0400, Jason Baron wrote:
> > > diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
> > > +#define LEFT(wrote) ((PREFIX_SIZE - wrote) > 0) ? (PREFIX_SIZE - wrote) : 0
[]
> > > +	pos += snprintf(buf + pos, LEFT(pos), "%s", KERN_DEBUG);
> > > +	if (desc->flags & _DPRINTK_FLAGS_INCL_TID) {
> > >  		if (in_interrupt())
> > > -			snprintf(tid, sizeof(tid), "%s", "<intr> ");
> > > +			pos += snprintf(buf + pos, LEFT(pos), "%s ",
> > > +						"<intr>");
> > scnprintf works without using LEFT.
> > snprintf does as well.
> > http://lkml.org/lkml/2010/7/23/375
> So you're saying, just pass (PREFIX_SIZE - pos), as the second argument?

Yes.

> I see kernel code written both ways.

Perhaps one consistently used style is better than two.
 
> I think it's fine as written, unless you feel
> strongly about this.

You're the maintainer, do what you think best.

cheers, Joe

