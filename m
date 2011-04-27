Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658Ab1D0Jcq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 05:32:46 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56188 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752001Ab1D0Jcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 05:32:45 -0400
Date: Wed, 27 Apr 2011 10:33:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: johnlinn@comcast.net
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        michal.simek@petalogix.com, joe@perches.com, grant.likely@secretlab.ca,
        greg@kroah.com
Subject: Re: [PATCH V3] tty/serial: add support for Xilinx PS UART
Message-ID: <20110427103340.2554df83@lxorguk.ukuu.org.uk>
In-Reply-To: <549692800.1907368.1303859758362.JavaMail.root@sz0140a.emeryville.ca.mail.comcast.net>
References: <381805170.1906645.1303859011392.JavaMail.root@sz0140a.emeryville.ca.mail.comcast.net>
	<549692800.1907368.1303859758362.JavaMail.root@sz0140a.emeryville.ca.mail.comcast.net>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I thought I was improving but now as I look at it further, that seems like it 
> was better and I should have stuck to that method.
> 
> Thoughts?

Go for nearest is the right behaviour. The whole tty layer works on that
basis as do soem other things. It means you don't have to have a set of
calls to do things like "enumerate valid data rates" instead you ask and
compare.

> > > +	uart_update_timeout(port, termios->c_cflag, baud);
> > 
> > [which would also fix this timeout!]
> 
> Maybe you were meaning that if the baud rate was not really set because of the
> error this timeout would be wrong also, and if so that makes sense.

Correct

Alan
