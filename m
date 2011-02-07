Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750931Ab1BGFAg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 00:00:36 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47221 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab1BGFAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 00:00:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=QWv5zg8k+NW3Nn3DK/zCcgy2KeXPM7kRM0qSW20jACYbPwdMKTMcJoaS4Z0eakrLEA
         v2/oJ5VKeO3AOxdQsnIMEPYBu4ebreZOUl2fMPs0NXRBiN45BkRpOcml+rUTlj2/KC+g
         6HHZ14TnWqUYBpVmNaZXjUetmKFK+mDIhXPNg=
Subject: Re: [PATCH] memblock: Fix error path in memblock_add_region()
From: Namhyung Kim <namhyung@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
In-Reply-To: <4D4EDE69.9060200@kernel.org>
References: <1296999075-8022-1-git-send-email-namhyung@gmail.com>
	 <4D4EDE69.9060200@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Feb 2011 14:00:27 +0900
Message-ID: <1297054827.1444.2.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011-02-06 (일), 09:46 -0800, Yinghai Lu:
> we can skip the restoring.
> 
> Thanks
> 
> Yinghai
> 
> diff --git a/mm/memblock.c b/mm/memblock.c
> index bdba245..3231657 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -374,13 +374,9 @@ static long __init_memblock memblock_add_region(struct memblock_type *type, phys
>  	}
>  	type->cnt++;
>  
> -	/* The array is full ? Try to resize it. If that fails, we undo
> -	 * our allocation and return an error
> -	 */
> -	if (type->cnt == type->max && memblock_double_array(type)) {
> -		type->cnt--;
> +	/* The array is full ? Try to resize it  */
> +	if (type->cnt == type->max && memblock_double_array(type))
>  		return -1;
> -	}
>  
>  	return 0;
>  }

Looks OK to me, too.
Thanks.


-- 
Regards,
Namhyung Kim


