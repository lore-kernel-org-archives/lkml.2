Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551Ab0ICVUq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 17:20:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46168 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753962Ab0ICVUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 17:20:44 -0400
Date: Fri, 3 Sep 2010 14:20:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Sembera <jsembera@suse.cz>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        ink@jurassic.park.msu.ru, stable@kernel.org,
        linux-ia64@vger.kernel.org, "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [PATCH] binfmt_misc: Fix binfmt_misc priority
Message-Id: <20100903142003.b6f02a0c.akpm@linux-foundation.org>
In-Reply-To: <20100823141520.GB17894@alaris.suse.cz>
References: <20100823141520.GB17894@alaris.suse.cz>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(cc stable@kernel.org and the ia64 d00ds)

On Mon, 23 Aug 2010 16:15:20 +0200
Jan Sembera <jsembera@suse.cz> wrote:

> Commit 74641f584da introduced a regression - binfmt_misc is now consulted
> after binfmt_elf, which will unfortunately break ia32el. ia32 ELF binaries
> on ia64 used to be matched using binfmt_misc and executed using wrapper. As
> 32bit binaries are now matched by binfmt_elf before bindmt_misc kicks in,
> the wrapper is ignored.
> 
> The fix increases precedence of binfmt_misc to the original state.
> 
> Signed-off-by: Jan Sembera <jsembera@suse.cz>
> ---
>  fs/binfmt_misc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> index a7528b9..fd0cc0b 100644
> --- a/fs/binfmt_misc.c
> +++ b/fs/binfmt_misc.c
> @@ -724,7 +724,7 @@ static int __init init_misc_binfmt(void)
>  {
>  	int err = register_filesystem(&bm_fs_type);
>  	if (!err) {
> -		err = register_binfmt(&misc_format);
> +		err = insert_binfmt(&misc_format);
>  		if (err)
>  			unregister_filesystem(&bm_fs_type);
>  	}

Yikes, 74641f584da was merged in May 2009.  I wonder why this problem
wasn't noticed before now?

If we're going to change this then I guess we should change it in
2.6.36 and backport the fix as far as we can go.
