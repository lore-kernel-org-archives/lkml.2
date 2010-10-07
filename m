Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab0JGUkT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 16:40:19 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37613 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751418Ab0JGUkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 16:40:17 -0400
Date: Thu, 7 Oct 2010 22:05:38 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, "Hyok S. Choi" <hyok.choi@samsung.com>,
        Tony Lindgren <tony@atomide.com>, Jeff Ohlstein <johlstei@quicinc.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Ben Dooks <ben-linux@fluff.org>,
        Alan Cox <alan@linux.intel.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Mike Frysinger <vapier@gentoo.org>, Feng Tang <feng.tang@intel.com>,
        Tobias Klauser <tklauser@distanz.ch>,
        Jason Wessel <jason.wessel@windriver.com>,
        Philippe Langlais <philippe.langlais@stericsson.com>
Subject: Re: [PATCH] serial: DCC(JTAG) serial and console emulation support
Message-ID: <20101007220538.2294a7e4@lxorguk.ukuu.org.uk>
In-Reply-To: <1286483766.23836.39.camel@c-dwalke-linux.qualcomm.com>
References: <1286476616-3373-1-git-send-email-dwalker@codeaurora.org>
	<20101007215019.17b4a34a@lxorguk.ukuu.org.uk>
	<1286483766.23836.39.camel@c-dwalke-linux.qualcomm.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Oct 2010 13:36:06 -0700
Daniel Walker <dwalker@codeaurora.org> wrote:

> On Thu, 2010-10-07 at 21:50 +0100, Alan Cox wrote:
> > > +	  Say Y here if you want to install DCC driver as a normal serial port
> > > +	  /dev/ttyS0 (major 4, minor 64). Otherwise, it appears as /dev/ttyJ0
> > > +	  (major 4, minor 128) and can co-exist with other UARTs, such as
> > > +	  8250/16C550 compatibles.
> > > +
> > 
> > NAK to both
> 
> Both what?

Both device allocations. Please use the 204,186 assigned for JTAG DCC.

> I would agree if this wasn't strictly for debugging embedded devices in
> difficult situations.. After talking to Mike, it's seems like it would
> be useful to have this as a ttyS* specifically because embedded devices
> won't always create a ttyJ* for you and ttyS* will likely already exist.

If you are debugging an embedded device you are capable of changing it
(otherwise you wouldn't debug it). Therefore the fact you might need to
tweak the tty creation on the device is not a problem. If you can't
change the device well there is no point debugging it is there !

We've said no over a period of about ten years to a lot of attempts to
just borrow the ttyS0 range. If we'd said yes it would have been a
complete mess by now.

So the answer is no.

Alan
