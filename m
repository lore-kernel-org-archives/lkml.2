Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205Ab0K2Vui (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 16:50:38 -0500
Received: from kroah.org ([198.145.64.141]:37025 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388Ab0K2Vuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 16:50:37 -0500
Date: Mon, 29 Nov 2010 13:50:30 -0800
From: Greg KH <greg@kroah.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: gregkh@suse.de, slapin@ossfans.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 1/2] TTY: ldisc, fix open flag handling
Message-ID: <20101129215030.GC9830@kroah.com>
References: <4CED9498.9080900@suse.cz>
 <1290641275-21726-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290641275-21726-1-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 12:27:54AM +0100, Jiri Slaby wrote:
> When a concrete ldisc open fails in tty_ldisc_open, we forget to clear
> TTY_LDISC_OPEN. This causes a false warning on the next ldisc open:
> WARNING: at drivers/char/tty_ldisc.c:445 tty_ldisc_open+0x26/0x38()
> Hardware name: System Product Name
> Modules linked in: ...
> Pid: 5251, comm: a.out Tainted: G        W  2.6.32-5-686 #1
> Call Trace:
>  [<c1030321>] ? warn_slowpath_common+0x5e/0x8a
>  [<c1030357>] ? warn_slowpath_null+0xa/0xc
>  [<c119311c>] ? tty_ldisc_open+0x26/0x38
>  [<c11936c5>] ? tty_set_ldisc+0x218/0x304
> ...
> 
> So clear the bit when failing...
> 
> Introduced in c65c9bc3efa (tty: rewrite the ldisc locking) back in
> 2.6.31-rc1.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Alan Cox <alan@linux.intel.com>
> Reported-by: Sergey Lapin <slapin@ossfans.org>
> Tested-by: Sergey Lapin <slapin@ossfans.org>

Is this still needed, or can I just use your:
	[PATCH v2 1/2] TTY: don't allow reopen when ldisc is changing
patch instead?

thanks,

greg k-h
