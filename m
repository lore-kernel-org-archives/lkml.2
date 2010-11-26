Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab0KZA2p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 19:28:45 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:41657 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769Ab0KZA2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 19:28:45 -0500
Date: Thu, 25 Nov 2010 19:28:40 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Jiri Slaby <jslaby@suse.cz>
Cc: gregkh@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, Kyle McMartin <kyle@mcmartin.ca>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/1] TTY: don't allow reopen when ldisc is changing
Message-ID: <20101126002840.GL22651@bombadil.infradead.org>
References: <4CEE93FF.3040507@suse.cz>
 <1290705383-6608-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290705383-6608-1-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 06:16:23PM +0100, Jiri Slaby wrote:
> -	if (test_bit(TTY_CLOSING, &tty->flags))
> +	if (test_bit(TTY_CLOSING, &tty->flags) ||
> +			test_bit(TTY_LDISC_CHANGING, &tty->flags))
>  		return -EIO;
>  
>  	if (driver->type == TTY_DRIVER_TYPE_PTY &&

Unfortunately, users report this doesn't seem to fix things for them
(built against 2.6.36 (plus another patch you wrote iirc.))

https://bugzilla.redhat.com/show_bug.cgi?id=630464#c27

I tried reverting the TTY patches between 2.6.36 and 2.6.35 and getting
them to test that, and it seems ok:

https://bugzilla.redhat.com/show_bug.cgi?id=630464#c30

So I guess there must be a race here somewhere... I'll keep looking. :/

I would imagine it's something that's probably existed since the dawn of
time but the BKL has just papered over entirely.

Thanks for trying!
  --Kyle
