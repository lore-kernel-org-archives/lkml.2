Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756475Ab0LEQ7z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 11:59:55 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:35814 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756244Ab0LEQ7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 11:59:54 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18iUlB60pkirvIk14iVbK0FIuO4G+X9ppjwnXcIU/
	XmOm0j5vgMpmQH
Subject: Re: [PATCH v4] Regression: sched: automated per session task groups
From: Mike Galbraith <efault@gmx.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Nikos Chantziaras <realnc@arcor.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20101205151220.0c532c94@pyx>
References: <1289783580.495.58.camel@maggy.simson.net>
	 <1289811438.2109.474.camel@laptop>
	 <1289820766.16406.45.camel@maggy.simson.net>
	 <1289821590.16406.47.camel@maggy.simson.net>
	 <20101115125716.GA22422@redhat.com>
	 <1289856350.14719.135.camel@maggy.simson.net>
	 <20101116130413.GA29368@redhat.com>
	 <1289917109.5169.131.camel@maggy.simson.net>
	 <20101116150319.GA3475@redhat.com>
	 <1289922108.5169.185.camel@maggy.simson.net>
	 <20101116172804.GA9930@elte.hu> <1290281700.28711.9.camel@maggy.simson.net>
	 <AANLkTinz12n9OKkCV8XRF8n1vKytO_aj26i-ytcAhFgN@mail.gmail.com>
	 <AANLkTinWQkiadp7NCVt401bFiATJeqTK1g81RcP2awCv@mail.gmail.com>
	 <AANLkTinmgsBQ624habviTTj7khCdZH_p2m5mX24_SV9j@mail.gmail.com>
	 <idfrvp$l4o$1@dough.gmane.org>  <20101205151220.0c532c94@pyx>
Content-Type: text/plain
Date: Sun, 05 Dec 2010 17:59:48 +0100
Message-Id: <1291568388.7521.67.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-12-05 at 15:12 +0000, Alan Cox wrote:
> > > As soon as you do that from the same terminal that you're going to
> > > launch the "make" from, you're back to total lossage.  Are you going
> > > to explain to a student that "oh, you need to create a new
> > > gnome-terminal tab and launch firefox from that"?
> > 
> > Btw, most people don't do that anymore.  They don't use terminals.  They 
> 
> Its a regression for those who do - and often have good reason to do.
> This is of course why you don't put policy in the kernel and the original
> patch was bogus anyway.

What is a very clear regression is a threaded app (say firefox) vs a
single threaded app, particularly on UP.  The per thread scheduling
model wins hands down there, because the scheduler very heavily favors
the threaded application.  Take that unfairness away, and you have an
undeniable regression.  Yes, it's not black and white, never is.

	-Mike

