Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010Ab3AGWgO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 17:36:14 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:37560 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593Ab3AGWgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 17:36:12 -0500
Date: Mon, 7 Jan 2013 14:36:09 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging/sb105x: remove asm/segment.h dependency
Message-ID: <20130107223609.GA27477@kroah.com>
References: <50EB4A3B.1020307@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50EB4A3B.1020307@suse.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2013 at 05:20:43PM -0500, Jeff Mahoney wrote:
> sb105x doesn't seem to actually need <asm/segment.h> (builds on x86
> without it) and ppc/ppc64 doesn't provide it so it fails to build there.
> 
> This patch removes the dependency. Unfortunately, it now fails to build
> because STD_COM_FLAGS isn't defined on most architectures. I'm not familiar
> enough with the tty/serial system to patch that aspect of it.
> 
> CC: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
> 
>  drivers/staging/sb105x/sb_pci_mp.h |    1 -
>  1 file changed, 1 deletion(-)

I just committed a patch from Steven that keeps this driver from
building at all on non-x86 platforms, and it should show up in Linus's
next release.  That should solve the build issue for you, so I'll hold
off on applying this one, and let Steven fix it properly.

thanks,

greg k-h
