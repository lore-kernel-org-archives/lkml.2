Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891Ab2CLKv0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 06:51:26 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40928 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab2CLKvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 06:51:23 -0400
Date: Mon, 12 Mar 2012 10:53:12 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Richard Weinberger <richard@nod.at>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: TTY: tty_port questions
Message-ID: <20120312105312.665d2362@pyramind.ukuu.org.uk>
In-Reply-To: <4F5DCF39.8080308@nod.at>
References: <4F5BD51B.7030907@nod.at>
	<4F5BDB09.3020407@suse.cz>
	<4F5BE1E6.9000201@nod.at>
	<4F5C861F.2000507@nod.at>
	<4F5DCF39.8080308@nod.at>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Another question, what is the purpose of tty_port->console?
> It seems to have no user.

So the tty_port layer can in future know about whether it is a console
without a tty necessarily being present or referenceable.

> Is tty_port really the right thing for a console driver like in the UML 
> case?

It will be. In order to fix the tty locking mess we need to shove a lot
of stuff whose lifetime is the lifetime of the physical port somewhere
else - the tty_port is that structure.

Alan
