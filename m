Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab0IPQps (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 12:45:48 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38055 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753491Ab0IPQpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 12:45:46 -0400
Date: Thu, 16 Sep 2010 18:07:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>, j.dumon@option.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        security@kernel.org, davem@davemloft.net, stable@kernel.org
Subject: Re: [PATCH v2] drivers/net/usb/hso.c: prevent reading uninitialized
 memory
Message-ID: <20100916180710.07821bdd@lxorguk.ukuu.org.uk>
In-Reply-To: <20100916155745.GB14318@home.goodmis.org>
References: <1284587008.6275.95.camel@dan>
	<20100916155745.GB14318@home.goodmis.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

->tiocmget;
> >  
> > +	memset(&icount, 0, sizeof(struct serial_icounter_struct));
> > +
> 
> Move the above to after the spinlocks.

Why - its a local variable ?

Easier to write

	struct serial_icounter_struct icount = { 0 };

though
