Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab2FKKud (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 06:50:33 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:52448 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806Ab2FKKuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 06:50:32 -0400
Date: Mon, 11 Jun 2012 11:54:14 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: eric.valette@free.fr
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.2.19 kernel panic does not enter KDB
Message-ID: <20120611115414.06759ae3@pyramind.ukuu.org.uk>
In-Reply-To: <4FD48744.3000602@free.fr>
References: <4FD4837B.5040200@free.fr>
	<20120610123420.52af4e1a@pyramind.ukuu.org.uk>
	<4FD48744.3000602@free.fr>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> type of answer helps nothing. I know nobody there is going to debug 
> nvidia driver but I'm not even sure its not something else. Neither are you.
> 
> So the bug is still that KDB is not entered.

There are lots of ways kdb may not get entered on a driver crash.
This is especially true from complex DMA capable hardware than can do
anything. For a lot of stuff you'd run it under something like qemu so
you could debug that way but for graphics drivers that doesn't really
work.

So to debug it you'd start by commenting out bits of the driver code to
see if it still does it if those parts are not executed. You can't do
that with the Nvidia blob so you'll have to get Nvidia to do the work.

If it was occurring with the Nouveau driver you'd be able to comment
stuff out and try and work out which particular paths triggered the
problem.

kdb not getting entered is not itself a bug - its a limitation.

Alan
