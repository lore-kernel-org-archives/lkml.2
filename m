Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722Ab0DUE4Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 00:56:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53791 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780Ab0DUE4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 00:56:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: michael@ellerman.id.au
Subject: Re: [Bug #15589] 2.6.34-rc1: Badness at fs/proc/generic.c:316
Date: Wed, 21 Apr 2010 06:57:18 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc4-rjw; KDE/4.3.5; x86_64; ; )
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Christian Kujau <lists@nerdbynature.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, schwab@linux-m68k.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
References: <deuQKFRcc0B.A.3EG.BRSzLB@tosh> <20100421155547.GA4222@x200> <1271809299.13262.6.camel@concordia>
In-Reply-To: <1271809299.13262.6.camel@concordia>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201004210657.18864.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 April 2010, Michael Ellerman wrote:
> On Wed, 2010-04-21 at 18:55 +0300, Alexey Dobriyan wrote:
> > On Tue, Apr 20, 2010 at 10:18:18PM +1000, Michael Ellerman wrote:
> > > On Mon, 2010-04-19 at 23:45 -0700, Christian Kujau wrote:
> > > --- a/fs/proc/proc_devtree.c
> > > +++ b/fs/proc/proc_devtree.c
> > > @@ -175,6 +175,24 @@ retry:
> > >         return fixed_name;
> > >  }
> > >  
> > > +static const char *unslash_name(const char *name)
> > > +{
> > > +       char *p, *fixed_name;
> > > +
> > > +       fixed_name = kstrdup(name);
> > > +       if (!fixed_name) {
> > > +               printk(KERN_ERR "device-tree: Out of memory trying to unslash "
> > > +                               "name \"%s\"\n", name);
> > > +               return name;
> > > +       }
> > > +
> > > +       p = fixed_name;
> > > +       while ((p = strstr(p, "/")))
> > > +               *p++ = '_';
> > 
> > This is wasteful. :-)
> 
> Whatever, patches welcome :)
> 
> > Also, I hope we won't spit message every time allocation fail.
> 
> We do. Your system is mostly hosed anyway, but feel free to rate limit
> it or something.

OK

Is anyone going to post a clean patch for that with a sign-off?

Rafael
