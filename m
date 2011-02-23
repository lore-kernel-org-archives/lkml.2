Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526Ab1BWA2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 19:28:34 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40278 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755149Ab1BWA2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 19:28:33 -0500
Date: Wed, 23 Feb 2011 00:30:33 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] tty: add TIOCVHANGUP: time for revoke() in f_ops ?
Message-ID: <20110223003033.49c89c04@lxorguk.ukuu.org.uk>
In-Reply-To: <20110223002313.GA21518@tango.0pointer.de>
References: <1297964368.2165.1.camel@yio>
	<20110218095048.4e9f1e1a@lxorguk.ukuu.org.uk>
	<20110222231536.GA18066@kroah.com>
	<20110223000958.7c18fdef@lxorguk.ukuu.org.uk>
	<20110223002313.GA21518@tango.0pointer.de>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> vhangup() is different from revoke(). vhangup() does weird SIGHUP
> handling and stuff, which I think goes way beyond what revoke() would
> eventually do. And that different behaviour becomes visible in various

Revoke() will also do this because you remove the controlling process
from the tty. What happens then is mandated by SuS/POSIX.

> > Its not a quick patch - that's why its not happened yet, vhangup(fd)
> > quickfix Lennart style is unfortunately a useless bodge job which like
> > most bodge jobs is simply going to spring leaks and need fixing again.
> 
> Thanks. If you are trying to insult me, doesn't really work,

Not intended as an insult. Believe me I wish a fix like that was viable,
but it's not - which is why its not been in the tree for years.

Alan
