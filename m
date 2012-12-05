Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab2LERGj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 12:06:39 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:53725 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201Ab2LERGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 12:06:38 -0500
Date: Wed, 5 Dec 2012 17:11:40 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Peter Hurley <peter@hurleysoftware.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH RESEND] tty: don't dead lock while flushing workqueue
Message-ID: <20121205171140.03b6ca06@pyramind.ukuu.org.uk>
In-Reply-To: <50BF732C.6030306@linutronix.de>
References: <1353501542-14707-1-git-send-email-bigeasy@linutronix.de>
	<20121121140426.1860d093@pyramind.ukuu.org.uk>
	<20121127095357.GA3536@breakpoint.cc>
	<20121127172249.GB24592@kroah.com>
	<20121127180108.GA7376@linutronix.de>
	<1354556465.2531.169.camel@thor>
	<50BF732C.6030306@linutronix.de>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Dec 2012 17:15:40 +0100
Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:

> On 12/03/2012 06:41 PM, Peter Hurley wrote:
> > The lock logic for tty_set_ldisc() is wrong. Despite existing code in
> > tty_set_ldisc() and tty_ldisc_hangup(), the ldisc_mutex does **not**
> > (and should not) play a role in acquiring or releasing ldisc references.
> > The only thing that needs to happen here is below (don't actually use
> > below because I just hand-edited it):
> 
> Hmm. What about I stay in sync with the code that is already in tree
> and if the wrong locking gets removed in both places later on?
> 
> Alan, what do you prefer?

So long as it ends up right I don't care 8)
