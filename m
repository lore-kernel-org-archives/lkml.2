Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489Ab1LOJ5w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 04:57:52 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37820 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932297Ab1LOJ5u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 04:57:50 -0500
Message-ID: <1323943005.18942.18.camel@twins>
Subject: Re: printk() vs tty_io
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Ted Ts'o" <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Date: Thu, 15 Dec 2011 10:56:45 +0100
In-Reply-To: <CA+55aFwu+oSPtqfN+bS3_fHXWU+VMd5BGhNd=J4MjuAJZT+fTQ@mail.gmail.com>
References: <1323804803.9082.40.camel@twins>
	 <CA+55aFxNWiRQ1CkifhgcnnBqBa-xRNdM9Ze6bnxhsYd4ZYPg6A@mail.gmail.com>
	 <20111214104308.14d0500c@pyramind.ukuu.org.uk>
	 <1323860206.28489.35.camel@twins> <20111214140527.GA18080@thunk.org>
	 <1323872631.28489.37.camel@twins>
	 <CA+55aFwu+oSPtqfN+bS3_fHXWU+VMd5BGhNd=J4MjuAJZT+fTQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-14 at 07:54 -0800, Linus Torvalds wrote:

> Ugh. There is a *ton* of stuff inside that serial port lock,
> including, yes, the uart_write_wakeup().
> 
> And it does look like it's protecting port->tty or something, so I
> don't see that we can just move the wakeup to outside the lock, which
> was my first reaction.

We probably could, I can have a closer look, but the main question is,
are we going to commit to no wakeups from console implementations? That
would mean removing the USB serial console support and other such stuff.

[ Personally I think USB serial console is insane, if you really need
something like that use the ehci-dbgp thing, that at least has a chance
of working. ]

If we're not going to commit to that (which would be valid choice given
where we are), my printk efforts are pointless and I'll reconsider.
