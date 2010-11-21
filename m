Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891Ab0KUOOI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 09:14:08 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53235 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753484Ab0KUOOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 09:14:06 -0500
Date: Sun, 21 Nov 2010 14:12:26 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: Alexander Gordeev <lasaine@lvk.cs.msu.su>, linux-kernel@vger.kernel.org,
        "Nikita V. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHv4 05/17] pps: access pps device by direct pointer
Message-ID: <20101121141226.1576758b@lxorguk.ukuu.org.uk>
In-Reply-To: <20101120154416.GX13356@enneenne.com>
References: <cover.1290087473.git.lasaine@lvk.cs.msu.su>
	<57dad12253191b67a6a08bb9c464bd54e70e52a3.1290087479.git.lasaine@lvk.cs.msu.su>
	<20101120154416.GX13356@enneenne.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Maybe this lock is useless... however, are we sure that before setting
> tty->disc_data to pps its value is null? Otherwise the dcd_change may
> be called with an oops! We cannot control serial port IRQ
> generation... :-/

tty->disc_data is LDISC private. It may be any arbitary value on entry to
the ldisc open method.


> > +	spin_lock_irq(&pps_ldisc_lock);
> > +	tty->disc_data = NULL;
> > +	spin_unlock_irq(&pps_ldisc_lock);

And you don't need to set it to NULL after - some ldiscs do this mostly
as a debug aid.

Alan
