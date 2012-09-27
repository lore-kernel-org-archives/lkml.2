Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522Ab2I0OOb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 10:14:31 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:65180 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab2I0OOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 10:14:30 -0400
Date: Thu, 27 Sep 2012 18:14:25 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>, Jiri Slaby <jslaby@suse.cz>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC] tty: Add get- ioctls to fetch tty status
Message-ID: <20120927141425.GG6618@moon>
References: <20120922180639.GC11610@moon>
 <20120922200731.GD14004@kroah.com>
 <20120922201144.GD11610@moon>
 <20120922215232.GA25778@moon>
 <20120923010953.GA17663@kroah.com>
 <20120923064007.GA2994@moon>
 <34f6ba7b-2c50-492e-9267-52d328a8d37f@email.android.com>
 <20120924141441.GD16532@moon>
 <20120927140502.GB12552@moon>
 <20120927151447.2460ce44@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120927151447.2460ce44@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 03:14:47PM +0100, Alan Cox wrote:
> > Alan, Greg, what's opinion? This flags fetching is the same as say fetching
> > of termios settings, once fetched they can be changed immediately, and it's
> > up to caller what to do with termios settings. No?
> 
> I think you need to explain what you expect to be doing with it, and why
> it is safe in that application.

OK, it seems it was unclear from changelog. We need to know this parameters
to be able to restore tty connection after checkpoint.

While we easily can fetch termios settings and such, there are few bits which
are missed to expord. So this patch provides them to user-space.
