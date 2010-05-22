Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942Ab0EVSN7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 14:13:59 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38513 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755432Ab0EVSN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 14:13:58 -0400
Date: Sat, 22 May 2010 20:13:52 +0200
From: Borislav Petkov <bp@alien8.de>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mm/swapfile.c: better messages for swap_info_get
Message-ID: <20100522181352.GB26778@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Cesar Eduardo Barros <cesarb@cesarb.net>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
References: <4BF81D87.6010506@cesarb.net>
 <1274551731-4534-1-git-send-email-cesarb@cesarb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1274551731-4534-1-git-send-email-cesarb@cesarb.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cesar Eduardo Barros <cesarb@cesarb.net>
Date: Sat, May 22, 2010 at 03:08:49PM -0300

> swap_info_get() is used for more than swap_free().
> 
> Use "swap_info_get:" instead of "swap_free:" in the error messages.
> 
> Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
> ---
>  mm/swapfile.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 6cd0a8f..af7d499 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -522,16 +522,16 @@ static struct swap_info_struct *swap_info_get(swp_entry_t entry)
>  	return p;
>  
>  bad_free:
> -	printk(KERN_ERR "swap_free: %s%08lx\n", Unused_offset, entry.val);
> +	printk(KERN_ERR "swap_info_get: %s%08lx\n", Unused_offset, entry.val);

Why not let the compiler do it for ya:

	printk(KERN_ERR "%s: %s%08lx\n", __func__, Unused_offset, entry.val);

?... etc.

-- 
Regards/Gruss,
    Boris.
