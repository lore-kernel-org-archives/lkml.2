Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab0HJHb7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 03:31:59 -0400
Received: from adelie.canonical.com ([91.189.90.139]:45906 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420Ab0HJHbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 03:31:52 -0400
Date: Tue, 10 Aug 2010 08:31:43 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <gregkh@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] TTY patches for 2.6.36
Message-ID: <20100810073143.GC20634@shadowen.org>
References: <20100805213528.GA13794@kroah.com>
 <20100806204552.7cb80fd0@lxorguk.ukuu.org.uk>
 <AANLkTimGoG97dtp_hmHBJwwo1stzZxLoKs4_jr+eQ=gJ@mail.gmail.com>
 <201008062158.46013.arnd@arndb.de>
 <20100806202228.GA6153@suse.de>
 <AANLkTinaQz22DAzrcvYREWAe9AFv8enC88Gu_9o_Ghg-@mail.gmail.com>
 <20100809202453.26f242b3@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100809202453.26f242b3@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 09, 2010 at 08:24:53PM +0100, Alan Cox wrote:
> > With the new locking the BTM is held in place of the BKL, which
> > effectivly means throughout open and close processing, which
> > effectively means _all_ TTY open/closes are serialised throughout
> > regardless of the length of the shutdown processing.  The EIO appears
> > to be no longer returnable.

Arnd, thanks for your clear explanation.  I see now you have actually
addressed the long waits in the main.

> The specific case of waiting for queues to empty could be a slow one and
> probably wants to addressed nicely. The other causes like memory
> allocator waits are probably actually better the new way. What exactly is
> an application supposed to do when it gets a -EIO on open, how does it
> decide when to try again, when does it retry, how many aps get it right ?

I know to my cost they break.  For me, console_sem is one where we
commonly trigger this behaviour (before these changes), so affecting bog
standard VTs.

> In fact I don't think its unreasonable to treat an open without O_NDELAY
> that blocks on a close flushing output from buffers as correct - unless
> there is some specific POSIX reason why we cannot.
> 
> I'd venture we'd effective fix/hide/cover over a huge range of extremely
> obscure and near untestable app failure cases/bugs by doing this.

Yes that is very likely.  That the longer waits are picked out and
release BTM seems a completely sane approach and covers my query
completely.

-apw
