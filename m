Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab1KQUCd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 15:02:33 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49219 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755590Ab1KQUCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 15:02:32 -0500
Date: Thu, 17 Nov 2011 15:01:36 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix comparison using wrong pointer variable in dma debug
 code
Message-ID: <20111117200136.GC26847@hmsreliant.think-freely.org>
References: <4EC560F6.9050906@intra2net.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EC560F6.9050906@intra2net.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.6 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 17, 2011 at 08:31:02PM +0100, Thomas Jarosch wrote:
> cppcheck reported:
> [lib/dma-debug.c:248] -> [lib/dma-debug.c:248]: (style) Same expression on both sides of '=='.
> 
> Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
> ---
>  lib/dma-debug.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/lib/dma-debug.c b/lib/dma-debug.c
> index 74c6c7f..fea790a 100644
> --- a/lib/dma-debug.c
> +++ b/lib/dma-debug.c
> @@ -245,7 +245,7 @@ static void put_hash_bucket(struct hash_bucket *bucket,
>  
>  static bool exact_match(struct dma_debug_entry *a, struct dma_debug_entry *b)
>  {
> -	return ((a->dev_addr == a->dev_addr) &&
> +	return ((a->dev_addr == b->dev_addr) &&
>  		(a->dev == b->dev)) ? true : false;
>  }
>  
> -- 
> 1.7.6.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
Thanks for the catch!  Viro just pointed out you can also remove the ?
true/false changes and extraneous parens, reducing it to:

(a->dev_addr == b->dev_addr) && (a->dev == b->dev)
But its not strictly necessecary

Acked-by: Neil Horman <nhorman@tuxdriver.com>

