Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758525Ab0IHI74 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 04:59:56 -0400
Received: from www.tglx.de ([62.245.132.106]:50764 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758460Ab0IHI7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 04:59:53 -0400
Date: Wed, 8 Sep 2010 10:59:23 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Greg KH <greg@kroah.com>
cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [patch 27/30] staging: Bulk convert the semaphore mess
In-Reply-To: <20100908023019.GA25440@kroah.com>
Message-ID: <alpine.LFD.2.00.1009081058350.2477@localhost6.localdomain6>
References: <20100907124636.880953480@linutronix.de> <20100907125057.278833764@linutronix.de> <20100908023019.GA25440@kroah.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Sep 2010, Greg KH wrote:

> On Tue, Sep 07, 2010 at 02:33:47PM -0000, Thomas Gleixner wrote:
> > init_MUTEX(_LOCKED) and DECLARE_MUTEX are going away. Bulk convert
> > staging users.
> 
> I don't think you actually built this change:
> 
> > --- linux-2.6.orig/drivers/staging/comedi/drivers/usbdux.c
> > +++ linux-2.6/drivers/staging/comedi/drivers/usbdux.c
> > @@ -315,7 +315,7 @@ struct usbduxsub {
> >   */
> >  static struct usbduxsub usbduxsub[NUMUSBDUX];
> >  
> > -static DECLARE_MUTEX(start_stop_sem);
> > +static DEFINE_SEMAPHORE(start_stop_sem);
> >  
> >  /*
> >   * Stops the data acquision
> 
> I don't see DEFINE_SEMAPHORE() in Linus's tree, what should we use
> instead?

It's the first patch in the series, which I want to get Linus wards
now, so this does not trip over.

Thanks,

	tglx
