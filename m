Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965168Ab2CMKYN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 06:24:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48945 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965103Ab2CMKYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 06:24:12 -0400
Date: Tue, 13 Mar 2012 11:23:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Julia Lawall <Julia.Lawall@lip6.fr>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCHv2 3/3] simple_open: Automatically convert to simple_open()
Message-ID: <20120313102358.GB1516@elte.hu>
References: <1331631988-20527-1-git-send-email-sboyd@codeaurora.org>
 <1331631988-20527-4-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331631988-20527-4-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
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
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  arch/arm/mach-msm/smd_debug.c                   |    8 +----
>  arch/arm/plat-mxc/audmux-v2.c                   |    8 +----
>  arch/x86/kernel/kdebugfs.c                      |    9 +----

Acked-by: Ingo Molnar <mingo@elte.hu>

Thanks,

	Ingo
