Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab1AGDpi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 22:45:38 -0500
Received: from cantor.suse.de ([195.135.220.2]:34312 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954Ab1AGDph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 22:45:37 -0500
Date: Thu, 6 Jan 2011 19:40:44 -0800
From: Greg KH <gregkh@suse.de>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] TTY/serial merge for .38
Message-ID: <20110107034044.GB836@suse.de>
References: <20110106215404.GA30624@kroah.com>
 <20110106220017.3c19f9e6@lxorguk.ukuu.org.uk>
 <20110106222436.GA31994@suse.de>
 <AANLkTiman4=gGxMccUu41tvt19imiSvnhTe3wm9p-s2r@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTiman4=gGxMccUu41tvt19imiSvnhTe3wm9p-s2r@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 07, 2011 at 12:54:05AM +0100, Kay Sievers wrote:
> On Thu, Jan 6, 2011 at 23:24, Greg KH <gregkh@suse.de> wrote:
> > On Thu, Jan 06, 2011 at 10:00:17PM +0000, Alan Cox wrote:
> >> > There was some arguing about the tty console detection patches, but as
> >> > the existing ioctl does not work properly, Kay's patch was accepted to
> >> > resolve this issue and allow systemd to correctly detect consoles.  I
> >> > know Alan doesn't like this, but I feel it's the best way to solve the
> >> > issue (combined with the fact that there is no proposed other solution.)
> >>
> >> I'm a bit confused about this one Greg - all the distributions used the
> >> ioctl you refer to below for this purpose and have for years
> >>
> >> > This series also includes the long-out-of-tree ioctl that SUSE and
> >> > Debian have been dragging around in their kernels for the past 10+
> >> > years.  Thanks to Werner for finally submitting it in a mergable form.
> >>
> >> Which I believe means we don't need the sysfs patch as well - Kay ?
> >
> > I didn't think that the ioctl was sufficient for what systemd required,
> > it was only needed for "old-style" initrd programs like what used to be
> > used in SUSE and other distros, but are now being phased out.
> 
> We want all involved ttys below /dev/console not only the primary one.
> Also we like to get notified about re-configs, hence the poll()
> support. Both is not covered at the moment, or by the old, now to be
> merged, ioctl.

Ah, ok, that makes sense, and is why I merged both, they are both needed
by different users (well, the ioctl users could use the sysfs file, but
as it has been used for 10+ years, it's only fair to include it as well
to provide backward compatiblity to those users).

thanks,

greg k-h
