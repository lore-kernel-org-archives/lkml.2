Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653Ab0IASf5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 14:35:57 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45464 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966Ab0IASfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 14:35:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=UKKTADlSuQsU8LnQVPrvbr5gR/8sSYpZ9LakG0CSnKSZIoh+fqNHzK62sD/zJ26L5n
         KzaDDMaTmh5P5MNUWhqAYPY2kR5EFoCE37qieaeVY/eEGEybKInMW/WSNNOD+KiZEKcq
         ic8HFqZbhLXQiLZtNkcaMlwCDIZzlZeLc+2dY=
Subject: Re: [RFC] jffs2: use cond_resched() instead of yield()
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Ingo Molnar <mingo@elte.hu>, dwmw2@infradead.org
In-Reply-To: <1283357021-16187-1-git-send-email-w.sang@pengutronix.de>
References: <1283357021-16187-1-git-send-email-w.sang@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Sep 2010 21:35:51 +0300
Message-ID: <1283366151.2209.21.camel@brekeke>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This 'yield()' was introduced by dwmw2, so he may have strong feelings
about it. CCed.

On Wed, 2010-09-01 at 18:03 +0200, Wolfram Sang wrote:
> yield() has different semantics meanwhile and even causes RT-kernels to
> BUG. Replace the only appearance left in jffs2.
> 
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
> 
> The aforementioned BUG() showed up in one of our customer's RT-projects. While
> this could be handled by rearranging his thread-priorities, I wondered if such
> a patch would be worthwhile, still. Reading through the material covering
> yield() and related replacements, I believe this patch should be appropriate.
> Please say if I missed some side-effects.
> 
>  fs/jffs2/erase.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/jffs2/erase.c b/fs/jffs2/erase.c
> index abac961..e513f19 100644
> --- a/fs/jffs2/erase.c
> +++ b/fs/jffs2/erase.c
> @@ -151,7 +151,7 @@ int jffs2_erase_pending_blocks(struct jffs2_sb_info *c, int count)
>  		}
>  
>  		/* Be nice */
> -		yield();
> +		cond_resched();
>  		mutex_lock(&c->erase_free_sem);
>  		spin_lock(&c->erase_completion_lock);
>  	}

-- 
Best Regards,
Artem Bityutskiy (Битюцкий Артём)

