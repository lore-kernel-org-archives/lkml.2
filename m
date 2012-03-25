Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785Ab2CYSbW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 14:31:22 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48514 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756718Ab2CYSbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 14:31:21 -0400
Date: Sun, 25 Mar 2012 19:31:14 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Richard Weinberger <richard@nod.at>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: TTY: tty_port questions
Message-ID: <20120325183114.GM6589@ZenIV.linux.org.uk>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120325155143.7ca7cb13@ultron>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How is tty_port supposed to work wrt hotplug?  I.e. are those guys (OK,
the structures they are embedded into) supposed to live as long as
tty_driver lives?  AFAICS, for serial we have an extra layer atop of
those guys (uart_port) and that's where removals seem to act, but there
seems to be more to it...

Suppose we handle uml reconfig requests as port removal + port addition;
what's needed to make sure that port is out of use and we can play with
it without stepping on anyone's toes?  Something along the lines of what
uart_remove_one_port() is doing?  I.e. tty_unregister_device() + tty_vhangup()?
But serial_core seems to be open-coding tty_port_open() for some reason
and _there_ we have port->count updates under port->mutex, so the
situation might be different...

Is there any FMtoR/thread/search terms that would give the description of
the situation?
