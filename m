Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481Ab2FDVOP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 17:14:15 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:43846 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606Ab2FDVOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 17:14:14 -0400
Date: Mon, 4 Jun 2012 22:17:31 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Richard Weinberger <richard@nod.at>
Cc: jslaby@suse.cz, user-mode-linux-devel@lists.sourceforge.net,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, alan@linux.intel.com
Subject: Re: um: TTY fixes (?)
Message-ID: <20120604221731.5e378fc2@pyramind.ukuu.org.uk>
In-Reply-To: <1338841657-30358-1-git-send-email-richard@nod.at>
References: <1338841657-30358-1-git-send-email-richard@nod.at>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 	On all other ttys login works but bash dies because of of -EIO.
> 	After vhangup() the tty returns -EIO upon read()/write().

You can't re-open the tty because a process is holding on to it, not
closing it and not killable. Fedora shouldn't be holding these devices
open this way. The behaviour we have of refusing to reopen them why this
is the case is both a) what the spec seems to say b) good security.

We can half ignore it on console for the simple reason that you don't
"dial in" to the console. I suspect it may be abusable but I've not found
a way to do so.

> I have no idea what's the root cause of this, there seems to be a lot of black magic
> involved.
> Alan, do you think the issues are caused by Fedora's broken user space?

See what fuser says about open file handles and if that is what is going
on.

Alan
