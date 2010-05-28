Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab0E1G0o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 02:26:44 -0400
Received: from dalsmrelay2.nai.com ([205.227.136.216]:46507 "HELO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753178Ab0E1G0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 02:26:41 -0400
Date: Fri, 28 May 2010 16:26:32 +1000
From: David McCullough <david_mccullough@mcafee.com>
To: Mike Frysinger <vapier@gentoo.org>
CC: uclinux-dev@uclinux.org, David Howells <dhowells@redhat.com>,
       Greg Ungerer <gerg@uclinux.org>, Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FLAT: fix unmap len in load error path
Message-ID: <20100528062632.GC20365@mcafee.com>
References: <1274863421-14052-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1274863421-14052-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 28 May 2010 06:26:33.0788 (UTC) FILETIME=[B7BA6FC0:01CAFE2E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Jivin Mike Frysinger lays it down ...
> The data chunk is mmaped with 'len' which remains unchanged, so use that
> when unmapping in the error path rather than trying to recalculate (and
> incorrectly so) the value used originally.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Acked-by: David McCullough <david_mccullough@mcafee.com>

Cheers,
Davidm

> ---
>  fs/binfmt_flat.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
> index 4959a0a..f7a4059 100644
> --- a/fs/binfmt_flat.c
> +++ b/fs/binfmt_flat.c
> @@ -596,7 +596,7 @@ static int load_flat_file(struct linux_binprm * bprm,
>  		if (IS_ERR_VALUE(result)) {
>  			printk("Unable to read data+bss, errno %d\n", (int)-result);
>  			do_munmap(current->mm, textpos, text_len);
> -			do_munmap(current->mm, realdatastart, data_len + extra);
> +			do_munmap(current->mm, realdatastart, len);
>  			ret = result;
>  			goto err;
>  		}
> -- 
> 1.7.1
> 
> 
> 

-- 
David McCullough,      david_mccullough@mcafee.com,  Ph:+61 734352815
McAfee - SnapGear      http://www.mcafee.com         http://www.uCdot.org
