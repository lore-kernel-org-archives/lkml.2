Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758265Ab2IJTOw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 15:14:52 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:52176 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758097Ab2IJTOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 15:14:50 -0400
Date: Mon, 10 Sep 2012 20:19:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Wessel <jason.wessel@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>,
        Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        Colin Cross <ccross@android.com>, Brian Swetland <swetland@google.com>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        kgdb-bugreport@lists.sourceforge.net, linux-serial@vger.kernel.org
Subject: Re: [PATCH 08/14] tty/serial/kgdboc: Add and wire up clear_irqs
 callback
Message-ID: <20120910201918.1e3c8fd0@pyramind.ukuu.org.uk>
In-Reply-To: <20120910175704.GA11392@lizard>
References: <20120910040802.GA1261@lizard>
	<20120910041357.GH29537@lizard>
	<20120910121624.226c1a88@pyramind.ukuu.org.uk>
	<20120910175704.GA11392@lizard>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Sep 2012 10:57:04 -0700
Anton Vorontsov <anton.vorontsov@linaro.org> wrote:

> On Mon, Sep 10, 2012 at 12:16:24PM +0100, Alan Cox wrote:
> > > serial port, the CPU receives NMI exception, and we fall into KDB
> > > shell.  So, it is our "debug console", and it is able to interrupt
> > > (and thus debug) even IRQ handlers themselves.
> > 
> > You seem to have an assumption of single core here. What happens if
> > the NMI hits CPU #0 and the serial IRQ hits CPU #1 simultaneously ?
> 
> If you can't redirect all serial IRQs to NMI context, e.g. sometimes you get
> NMIs, sometimes IRQs, then your NMI handling is not deterministic, and surely
> this is not supported.

This seems like arch specific magic leaking into the tty code. Surely
this should be buried in the depths of the platform IRQ code ?

Alan
