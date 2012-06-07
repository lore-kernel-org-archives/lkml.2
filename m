Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760610Ab2FGKtO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 06:49:14 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:47803 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760578Ab2FGKtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 06:49:12 -0400
Date: Thu, 7 Jun 2012 11:52:27 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Richard Weinberger <richard@nod.at>
Cc: Boaz Harrosh <bharrosh@panasas.com>,
        user-mode-linux-devel@lists.sourceforge.net,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, jslaby@suse.cz, alan@linux.intel.com
Subject: Re: [uml-devel] um: TTY fixes (?)
Message-ID: <20120607115227.6643d1ad@pyramind.ukuu.org.uk>
In-Reply-To: <4FD0802A.1020203@nod.at>
References: <1338841657-30358-1-git-send-email-richard@nod.at>
	<4FCF6748.6020005@panasas.com>
	<4FD059AC.8050808@panasas.com>
	<4FD06A22.6040002@nod.at>
	<4FD07F14.50902@panasas.com>
	<4FD0802A.1020203@nod.at>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I really don't get it. You have not broken anything new. Only
> > not fixed all of the problems. Current code does not work for "non-tty0
> > terminals" as well right?
> 
> No, it works fine.

Not really. You happen to be lucky. Anyway with no tty port the UML code
will soon cease to function completely so a solution of some sort is
needed.
 
> > I don't see Alan's comment at all. This is not a regression it was always
> > like that. Ever since Fedora was working on UML, But these fixes are real
> > live regression crashes.
> > 
> > And I don't see the all "leaving other vendors systems insecure". It just
> > a freaking UML tty. You need to be root 5 times before you have access
> > to all these, and it's only the UML that's compromised not the "all system"
> > And surely the current plain tty0 crash is much less secure then this thing.
> 
> The "TTY problem" is not UML specific.

That one is. The console driver handles stuff its own way and
differently. It's eventually got to tackle the same problem.

I still think we ought to be able to solve it cleanly. It's a case of
getting the tests right so that we allow for the misbehaviour util-linux
does.

As of itself util-linux behaviour doesn't appear to be something we can't
permit as the 

	open
	vhangup

sequence means the file handle that is left from before the vhangup due
to util-linux misbehaving is a hung-up fd so cannot affect the tty.

UML is a good test case for fixing this properly because it's got almost
no users, and those it has are fairly technical 8)


Alan
