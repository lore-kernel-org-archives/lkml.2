Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760061Ab2EKOwv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 10:52:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36853 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758517Ab2EKOws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 10:52:48 -0400
Date: Fri, 11 May 2012 07:52:43 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 3/3] tty_lock: Localise the lock
Message-ID: <20120511145243.GE5958@kroah.com>
References: <20120503212151.568.91854.stgit@bob.linux.org.uk>
 <20120503212219.568.15653.stgit@bob.linux.org.uk>
 <CA+1xoqezLCQh_fqJ1iNAs25X7Fm24W=-0J8zTZuVVJQnWTtSLg@mail.gmail.com>
 <20120507171126.5beddc27@pyramind.ukuu.org.uk>
 <1336408208.3638.15.camel@lappy>
 <20120507174240.4209c5cb@pyramind.ukuu.org.uk>
 <CA+1xoqez0PaX2KBHHN-etztwbFoU1cKx3NwMXX+PO4SguA3bRg@mail.gmail.com>
 <4FA838D2.9000908@suse.cz>
 <CA+1xoqdi1Jdkrjtj9bmnDfs4Ok=o=AsmpP=MY0V8cDXjcSNm1w@mail.gmail.com>
 <CA+1xoqcZnxGoo=_X1idCPTk9gR=drnAKhULGzgkH33zYGnAgOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+1xoqcZnxGoo=_X1idCPTk9gR=drnAKhULGzgkH33zYGnAgOA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 12:40:41PM +0200, Sasha Levin wrote:
> On Tue, May 8, 2012 at 8:12 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
> > On Mon, May 7, 2012 at 11:04 PM, Jiri Slaby <jslaby@suse.cz> wrote:
> >> On 05/07/2012 07:00 PM, Sasha Levin wrote:
> >>>> So whatever your trace is showing, that's not the bug. Something more
> >>>> complicated would appear to be afoot.
> >>>
> >>> Oddly enough, tty != tty->link, but the lockdep warning triggers.
> >>>
> >>> Any idea why it might happen?
> >>
> >> I think so, both locks are the same lockdep class. So lockdep thinks it
> >> is the same lock. However this is a false positive. I guess we need
> >> mutex_lock_nested...
> >
> > It looks like it causes an actual deadlock, and hung_tasks screams if
> > left alone for a bit, so it doesn't look like a lockdep issue.
> 
> I've applied the patch that unlocks before hangup, and started seeing
> this new warning instead (sorry if output below looks a bit broken,
> linux-next has a printk rework in progress):

The printk rework should now be working again in linux-next.  Is it
still causing problems for you?

thanks,

greg k-h
