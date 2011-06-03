Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab1FCVxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 17:53:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35115 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754648Ab1FCVxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 17:53:19 -0400
MIME-Version: 1.0
In-Reply-To: <1307106096-6461-1-git-send-email-jslaby@suse.cz>
References: <1307106096-6461-1-git-send-email-jslaby@suse.cz>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 4 Jun 2011 06:52:57 +0900
Message-ID: <BANLkTik5QP7e=+FWSa1kLVpCjZpWEtF1PQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] TTY: ldisc, do not close until there are readers
To: Jiri Slaby <jslaby@suse.cz>
Cc: gregkh@suse.de, jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 3, 2011 at 10:01 PM, Jiri Slaby <jslaby@suse.cz> wrote:
>
> There is a difference, we need uninterruptible sleep as there is
> obviously HUP signal pending. So tty_ldisc_wait_idle now takes
> interruptible parameter to decide. I'm not sure whether it's worth the
> complexity. Instead uninterruptible waiting may fit even for the ldisc
> change code. It wouldn't be possible to interrupted the change, but
> there is 5s timeout anyway.

Ugh. I'd much rather not see these kinds of random flags.

> This is nicely reproducible after constify the timing as follows:
> --- a/drivers/tty/n_tty.c
> +++ b/drivers/tty/n_tty.c

And PLEASE don't do things like this: you just introduced a patch
inside the email that shows the bug, and now any sane email
application tool will just assume that THIS patch is the one you want
to apply. So rather than applying the fix, it will apply the
"descriptive" patch to intentionally introduce the timing delays to
show the bug!

So don't include actual real patches like this without indenting them
or doing something to make it really really obvious that the patch is
not the one to be applied, but just a description of the problem!

                     Linus
