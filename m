Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758955Ab1CaVi5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 17:38:57 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43003 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751950Ab1CaViz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 17:38:55 -0400
Date: Thu, 31 Mar 2011 22:39:14 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Jack Stone <jwjstone@fastmail.fm>, Mac <kmac@poczta.fm>,
        linux-kernel@vger.kernel.org, linux-ppp@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: 'scheduling while atomic' during ppp connection on 2.6.37.1 and
 2.6.38
Message-ID: <20110331223914.458a36b7@lxorguk.ukuu.org.uk>
In-Reply-To: <4D94E9E7.2050600@suse.cz>
References: <fuopaigyaypsqveewtjx@pwmq>
	<4D864A82.4090104@fastmail.fm>
	<20110320215826.79cadfe2@lxorguk.ukuu.org.uk>
	<4D87173D.50906@suse.cz>
	<20110321110214.5174f1b2@lxorguk.ukuu.org.uk>
	<4D94E9E7.2050600@suse.cz>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What is the proper way to avoid a race with HUP in tty->ops->write,
> chars_in_buffer, ntty_write_room and possibly others?

You shouldn't need to do anything in those cases as tty and
tty->driver_data won't be going anywhere. port->tty may go NULL and the
IRQ handlers etc need to get the refs properly and keep refs when needed
so the tty isn't freed under them, but that *should* be all that is
needed if the logic is right.

> I looked into the drivers, moxa tests tty->driver_data (why? [1]), mxser
> does nothing as well as rocket and many others. What is the reference
> driver I should look into?

I think its a delusion from early drivers that never got sorted

> 
> [1] Perhaps leftover from when moxa_shutdown used to NULL it.
> 
> I don't see why the driver should care at all. It has a tty,
> tty->driver_data and thus all the HW info. So it should ignore the race,
> i.e. test nothing, right?

Yes

