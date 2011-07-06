Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523Ab1GFVWW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 17:22:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52527 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756319Ab1GFVWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 17:22:21 -0400
Date: Wed, 6 Jul 2011 14:16:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, uclinux-dev@uclinux.org,
        Davidlohr Bueso <dave@gnu.org>, stable@kernel.org
Subject: Re: [PATCH] FDPIC: Fix memory leak
Message-Id: <20110706141604.92fd4f9a.akpm@linux-foundation.org>
In-Reply-To: <20110706112604.29112.39546.stgit@warthog.procyon.org.uk>
References: <20110706112604.29112.39546.stgit@warthog.procyon.org.uk>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Jul 2011 12:26:05 +0100
David Howells <dhowells@redhat.com> wrote:

> From: Davidlohr Bueso <dave@gnu.org>
> 
> The shdr4extnum variable isn't being freed in the cleanup process of
> elf_fdpic_core_dump().
> 
> Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  fs/binfmt_elf_fdpic.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> 
> diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
> index 63039ed..2bc5dc6 100644
> --- a/fs/binfmt_elf_fdpic.c
> +++ b/fs/binfmt_elf_fdpic.c
> @@ -1864,6 +1864,7 @@ cleanup:
>  	kfree(psinfo);
>  	kfree(notes);
>  	kfree(fpu);
> +	kfree(shdr4extnum);
>  #ifdef ELF_CORE_COPY_XFPREGS
>  	kfree(xfpu);
>  #endif

So if it dumps core often enough, the machine runs out of memory and
dies.  I added a cc:stable to my copy of this one.
