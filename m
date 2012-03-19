Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757770Ab2CSLLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 07:11:22 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50549 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655Ab2CSLLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 07:11:20 -0400
Date: Mon, 19 Mar 2012 12:11:16 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Julia Lawall <Julia.Lawall@lip6.fr>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCHv2] simple_open: Automatically convert to simple_open()
Message-ID: <20120319111116.GA3376@gmail.com>
References: <20120316164911.dbc089de.akpm@linux-foundation.org>
 <1331976099-19341-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331976099-19341-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephen Boyd <sboyd@codeaurora.org> wrote:

> Many users of debugfs copy the implementation of default_open()
> when they want to support a custom read/write function op. This
> leads to a proliferation of the default_open() implementation
> across the entire tree. Now that the common implementation has
> been consolidated into libfs we can replace all the users of this
> function with simple_open().
> 
> This replacement was done with the following semantic patch:
> 
> <smpl>
> @ open @
> identifier open_f != simple_open;
> identifier i, f;
> @@
> -int open_f(struct inode *i, struct file *f)
> -{
> (
> -if (i->i_private)
> -f->private_data = i->i_private;
> |
> -f->private_data = i->i_private;
> )
> -return 0;
> -}
> 
> @ has_open depends on open @
> identifier fops;
> identifier open.open_f;
> @@
> struct file_operations fops = {
> ...
> -.open = open_f,
> +.open = simple_open,
> ...
> };
> </smpl>
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Julia Lawall <Julia.Lawall@lip6.fr>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/arm/mach-msm/smd_debug.c                   |    8 +----
>  arch/x86/kernel/kdebugfs.c                      |    9 +----

My ack for the previous version still holds:

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
