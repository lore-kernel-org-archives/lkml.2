Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964Ab1DHVCM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 17:02:12 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:58230 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753401Ab1DHVCM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 17:02:12 -0400
Subject: Re: [PATCH 1/2] break out page allocation warning code
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: =?UTF-8?Q?Micha=C5=82?= Nazarewicz <mnazarewicz@gmail.com>
Cc: linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <BANLkTi=OnDX53nOZcaaMmqXRBcWicam0xg@mail.gmail.com>
References: <20110408202253.6D6D231C@kernel>
	 <BANLkTi=OnDX53nOZcaaMmqXRBcWicam0xg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Apr 2011 14:02:02 -0700
Message-ID: <1302296522.7286.1197.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-08 at 22:54 +0200, Michał Nazarewicz wrote:
> On Apr 8, 2011 10:23 PM, "Dave Hansen" <dave@linux.vnet.ibm.com> wrote:
> > +       if (fmt) {
> > +               printk(KERN_WARNING);
> > +               va_start(args, fmt);
> > +               r = vprintk(fmt, args);
> > +               va_end(args);
> > +       }
> 
> Could we make the "printk(KERN_WARNING);" go away and require caller
> to specify level?  

The core problem is this: I want two lines of output: one for the
order/mode gunk, and one for the user-specified message.

If we have the user pass in a string for the printk() level, we're stuck
doing what I have here.  If we have them _prepend_ it to the "fmt"
string, then it's harder to figure out below.  I guess we could fish in
the string for it.

> > +       printk(KERN_WARNING);
> > +       printk("%s: page allocation failure: order:%d, mode:0x%x\n",
> > +                       current->comm, order, gfp_mask);
> 
> Even more so here. Why not pr_warning instead of two non-atomic calls
> to printk?

It's a relic of an hour ago when I tried passing in the printk() level
to the function as a string.  It can go away now. :)

-- Dave

