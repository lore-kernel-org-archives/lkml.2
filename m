Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278Ab2AEAbn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 19:31:43 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:47823 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932183Ab2AEAbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 19:31:40 -0500
X-Sasl-enc: BaSO9YkIFjqs7TeIJa/2/RwWG4JHF51nEr2fse3zTrDz 1325723499
Date: Wed, 4 Jan 2012 16:23:36 -0800
From: Greg KH <greg@kroah.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: cleanup prohibition of direct opening for unix98
 pty master
Message-ID: <20120105002336.GA30069@kroah.com>
References: <20120102172231.11476.57711.stgit@zurg>
 <20120103085110.17283.60539.stgit@zurg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120103085110.17283.60539.stgit@zurg>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 03, 2012 at 12:51:11PM +0400, Konstantin Khlebnikov wrote:
> cleanup hack added in v2.6.27-3203-g15582d3
> 
> comment from that patch:
> 
> : pty: If the administrator creates a device for a ptmx slave we should not error
> :
> : The open path for ptmx slaves is via the ptmx device. Opening them any
> : other way is not allowed. Vegard Nossum found that previously this was not
> : the case and mknod foo c 128 42; cat foo would produce nasty diagnostics
> :
> : Signed-off-by: Alan Cox <alan@redhat.com>
> : Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> devpts_get_tty() returns non-null only for inodes on devpts, but there is no
> inodes for master-devices, /dev/ptmx (/dev/pts/ptmx) is the only way to open them.
> Thus we can completely forbid lookup for master-devices and eliminate that hack in
> tty_init_dev() because tty_open() will get EIO from tty_driver_lookup_tty().
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>

What tree did you make this patch against?  I get fuzz warnings when
applying it to the tty-next branch (it's in the linux-next releases).

Please rediff it and resend it.

thanks,

greg k-h
