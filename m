Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758396Ab2FAU7z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 16:59:55 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:60347 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753667Ab2FAU7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 16:59:54 -0400
Subject: Re: [PATCH] tty: add lockdep annotations
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>
In-Reply-To: <20120601215620.305155c0@pyramind.ukuu.org.uk>
References: <4FC6189B.9080909@fusionio.com>
	 <1338402812.2760.413.camel@edumazet-glaptop>
	 <4FC66D3D.6080509@fusionio.com>
	 <1338404902.2760.451.camel@edumazet-glaptop>
	 <1338410107.2760.544.camel@edumazet-glaptop>
	 <1338456918.2760.1318.camel@edumazet-glaptop>
	 <1338574627.2760.1545.camel@edumazet-glaptop>
	 <CA+55aFzrbmGjghmR3M=fWrGUdy6BDu+SVXz6rjM4QAuUjfxk_w@mail.gmail.com>
	 <1338583498.2760.1648.camel@edumazet-glaptop>
	 <20120601215620.305155c0@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Jun 2012 22:59:49 +0200
Message-ID: <1338584389.2760.1653.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-01 at 21:56 +0100, Alan Cox wrote:
> > Yes, tty->driver deref is ok (tty points to valid memory), but crash is
> > on tty->driver->ops (driver points to freed/illegal memory)
> > 
> > using slub_debug=FZPU, I can indeed see RDI=6b6b6b6b6b6b6b6b
> 
> driver and driver->ops is basically const and it's not what you'd expect
> from a tty refcount bug. The driver side puts shouldn't have changed but
> I'll take a look over that patch and the error paths closely again just
> in case.

right

The code looks like :
...
	call mcount
	mov  %rdi,%rbx
	mov  0x10(%rdi),%rdi   tty->driver
<>	mov  0xf8(%rdi),%rax   CRASH

So tty was freed an tty->driver contains 6b6b6b6b6b6b6b6b



