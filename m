Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab2I0QGy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 12:06:54 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:61966 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab2I0QGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 12:06:52 -0400
Date: Thu, 27 Sep 2012 20:06:46 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [RFC] tty: Add get- ioctls to fetch tty status
Message-ID: <20120927160646.GO6618@moon>
References: <34f6ba7b-2c50-492e-9267-52d328a8d37f@email.android.com>
 <20120924141441.GD16532@moon>
 <20120927140502.GB12552@moon>
 <20120927151447.2460ce44@pyramind.ukuu.org.uk>
 <20120927141425.GG6618@moon>
 <5064600D.1090506@zytor.com>
 <20120927142149.GH6618@moon>
 <20120927161312.1eadd5d6@pyramind.ukuu.org.uk>
 <20120927152333.GN6618@moon>
 <20120927170037.196ea446@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120927170037.196ea446@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 05:00:37PM +0100, Alan Cox wrote:
> > > Otherwise - TICOGPKT is specific to pty devices. Please therefore put it
> > > in the pty.c code and note that not all platforms use asm-geneic TTY
> > > ioctls so check carefully they all build.
> > 
> > I put it into tty_ioctl.c simply because TIOCPKT was there already so
> > I thought it's good idea to keep them close to each other in code.
> 
> Perhaps we should move TIOCPKT out as well?

OK, so I'll do two patches instead of squashing everything on one patch.

Btw, as far as I see wee are zeroifying tty_struct always twice,
first in alloc_tty_struct and then in initialize_tty_struct again.
And alloc_tty_struct + initialize_tty_struct always used as a tuple
in current code, so I presume they might be squashed in one helper
instead to eliminate overhead, but it's different task.
