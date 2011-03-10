Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab1CJXET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 18:04:19 -0500
Received: from cantor.suse.de ([195.135.220.2]:60211 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752425Ab1CJXES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 18:04:18 -0500
Date: Thu, 10 Mar 2011 15:03:04 -0800
From: Greg KH <gregkh@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 1/1] sysfs: add more info to the oops dump
Message-ID: <20110310230304.GA5254@suse.de>
References: <20110310212746.GA3361@suse.de>
 <1299796027-3343-1-git-send-email-ext-phil.2.carmody@nokia.com>
 <1299796027-3343-2-git-send-email-ext-phil.2.carmody@nokia.com>
 <20110310143806.7542e929.akpm@linux-foundation.org>
 <alpine.LFD.2.00.1103102354530.2787@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1103102354530.2787@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 11:59:26PM +0100, Thomas Gleixner wrote:
> On Thu, 10 Mar 2011, Andrew Morton wrote:
> 
> > On Fri, 11 Mar 2011 00:27:07 +0200
> > Phil Carmody <ext-phil.2.carmody@nokia.com> wrote:
> > 
> > > +static int last_sysfs_write_len;
> > >  void sysfs_printk_last_file(void)
> > >  {
> > > -	printk(KERN_EMERG "last sysfs file: %s\n", last_sysfs_file);
> > > +	printk(KERN_EMERG "last sysfs file (%c): %s%c",
> > > +	       (last_sysfs_write_len == SYSFS_NOT_A_WRITE) ? 'r' : 'w',
> > > +	       last_sysfs_file,
> > > +	       last_sysfs_write_len > 0 ? ' ' : '\n');
> > > +	if (last_sysfs_write_len >= (int)sizeof(last_sysfs_write))
> > > +		printk(KERN_CONT " written: %s...(%d chars)\n",
> > > +		       last_sysfs_write, last_sysfs_write_len);
> > > +	else if (last_sysfs_write_len > 0)
> > > +		printk(KERN_CONT " written: %s\n", last_sysfs_write);
> > >  }
> > 
> > That's going to fail to emit the \n if last_sysfs_write_len<=0. 
> > However there are tricks inside printk() which will fix that up if the
> > next printk starts with KERN_foo.
> > 
> > 
> > 
> > I can recall just one instance in the past 5-6 years in which the
> > last-sysfs-file output enabled me to locate a bug which would otherwise
> > have been unlocatable (within a drivers/md handler, iirc).
> > 
> > I don't think it's a terribly useful feature.  Except for when it _is_
> > useful, when it's very useful ;) The world wouldn't end if we decided
> > to remove it.
> 
> Amen to that.
> 
> It's more of an distraction than anything which is relevant to 99.999%
> of the problems we have to deal with.

Ok, I think I'll delete it as I'm tired of having to filter it out of my
"any problem with sysfs" lkml filter that I use :)

thanks,

greg k-h
