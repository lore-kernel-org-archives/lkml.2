Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758Ab2FLWzu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 18:55:50 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62950 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269Ab2FLWzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 18:55:48 -0400
Date: Tue, 12 Jun 2012 15:55:44 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: [PATCH 16/24] PTY: add tty_port
Message-ID: <20120612225544.GA13297@kroah.com>
References: <1338809738-18967-1-git-send-email-jslaby@suse.cz>
 <1338809738-18967-17-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338809738-18967-17-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2012 at 01:35:30PM +0200, Jiri Slaby wrote:
> This has *no* function in the PTY driver yet. However as the tty
> buffers will move to the tty_port structure, we will need tty_port for
> all TTYs in the system, PTY inclusive.
> 
> For PTYs this is ensured by allocating 2 tty_port's in pty_install,
> i.e. where the tty->link is allocated. Both tty_port's are properly
> assigned to each end of the tty.
> 
> Freeing is done at the same place where tty is freed, i.e. in
> tty->ops->cleanup.
> 
> This means BTW that tty_port does not outlive TTY in PTY. This might
> be a subject to change in the future if we see some problems.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> ---
>  drivers/tty/pty.c |   25 +++++++++++++++++++++----
>  1 file changed, 21 insertions(+), 4 deletions(-)

As the locking rework got removed from Linus's tree, this patch doesn't
apply, so I've stopped at this point in the series.

Care to refresh it, and resend the rest of the patches, if you still
want me to apply them (I recall 24 wasn't ok, right?)

thanks,

greg k-h
