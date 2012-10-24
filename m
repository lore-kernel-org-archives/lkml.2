Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934303Ab2JXCul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 22:50:41 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:45957 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934239Ab2JXCuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 22:50:39 -0400
Date: Tue, 23 Oct 2012 19:51:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@linux.intel.com>
Subject: Re: linux-next: build failure after merge of the tty tree
Message-ID: <20121024025112.GA7982@kroah.com>
References: <20121024132827.b22e6f33031f785ff0189791@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121024132827.b22e6f33031f785ff0189791@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 01:28:27PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> After merging the tty tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> drivers/staging/dgrp/dgrp_net_ops.c: In function 'dgrp_input':
> drivers/staging/dgrp/dgrp_net_ops.c:216:27: error: 'struct tty_struct' has no member named 'real_raw'
> drivers/staging/dgrp/dgrp_net_ops.c:229:8: error: 'struct tty_struct' has no member named 'read_cnt'
> drivers/staging/dgrp/dgrp_net_ops.c:229:8: error: 'struct tty_struct' has no member named 'read_cnt'
> drivers/staging/dgrp/dgrp_net_ops.c:261:30: error: 'struct tty_struct' has no member named 'real_raw'
> drivers/staging/dgrp/dgrp_net_ops.c:276:28: error: 'struct tty_struct' has no member named 'real_raw'
> 
> Caused by commits 53c5ee2cfb4d ("TTY: move ldisc data from tty_struct:
> simple members") and ba2e68ac6157 ("TTY: move ldisc data from tty_struct:
> read_* and echo_* and canon_* stuff") interacting with commit
> 0b52b7497271 ("staging: Add dgrp driver for Digi Realport devices") now
> in Linus' tree.
> 
> I disabled building of the dgrp driver for now using this merge fix patch:
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Wed, 24 Oct 2012 13:25:29 +1100
> Subject: [PATCH] staging: disable dgrp driver since it is broken by tty
>  changes
> 
> drivers/staging/dgrp/dgrp_net_ops.c: In function 'dgrp_input':
> drivers/staging/dgrp/dgrp_net_ops.c:216:27: error: 'struct tty_struct' has no member named 'real_raw'
> drivers/staging/dgrp/dgrp_net_ops.c:229:8: error: 'struct tty_struct' has no member named 'read_cnt'
> drivers/staging/dgrp/dgrp_net_ops.c:229:8: error: 'struct tty_struct' has no member named 'read_cnt'
> drivers/staging/dgrp/dgrp_net_ops.c:261:30: error: 'struct tty_struct' has no member named 'real_raw'
> drivers/staging/dgrp/dgrp_net_ops.c:276:28: error: 'struct tty_struct' has no member named 'real_raw'
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/staging/dgrp/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/dgrp/Kconfig b/drivers/staging/dgrp/Kconfig
> index 39f4bb6..7d378c2 100644
> --- a/drivers/staging/dgrp/Kconfig
> +++ b/drivers/staging/dgrp/Kconfig
> @@ -2,6 +2,7 @@ config DGRP
>         tristate "Digi Realport driver"
>         default n
>         depends on SYSFS
> +	depends on BROKEN

Thanks, that makes sense for now, hopefully Jiri will return from his
conference and fix this driver up.

greg k-h
