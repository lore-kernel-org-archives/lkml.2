Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab1BVLJb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 06:09:31 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41469 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753551Ab1BVLJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 06:09:31 -0500
Date: Tue, 22 Feb 2011 11:11:03 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Subhasish" <subhasish@mistralsolutions.com>
Cc: <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>, <m-watkins@ti.com>,
        <nsekhar@ti.com>, <sachi@mistralsolutions.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        "open list" <linux-kernel@vger.kernel.org>,
        "Stalin Srinivasan" <stalin.s@mistralsolutions.com>
Subject: Re: [PATCH v2 13/13] tty: pruss SUART driver
Message-ID: <20110222111103.5d0dd0a7@lxorguk.ukuu.org.uk>
In-Reply-To: <A6D1CF0E941748448610BE8874FC586F@subhasishg>
References: <1297435892-28278-1-git-send-email-subhasish@mistralsolutions.com>
	<1297435892-28278-14-git-send-email-subhasish@mistralsolutions.com>
	<20110211162814.6ff274f1@lxorguk.ukuu.org.uk>
	<A6D1CF0E941748448610BE8874FC586F@subhasishg>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> we used separate files and hence we decided to keep the code in a separate
> directory so that the related files can be identified easily.

Fair enough but I would have thought you could drop the two files in the
serial directory if they have obviously related names- trivial item/
> 
> >
> >
> >
> >> +#ifdef __SUART_DEBUG
> >> +#define __suart_debug(fmt, args...) \
> >> + printk(KERN_DEBUG "suart_debug: " fmt, ## args)
> >> +#else
> >> +#define __suart_debug(fmt, args...)
> >> +#endif
> >> +
> >> +#define  __suart_err(fmt, args...) printk(KERN_ERR "suart_err: " fmt, ##
> >> args)
> >
> > Use dev_dbg/dev_err/pr_debug/pr_err
> 
> SG - did you mean replace the printks above with dev_dgb/err or the 
> suart_dbg/err.

Ideally all the messages shopuld use dev_dbg/dev_err etc. That allows you
to configure debug levels and the like nicely as well as producing
clearer printk info. In some cases with tty code you may not know the
device so have to use pr_err/pr_debug etc.

Ok

> > Which is never checked. Far better to use WARN_ON and the like for such
> > cases - or if like this one they don't appear to be possible to simply
> > delete them
> 
> SG -- OK, does this look ok ?
> =================================
> if (h_uart == NULL) {
> +WARN_ON(1);
> - return PRU_SUART_ERR_HANDLE_INVALID;
> +return -EINVAL;
> }

Yep - the user will now get a backtrace, and in addition kerneloops.org
can capture it if that is set up in the distro in use.

Alan
