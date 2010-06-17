Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760515Ab0FQRwn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 13:52:43 -0400
Received: from kroah.org ([198.145.64.141]:48792 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760388Ab0FQRwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 13:52:42 -0400
Date: Thu, 17 Jun 2010 10:43:52 -0700
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg KH <gregkh@suse.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       John Kacur <jkacur@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 4/6] USB-BKL: Remove BKL use in uhci-debug
Message-ID: <20100617174352.GA3644@kroah.com>
References: <1275426285-9088-5-git-send-email-arnd@arndb.de>
 <Pine.LNX.4.44L0.1006020944450.1992-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1006020944450.1992-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 09:47:46AM -0400, Alan Stern wrote:
> On Tue, 1 Jun 2010, Arnd Bergmann wrote:
> 
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > BKL was not really needed, just came from earlier push downs.
> 
> Yes.
> 
> > The only part that's a bit dodgy is the lseek function. Would
> > need another lock or atomic access to fpos on 32bit?
> > Better to have a libfs lseek
> 
> It doesn't matter.  Anyone who tries to do lseeks on this file 
> from two different threads, simultaneously, deserves what they get.
> 
> > @@ -539,11 +534,11 @@ static loff_t uhci_debug_lseek(struct file *file, loff_t off, int whence)
> >  		new = file->f_pos + off;
> >  		break;
> >  	}
> > +
> > +	/* XXX: Can size shrink? */
> >  	if (new < 0 || new > up->size) {
> > -		unlock_kernel();
> >  		return -EINVAL;
> >  	}
> > -	unlock_kernel();
> >  	return (file->f_pos = new);
> >  }
> 
> This comment isn't needed; the size cannot change after the file has 
> been opened.

I've removed the comment in the version I just committed.

thanks,

greg k-h
