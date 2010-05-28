Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab0E1GpF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 02:45:05 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:55975 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753640Ab0E1GpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 02:45:01 -0400
Message-ID: <4BFF671D.4000509@snapgear.com>
Date: Fri, 28 May 2010 16:47:57 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>
CC: uclinux-dev@uclinux.org, David Howells <dhowells@redhat.com>,
       David McCullough <davidm@snapgear.com>, Greg Ungerer <gerg@uclinux.org>,
       Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FLAT: fix unmap len in load error path
References: <1274863421-14052-1-git-send-email-vapier@gentoo.org>
In-Reply-To: <1274863421-14052-1-git-send-email-vapier@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:
> The data chunk is mmaped with 'len' which remains unchanged, so use that
> when unmapping in the error path rather than trying to recalculate (and
> incorrectly so) the value used originally.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Acked-by: Greg Ungerer <gerg@uclinux.org>


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


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
