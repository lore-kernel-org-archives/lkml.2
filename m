Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321Ab1CRSHH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 14:07:07 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59292 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752338Ab1CRSHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 14:07:02 -0400
Date: Fri, 18 Mar 2011 18:07:18 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: stefan.bigler@keymile.com
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: TTY loosing data with u_serial gadget
Message-ID: <20110318180718.6d019c71@lxorguk.ukuu.org.uk>
In-Reply-To: <4D8389EC.5030704@keymile.com>
References: <4D8121F6.9060600@keymile.com>
	<20110317000408.GA18911@kroah.com>
	<4D8389EC.5030704@keymile.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I had also a look at the relevant fixes, a lot is done but I could not find
> the required protection of the attribute receive_room.

receive_room isn't protected because it may only be shrunk by the amount
of data sent to the ldisc or less. The ldisc is at liberty to grow the
value as it sees fit.

In essence if you get a value from receive_room it's a guarantee you may
send that many bytes, it is not a precise instantaneous perfect answer to
the question "exactly what number of bytes could fit at this precise
moment".

Which does of course mean you should never see the case where
receive_room is bigger than the actual space available in tty raw mode.


