Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207Ab0IHJKv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 05:10:51 -0400
Received: from kroah.org ([198.145.64.141]:57346 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151Ab0IHJKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 05:10:49 -0400
Date: Wed, 8 Sep 2010 02:11:41 -0700
From: Greg KH <greg@kroah.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [patch 27/30] staging: Bulk convert the semaphore mess
Message-ID: <20100908091141.GA1377@kroah.com>
References: <20100907124636.880953480@linutronix.de> <20100907125057.278833764@linutronix.de> <20100908023019.GA25440@kroah.com> <alpine.LFD.2.00.1009081058350.2477@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1009081058350.2477@localhost6.localdomain6>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 08, 2010 at 10:59:23AM +0200, Thomas Gleixner wrote:
> On Tue, 7 Sep 2010, Greg KH wrote:
> 
> > On Tue, Sep 07, 2010 at 02:33:47PM -0000, Thomas Gleixner wrote:
> > > init_MUTEX(_LOCKED) and DECLARE_MUTEX are going away. Bulk convert
> > > staging users.
> > 
> > I don't think you actually built this change:
> > 
> > > --- linux-2.6.orig/drivers/staging/comedi/drivers/usbdux.c
> > > +++ linux-2.6/drivers/staging/comedi/drivers/usbdux.c
> > > @@ -315,7 +315,7 @@ struct usbduxsub {
> > >   */
> > >  static struct usbduxsub usbduxsub[NUMUSBDUX];
> > >  
> > > -static DECLARE_MUTEX(start_stop_sem);
> > > +static DEFINE_SEMAPHORE(start_stop_sem);
> > >  
> > >  /*
> > >   * Stops the data acquision
> > 
> > I don't see DEFINE_SEMAPHORE() in Linus's tree, what should we use
> > instead?
> 
> It's the first patch in the series, which I want to get Linus wards
> now, so this does not trip over.

Ah, that makes sense.

Well, it didn't hurt for me to take the other portions of this patch,
right?

thanks,

greg k-h
