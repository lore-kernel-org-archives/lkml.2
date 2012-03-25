Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574Ab2CYVJa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 17:09:30 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:52193 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab2CYVJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 17:09:29 -0400
Date: Sun, 25 Mar 2012 22:09:07 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Richard Weinberger <richard@nod.at>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: TTY: tty_port questions
Message-ID: <20120325220907.0591f517@ultron>
In-Reply-To: <20120325172018.GL6589@ZenIV.linux.org.uk>
References: <4F5BDB09.3020407@suse.cz>
	<4F5BE1E6.9000201@nod.at>
	<4F5C861F.2000507@nod.at>
	<4F5DCF39.8080308@nod.at>
	<20120312105312.665d2362@pyramind.ukuu.org.uk>
	<4F5DDAD4.4060504@nod.at>
	<20120312114832.784bb6fe@pyramind.ukuu.org.uk>
	<20120324232001.GK6589@ZenIV.linux.org.uk>
	<20120325155143.7ca7cb13@ultron>
	<4F6F365D.5060703@nod.at>
	<20120325172018.GL6589@ZenIV.linux.org.uk>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Mar 2012 18:20:18 +0100
Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Sun, Mar 25, 2012 at 05:14:37PM +0200, Richard Weinberger wrote:
> > >> FWIW, uml console in default config is basically "start xterm for each VC".
> > >> What do you suggest to do on vhangup() on one of those?
> > > 
> > > What posix says must happen. Which is that the running processes get a
> > > hangup. So a vhangup() would ensure there were no old apps on the UML
> > > guess talking to the xterm (eg stealing login credentials, or abusing
> > > TIOCSTI etc).
> 
> IIRC, vhangup(2) is Linux-specific, so I would be surprised if POSIX had
> anything on it...

vhangup causes a carrier drop event equivalent. The rest of the behavior
is POSIX/SUSv3.

> login(1) from util-linux does vhangup(); login(1) from shadow doesn't.

Shadow assumes the getty cleans the channel I believe.

> The thing is, we don't want to do that when port is in use.  And we definitely
> don't want somebody to open the damn thing when it's halfway through getting
> set up.  I don't see any natural way to do that exclusion with tty_port -
> port->{count,block_open} is protected only by a spinlock and port setup
> we need to do is blocking...

How does this differ from a hardware hotplug ?

Alan
