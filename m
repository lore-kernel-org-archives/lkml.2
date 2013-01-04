Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab3ADNTo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 08:19:44 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:37533 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754745Ab3ADNTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 08:19:42 -0500
Date: Fri, 4 Jan 2013 13:25:57 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alexander Holler <holler@ahsoftware.de>
Cc: Borislav Petkov <bp@alien8.de>, Shawn Guo <shawn.guo@linaro.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, Josh Boyer <jwboyer@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Florian Tobias Schandinat <florianSchandinat@gmx.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fbdev@vger.kernel.org, Bernie Thompson <bernie@plugable.com>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        Dave Airlie <airlied@redhat.com>
Subject: Re: [PATCH] fb: Rework locking to fix lock ordering on takeover
Message-ID: <20130104132557.70e0c527@pyramind.ukuu.org.uk>
In-Reply-To: <50E6D01D.6040304@ahsoftware.de>
References: <20121116192606.11799.35711.stgit@localhost.localdomain>
	<CA+5PVA6nKNZY70UoeDUhQo9Rj4Ck+k+XTHL++gwErgzqAdy6Aw@mail.gmail.com>
	<20121121125310.00625f55@pyramind.ukuu.org.uk>
	<CA+5PVA5iQwYOcoSYtLOoRBHaTNJANdv+X-C78474n3SzZg_m9w@mail.gmail.com>
	<CA+1xoqe0G4rha5bDcoQQUcACYbQ8BCO7AE_JE8z5VjJLeNUdyA@mail.gmail.com>
	<CAM_iQpWLgnxQR+oYD+Dnh9NprR1-QLjXa6T+dtHUs3A-_N2wmQ@mail.gmail.com>
	<CA+1xoqf0d5ckDZ3o1-Y+qd61nvVA7EECeH20U+WjDpNVb4E=pw@mail.gmail.com>
	<20121227045301.GB17472@x1.alien8.de>
	<20121228115022.GA28009@S2101-09.ap.freescale.net>
	<20121228124026.GB12918@x1.alien8.de>
	<50E6D01D.6040304@ahsoftware.de>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 Jan 2013 13:50:37 +0100
Alexander Holler <holler@ahsoftware.de> wrote:

> Am 28.12.2012 13:40, schrieb Borislav Petkov:
> > On Fri, Dec 28, 2012 at 07:50:27PM +0800, Shawn Guo wrote:
> >> +1
> >>
> >> http://thread.gmane.org/gmane.linux.kernel/1413953/focus=1415070
> >
> > Cool, works fine here too. Is Linus on CC? (/me checks.. ) Yes he is,
> > good.
> >
> > Linus, Alan's patch works at least in 2 cases, you might consider
> > picking it up directly since the fb maintainer is absent, reportedly.
> 
> 
> Btw. I think all the usb-fb's (udlfb, smscufx and udl) are broken, at 
> least on ARM(v5). When I have linked in udlfb the following happens on 
> boot (with an attached USB-LCD and with or without the "Rework locking 
> patch):

They are broken if used as the system console (has been known for years).
Perhaps your x86 test has the system console still on another device ?

For the udl layer it shouldn't matter as Dave Airlie wrote a DRM driver
for udl which obsoletes the old fb layer one and works much better
(although the error handling is still totally broken and leaks like a
sieve if it fails)

Fixing the console isn't that difficult - you just need to make your
device queue the console I/O to a worker thread of some kind. We don't
want to do that by default because we want to get the messages out
reliably and immediately on saner hardware. Given there are several
such cases a general helper and a console "I am crap" flag might be better
than hacking each driver.

Alan

