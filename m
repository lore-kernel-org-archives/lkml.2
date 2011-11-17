Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997Ab1KQUDP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 15:03:15 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:39605 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754162Ab1KQUDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 15:03:14 -0500
Message-ID: <1321560192.11312.2.camel@Joe-Laptop>
Subject: Re: [PATCH] Fix comparison using wrong pointer variable in dma
 debug code
From: Joe Perches <joe@perches.com>
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org
Date: Thu, 17 Nov 2011 12:03:12 -0800
In-Reply-To: <4EC560F6.9050906@intra2net.com>
References: <4EC560F6.9050906@intra2net.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-17 at 20:31 +0100, Thomas Jarosch wrote:
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

Perhaps more sensible without the unnecessary ?:

	return a->dev_addr == b->dev_addr && a->dev == b->dev;

