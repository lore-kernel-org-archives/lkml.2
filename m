Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266Ab0JGVNA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 17:13:00 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52185 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755726Ab0JGVM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 17:12:59 -0400
Date: Thu, 7 Oct 2010 22:38:19 +0100
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
Message-ID: <20101007223819.46246716@lxorguk.ukuu.org.uk>
In-Reply-To: <1286484678.23836.49.camel@c-dwalke-linux.qualcomm.com>
References: <1286476616-3373-1-git-send-email-dwalker@codeaurora.org>
	<20101007215019.17b4a34a@lxorguk.ukuu.org.uk>
	<1286483766.23836.39.camel@c-dwalke-linux.qualcomm.com>
	<20101007220538.2294a7e4@lxorguk.ukuu.org.uk>
	<1286484678.23836.49.camel@c-dwalke-linux.qualcomm.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Your making too many assumptions .. You might be able to modify the
> kernel, and not the userspace. So you couldn't tweak the device
> creation .. It's much easier in the server world ..

Spare me the embedded is different lecture. It's not. In fact it's
usually easier because the environment you are testing is usually
standalone, doesn't cause a million dollar an hour downtime if you get it
wrong and was designed for debug/test so actually has a jtag port.

If you can modify the file system you can make /dev/ttyS0 the major/minor
of the jtag port.

If you can load anything in front of the userspace you can rename the
device/move it

So I find your example case fictional. In fact the only time I can see
you having a box so tightly locked up you can only tweak the kernel is
jailbreaking it, in which case you are such a fringe usage case and
technically competent that you can just do custom patches as you'll be
doing anyway for other bits.

> > We've said no over a period of about ten years to a lot of attempts to
> > just borrow the ttyS0 range. If we'd said yes it would have been a
> > complete mess by now.
> > 
> > So the answer is no.
> 
> Nothing can be unilateral, there's always room for exceptions. You
> should say something more like "it's possible, but unlikely".

This argument gets regurgitated every so often and nobody has yet
provided a plausable reason to make a nasty mess.

Either way I would suggest the path forward is

- Look at the blackfin jtag using tty_port alone and see if it looks
  cleaner
- Fix the bugs noted
- Submit a driver that uses the existing allocated jtag major/minor only

and then have a debate about ttyS0 hackery separately.

Alan
