Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751063Ab2LLFqH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 00:46:07 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42428 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab2LLFqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 00:46:05 -0500
Date: Tue, 11 Dec 2012 20:49:13 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Benedikt Spranger <b.spranger@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hjk@hansjkoch.de,
        Alexander.Frank@eberspaecher.com
Subject: Re: [PATCH 1/2] uio: add warning to documentation
Message-ID: <20121212044913.GD7224@kroah.com>
References: <1355267523-19724-1-git-send-email-b.spranger@linutronix.de>
 <1355267523-19724-2-git-send-email-b.spranger@linutronix.de>
 <20121211231816.GA23621@kroah.com>
 <20121212014534.287c8ba8@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121212014534.287c8ba8@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 01:45:34AM +0100, Benedikt Spranger wrote:
> On Tue, 11 Dec 2012 15:18:16 -0800
> Greg KH <gregkh@linuxfoundation.org> wrote:
> 
> > > -<function>open()</function>, you will probably also want a custom
> > > +<function>release()</function>, you will probably also want a
> > > custom <function>release()</function> function. 
> > That sentance no longer makes sense.
> DUH! will fix...
> 
> > > +</para><para>CAVE: The release hook may be processed, even if a
> > > mmap is aktive.
> > Huh?
> OK, think about a user of uio_pdrv_genirq and you did your
> powermanagement well. The user open the UIO device, do a mmap() and
> close the UIO device. Then he access the given pointer and wonders why
> the system is stuck. It is a bad idea to disable clocks on release
> while a mmap is active.

A UIO user is root and can do lots of bad things if they are foolish,
are we supposed to enumerate all of them?  :)

> > > +Disabling clocks or other powermanagement functionality may cause
> > > a system +crash, hangup or other unwanted sideeffects.
> > > +</para><para><emphasis>The mmap() function shall add an extra
> > > reference to the file associated with the file descriptor fildes
> > > which is not removed by a subsequent close() on that file
> > > descriptor. This reference shall be removed when there are no more
> > > mappings to the file.</emphasis></para><para> +<link
> > > xlink:href="http://pubs.opengroup.org/onlinepubs/009695399/functions/mmap.html">IEEE
> > > Std 1003.1, 2004 Edition, mmap()</link>
> > 
> > It's not up to us to document the mmap system call here, you should
> > know how to use it if you write a program with it, right?
> Its not the user of mmap(), it is for the driver programmer. It is a
> bad idea to do every kind of powermanagement function in the release
> hook.

I agree, but how can a driver programmer use that information properly
here?

greg k-h
