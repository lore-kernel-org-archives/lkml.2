Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505Ab1HZSer (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 14:34:47 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52394 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750715Ab1HZSem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 14:34:42 -0400
Date: Fri, 26 Aug 2011 19:33:31 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/9] gma500: frame buffer locking
Message-ID: <20110826193331.5d42e0bf@lxorguk.ukuu.org.uk>
In-Reply-To: <20110826174547.GA9937@kroah.com>
References: <20110826101734.16760.64364.stgit@localhost.localdomain>
	<20110826101945.16760.8598.stgit@localhost.localdomain>
	<20110826174547.GA9937@kroah.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > index e861488..af2eec8 100644
> > --- a/kernel/printk.c
> > +++ b/kernel/printk.c
> > @@ -512,7 +512,7 @@ static void __call_console_drivers(unsigned start, unsigned end)
> >  	struct console *con;
> >  
> >  	for_each_console(con) {
> > -		if (exclusive_console && con != exclusive_console)
> > +		if (0 && exclusive_console && con != exclusive_console)
> >  			continue;
> >  		if ((con->flags & CON_ENABLED) && con->write &&
> >  				(cpu_online(smp_processor_id()) ||
> 
> Are you sure you want this in the tree?  I don't feel comfortable making
> this fix just for one staging driver right now, do you?

Oops no thats a debugging hack while using netconsole to chase out the
bug.. that bit shouldn't be there !
