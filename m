Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab2EHQJh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 12:09:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38960 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755943Ab2EHQJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 12:09:35 -0400
Date: Tue, 8 May 2012 09:09:30 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alan Cox <alan@linux.intel.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: Regression due to d29f3ef "tty_lock: Localise the lock"
Message-ID: <20120508160930.GB20433@kroah.com>
References: <4FA8557E.5080402@wwwdotorg.org>
 <20120508103512.42db1c4b@pyramind.ukuu.org.uk>
 <4FA93FEB.2060200@wwwdotorg.org>
 <20120508170442.409ccbe4@bob.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120508170442.409ccbe4@bob.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2012 at 05:04:42PM +0100, Alan Cox wrote:
> On Tue, 08 May 2012 09:46:51 -0600
> Stephen Warren <swarren@wwwdotorg.org> wrote:
> 
> > On 05/08/2012 03:35 AM, Alan Cox wrote:
> > > On Mon, 07 May 2012 17:06:38 -0600
> > > Stephen Warren <swarren@wwwdotorg.org> wrote:
> > > 
> > >> Alan,
> > >>
> > >> Commit d29f3ef "tty_lock: Localise the lock" appears to cause a
> > >> problem for me.
> > >>
> > >> With this commit (as in next-20120507), I can no longer log into my
> > >> system (NVIDIA Tegra device with ARM CPU) over the serial console,
> > >> since the login prompt no longer appears. If I wait a few minutes,
> > >> I see the following console spew:
> > > 
> > > Eep. If it's reproducable can you test whether adding the
> > > unlock/relock in drivers/tty/pty.c does the trick ?
> > > 
> > > ie:
> > > 	tty_unlock(tty);
> > > 	tty_vhangup(tty);
> > > 	tty_lock(tty);
> > 
> > Yes, that change in pty_close() solves the problem.
> 
> Ok Greg - I think we should go with putting that unlock back until we
> understand exactly what is going on.

Ok, care to send a patch that does this so I get it correct, and we get
a reported-by from Stephen?

thanks,

greg k-h
