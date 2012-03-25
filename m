Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130Ab2CYOwJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 10:52:09 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:39716 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756102Ab2CYOwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 10:52:07 -0400
Date: Sun, 25 Mar 2012 15:51:43 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Richard Weinberger <richard@nod.at>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: TTY: tty_port questions
Message-ID: <20120325155143.7ca7cb13@ultron>
In-Reply-To: <20120324232001.GK6589@ZenIV.linux.org.uk>
References: <4F5BD51B.7030907@nod.at>
	<4F5BDB09.3020407@suse.cz>
	<4F5BE1E6.9000201@nod.at>
	<4F5C861F.2000507@nod.at>
	<4F5DCF39.8080308@nod.at>
	<20120312105312.665d2362@pyramind.ukuu.org.uk>
	<4F5DDAD4.4060504@nod.at>
	<20120312114832.784bb6fe@pyramind.ukuu.org.uk>
	<20120324232001.GK6589@ZenIV.linux.org.uk>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Mar 2012 23:20:01 +0000
Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Mon, Mar 12, 2012 at 11:48:32AM +0000, Alan Cox wrote:
> 
> > > > It will be. In order to fix the tty locking mess we need to shove a lot
> > > > of stuff whose lifetime is the lifetime of the physical port somewhere
> > > > else - the tty_port is that structure.
> > > >
> > > 
> > > "It will be" in terms of "not now"? ;-)
> > 
> > As in, it's the very next step on.
> 
> FWIW, uml console in default config is basically "start xterm for each VC".
> What do you suggest to do on vhangup() on one of those?

What posix says must happen. Which is that the running processes get a
hangup. So a vhangup() would ensure there were no old apps on the UML
guess talking to the xterm (eg stealing login credentials, or abusing
TIOCSTI etc).

The fact it's an xterm isn't really relevant. That's just the physical
interface and vhangup is about breaking the logical link. The xterm would
continue, no reason for it to do otherwise I can see ?

Alan
