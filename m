Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab1CJXOK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 18:14:10 -0500
Received: from www.tglx.de ([62.245.132.106]:60609 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272Ab1CJXOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 18:14:08 -0500
Date: Fri, 11 Mar 2011 00:13:58 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Phil Carmody <ext-phil.2.carmody@nokia.com>
cc: Andrew Morton <akpm@linux-foundation.org>, gregkh@suse.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 1/1] sysfs: add more info to the oops dump
In-Reply-To: <20110310230621.GH7975@esdhcp04044.research.nokia.com>
Message-ID: <alpine.LFD.2.00.1103110012060.2787@localhost6.localdomain6>
References: <20110310212746.GA3361@suse.de> <1299796027-3343-1-git-send-email-ext-phil.2.carmody@nokia.com> <1299796027-3343-2-git-send-email-ext-phil.2.carmody@nokia.com> <20110310143806.7542e929.akpm@linux-foundation.org> <alpine.LFD.2.00.1103102354530.2787@localhost6.localdomain6>
 <20110310230621.GH7975@esdhcp04044.research.nokia.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Mar 2011, Phil Carmody wrote:
> On 10/03/11 23:59 +0100, ext Thomas Gleixner wrote:
> > On Thu, 10 Mar 2011, Andrew Morton wrote:
> > 
> > > On Fri, 11 Mar 2011 00:27:07 +0200
> > > Phil Carmody <ext-phil.2.carmody@nokia.com> wrote:
> > > 
> > > > +static int last_sysfs_write_len;
> > > >  void sysfs_printk_last_file(void)
> > > >  {
> > > > -	printk(KERN_EMERG "last sysfs file: %s\n", last_sysfs_file);
> > > > +	printk(KERN_EMERG "last sysfs file (%c): %s%c",
> > > > +	       (last_sysfs_write_len == SYSFS_NOT_A_WRITE) ? 'r' : 'w',
> > > > +	       last_sysfs_file,
> > > > +	       last_sysfs_write_len > 0 ? ' ' : '\n');
> > > > +	if (last_sysfs_write_len >= (int)sizeof(last_sysfs_write))
> > > > +		printk(KERN_CONT " written: %s...(%d chars)\n",
> > > > +		       last_sysfs_write, last_sysfs_write_len);
> > > > +	else if (last_sysfs_write_len > 0)
> > > > +		printk(KERN_CONT " written: %s\n", last_sysfs_write);
> > > >  }
> > > 
> > > That's going to fail to emit the \n if last_sysfs_write_len<=0. 
> 
> That's this case:
> + 	       last_sysfs_write_len > 0 ? ' ' : '\n');
> 
> > > However there are tricks inside printk() which will fix that up if the
> > > next printk starts with KERN_foo.
> > > 
> > > I can recall just one instance in the past 5-6 years in which the
> > > last-sysfs-file output enabled me to locate a bug which would otherwise
> > > have been unlocatable (within a drivers/md handler, iirc).
> > > 
> > > I don't think it's a terribly useful feature.  Except for when it _is_
> > > useful, when it's very useful ;) The world wouldn't end if we decided
> > > to remove it.
> > 
> > Amen to that.
> > 
> > It's more of an distraction than anything which is relevant to 99.999%
> > of the problems we have to deal with.
> 
> As I indicated before, I've previously thought that too, but thought I
> could 'fix' it by adding to it when I hit the once-in-three-years case.

The interesting question is:

 How did that info help and was it really the ultimate reason why you
 found the underlying bug ?

Thanks,

	tglx
