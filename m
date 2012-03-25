Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110Ab2CYVGf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 17:06:35 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:52184 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776Ab2CYVGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 17:06:33 -0400
Date: Sun, 25 Mar 2012 22:06:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Richard Weinberger <richard@nod.at>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: TTY: tty_port questions
Message-ID: <20120325220610.49063ad7@ultron>
In-Reply-To: <20120325183114.GM6589@ZenIV.linux.org.uk>
References: <4F5BD51B.7030907@nod.at>
	<4F5BDB09.3020407@suse.cz>
	<4F5BE1E6.9000201@nod.at>
	<4F5C861F.2000507@nod.at>
	<4F5DCF39.8080308@nod.at>
	<20120312105312.665d2362@pyramind.ukuu.org.uk>
	<4F5DDAD4.4060504@nod.at>
	<20120312114832.784bb6fe@pyramind.ukuu.org.uk>
	<20120324232001.GK6589@ZenIV.linux.org.uk>
	<20120325155143.7ca7cb13@ultron>
	<20120325183114.GM6589@ZenIV.linux.org.uk>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Mar 2012 19:31:14 +0100
Al Viro <viro@ZenIV.linux.org.uk> wrote:

> How is tty_port supposed to work wrt hotplug?  I.e. are those guys (OK,
> the structures they are embedded into) supposed to live as long as
> tty_driver lives?  AFAICS, for serial we have an extra layer atop of
> those guys (uart_port) and that's where removals seem to act, but there
> seems to be more to it...

Serial had pre-exising gunge not all of which has been cleaned, just as
it still has its own buffers that want to be using kfifo.

Best examples are probably USB serial and neatest may well be the sdio
serial card driver.

> Suppose we handle uml reconfig requests as port removal + port addition;
> what's needed to make sure that port is out of use and we can play with
> it without stepping on anyone's toes?  Something along the lines of what
> uart_remove_one_port() is doing?  I.e. tty_unregister_device() + tty_vhangup()?
> But serial_core seems to be open-coding tty_port_open() for some reason
> and _there_ we have port->count updates under port->mutex, so the
> situation might be different...

If you are creating/removing physical ports (or fake physical ports) you
probably need to be refcounting them too.

Alan

