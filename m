Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429Ab2JWAAF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 20:00:05 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:46126 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932102Ab2JWAAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 20:00:02 -0400
Date: Mon, 22 Oct 2012 16:59:58 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: [PATCH 00/21] TTY buffer in tty_port and other stuff
Message-ID: <20121022235958.GA7053@kroah.com>
References: <1350592007-9216-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350592007-9216-1-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 10:26:26PM +0200, Jiri Slaby wrote:
> Hi,
> 
> this is the fifth series of patches which finally move tty buffers
> from tty_struct (present from open to close/hangup) to tty_port
> (present as long as the device). This allows us to get rid of the tty
> refcounting in the interrupt service routines and other hot paths
> after we are done. This is because we do not need to handle races
> among ISRs, timers, hangups and others, because tty_port lives as long
> as an interrupt/timer tick may occur. Unlike tty_struct.
> 
> This set also cleans up devpts handling a bit. Devpts used to play
> with tty->driver_data which was a bit ugly. Now devpts returns a node
> which we store to driver_data and pass it back when we need devpts to
> kill that. As a result, we can do that in the pty code instead of an
> ugly hook in tty_release.
> 
> Finally, the set moves all the n_tty private stuff from tty_struct to
> its own (internal) structure. This was an intention last time ago (at
> least here), but the races and undefined ldisc->open/close behavior
> did not allow us to do that. Now that we have ldisc kills and waits
> and bells and whistles we could finally go ahead.
> 
> As usual, standard x86 stuff was runtime-tested. The rest is only
> checked to be compilation-errors free.

I've applied all of these, very nice.

But you broke one of the staging drivers (drivers/staging/dgrp/)  Care
to fix that up now?

thanks,

greg k-h
