Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853Ab0IPGyx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 02:54:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45956 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331Ab0IPGyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 02:54:52 -0400
Date: Thu, 16 Sep 2010 12:24:39 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: linux-next: manual merge of the bkl-llseek tree with the rr tree
Message-ID: <20100916065438.GE2429@amit-laptop.redhat.com>
References: <20100915132646.4aef58f8.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100915132646.4aef58f8.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Wed) Sep 15 2010 [13:26:46], Stephen Rothwell wrote:
> Hi Arnd,
> 
> Today's linux-next merge of the bkl-llseek tree got a conflict in
> drivers/char/virtio_console.c between commit
> a0e1acd65fa6c2da3b039a67ac30cc3b73466c37 ("virtio: console: Send SIGIO to
> processes that request it for host events") from the rr tree and commit
> 7f09912dd2169ca9ce56c5e3428c7b4c5e92e727 ("llseek: automatically
> add .llseek fop") from the bkl-llseek tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Thanks, this looks correct.

Arnd, the device is supposed to be non-seekable so I'll add a
nonseekable_open() to the open() call.

So I guess the llseek operation should ne no_llseek instead of
noop_llseek.  Will you change that in your patchset?  Should I do that
in the patch I'll queue up?

> diff --cc drivers/char/virtio_console.c
> index f7adfd3,524907b..0000000
> --- a/drivers/char/virtio_console.c
> +++ b/drivers/char/virtio_console.c
> @@@ -824,7 -728,7 +824,8 @@@ static const struct file_operations por
>   	.write = port_fops_write,
>   	.poll  = port_fops_poll,
>   	.release = port_fops_release,
>  +	.fasync = port_fops_fasync,
> + 	.llseek = noop_llseek,/* read and write both use no f_pos */
>   };
>   
>   /*

		Amit
