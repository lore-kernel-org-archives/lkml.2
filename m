Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078Ab0KZN2F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 08:28:05 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54948 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250Ab0KZN2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 08:28:03 -0500
Date: Fri, 26 Nov 2010 08:27:58 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Kyle McMartin <kyle@mcmartin.ca>, gregkh@suse.de,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/1] TTY: don't allow reopen when ldisc is changing
Message-ID: <20101126132758.GN22651@bombadil.infradead.org>
References: <4CEE93FF.3040507@suse.cz>
 <1290705383-6608-1-git-send-email-jslaby@suse.cz>
 <20101126002840.GL22651@bombadil.infradead.org>
 <4CEF65CA.9020403@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CEF65CA.9020403@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 26, 2010 at 08:46:18AM +0100, Jiri Slaby wrote:
> On 11/26/2010 01:28 AM, Kyle McMartin wrote:
> > On Thu, Nov 25, 2010 at 06:16:23PM +0100, Jiri Slaby wrote:
> >> -	if (test_bit(TTY_CLOSING, &tty->flags))
> >> +	if (test_bit(TTY_CLOSING, &tty->flags) ||
> >> +			test_bit(TTY_LDISC_CHANGING, &tty->flags))
> >>  		return -EIO;
> >>  
> >>  	if (driver->type == TTY_DRIVER_TYPE_PTY &&
> > 
> > Unfortunately, users report this doesn't seem to fix things for them
> > (built against 2.6.36 (plus another patch you wrote iirc.))
> 
> Which patches exactly do you have? You need three of mine in 2.6.36.
> 

Just tty-restore-tty_ldisc_wait_idle.patch on top of 2.6.36.1, I'll grab
the other two now.

--Kyle
