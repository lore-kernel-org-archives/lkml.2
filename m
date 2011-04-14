Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758651Ab1DNCcr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 22:32:47 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49984 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756184Ab1DNCcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 22:32:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=JSrtgrm0BLroiAcR1eZN8uU1qQyTSkxGlGJLreqpg+OAfF6YxS2gz2X5HmQlUWQYUR
         i0Rtn22J3e2tJqoM0ZZZ/JEPhHwbNG2CDmHKWVubUvMWmITC+qaU4+xfA2M/NpRLHqPX
         7EUSD8bcXAG2x1MDlJDlRfEwGvsz3xV0KJCkU=
Subject: Re: [patch v3 1/3] percpu_counter: change return value and add
 comments
From: Eric Dumazet <eric.dumazet@gmail.com>
To: shaohua.li@intel.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, tj@kernel.org,
        cl@linux.com
In-Reply-To: <20110414020747.006551352@sli10-conroe.sh.intel.com>
References: <20110414020447.979946152@sli10-conroe.sh.intel.com>
	 <20110414020747.006551352@sli10-conroe.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Apr 2011 04:32:41 +0200
Message-ID: <1302748361.3549.21.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 14 avril 2011 à 10:04 +0800, shaohua.li@intel.com a écrit :
> pièce jointe document texte brut (percpu-counter-positive.patch)
> the percpu_counter_*_positive() API in UP case doesn't check if return value is
> positive. Add comments to explain why we don't.
> Also if count < 0, returns 0 instead of 1 for *read_positive().
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> 
> ---
>  include/linux/percpu_counter.h |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> Index: linux/include/linux/percpu_counter.h
> ===================================================================
> --- linux.orig/include/linux/percpu_counter.h	2011-04-13 16:09:22.000000000 +0800
> +++ linux/include/linux/percpu_counter.h	2011-04-14 08:50:45.000000000 +0800
> @@ -75,7 +75,7 @@ static inline s64 percpu_counter_read_po
>  	barrier();		/* Prevent reloads of fbc->count */
>  	if (ret >= 0)
>  		return ret;
> -	return 1;
> +	return 0;
>  }
>  
>  static inline int percpu_counter_initialized(struct percpu_counter *fbc)
> @@ -133,6 +133,10 @@ static inline s64 percpu_counter_read(st
>  	return fbc->count;
>  }
>  
> +/*
> + * percpu_counter is intended to track positive number. In UP case, the number
> + * should never be negative.
> + */
>  static inline s64 percpu_counter_read_positive(struct percpu_counter *fbc)
>  {
>  	return fbc->count;
> 


Acked-by: Eric Dumazet <eric.dumazet@gmail.com>


