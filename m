Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759985Ab2FAOcN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 10:32:13 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40711 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299Ab2FAOcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 10:32:12 -0400
Date: Fri, 1 Jun 2012 15:34:54 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Oliver Neukum <oneukum@suse.de>
Cc: Stefani Seibold <stefani@seibold.net>, linux-kernel@vger.kernel.org,
        greg@kroah.com, gregkh@linuxfoundation.org,
        thomas.braunstorfinger@rohde-schwarz.com
Subject: Re: [PATCH] add new NRP power meter USB device driver
Message-ID: <20120601153454.6f9830a0@pyramind.ukuu.org.uk>
In-Reply-To: <201206011616.36284.oneukum@suse.de>
References: <1338318858-24144-1-git-send-email-stefani@seibold.net>
	<201205311020.50076.oneukum@suse.de>
	<1338456100.6454.82.camel@wall-e>
	<201206011616.36284.oneukum@suse.de>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jun 2012 16:16:36 +0200
Oliver Neukum <oneukum@suse.de> wrote:

> Am Donnerstag, 31. Mai 2012, 11:21:40 schrieb Stefani Seibold:
> > On Thu, 2012-05-31 at 10:20 +0200, Oliver Neukum wrote:
> > 
> > > > > 
> > > > > > +		if (arg) {
> > > > > > +			ret = wait_event_interruptible_timeout(
> > > > > > +				dev->out_running.wait,
> > > > > > +				list_empty(&dev->out_running.urb_list),
> > > > > > +				msecs_to_jiffies(arg));
> > > > > > +			if (!ret)
> > > > > > +				return -ETIMEDOUT;
> > > > > > +			if (ret < 0)
> > > > > > +				return ret;
> > > > > > +			return 0;
> > > > > > +		} else {
> > > > > > +			return wait_event_interruptible(
> > > > > > +				dev->out_running.wait,
> > > > > > +				list_empty(&dev->out_running.urb_list));
> > > > > > +		}
> > > > > > +		break;
> > > > > 
> > > > > This is very ugly. If you need fsync(), then implement it.
> > > > > 
> > > > 
> > > > fsync() did not meat the requirements, since i need in some case a
> > > > timeout for the device. poll() will also not help, since it signals only
> > > > that there is space to write.
> > > 
> > > Well, then implement fsync() with interruptible sleep and use a timer
> > > in user space.
> > > 
> > 
> > But this will not solve the problem of older software which is still
> > depending on this ioctl.
> 
> Yes. I guess it might be included in a depreated form. However
> a sane alternative must be provided.

It's a new kernel driver it's not bound to any existing API and we
regularly enforce a sane API on drivers being merged so I think the
legacy stuff is just "tough" - the out of tree driver will work fine with
any legacy code.

Alan
