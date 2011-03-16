Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018Ab1CPCyU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 22:54:20 -0400
Received: from waste.org ([173.11.57.241]:41233 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655Ab1CPCyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 22:54:18 -0400
Subject: Re: [PATCH 1/8] drivers/random: Cache align ip_random better
From: Matt Mackall <mpm@selenic.com>
To: George Spelvin <linux@horizon.com>
Cc: penberg@cs.helsinki.fi, herbert@gondor.hengli.com.au, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110316022804.27679.qmail@science.horizon.com>
References: <20110316022804.27679.qmail@science.horizon.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Mar 2011 21:54:14 -0500
Message-ID: <1300244054.3128.417.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-03-13 at 20:20 -0400, George Spelvin wrote:
> Cache aligning the secret[] buffer makes copying from it infinitesimally
> more efficient.

Acked-by: Matt Mackall <mpm@selenic.com>

> ---
>  drivers/char/random.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/char/random.c b/drivers/char/random.c
> index 72a4fcb..4bcc4f2 100644
> --- a/drivers/char/random.c
> +++ b/drivers/char/random.c
> @@ -1417,8 +1417,8 @@ static __u32 twothirdsMD4Transform(__u32 const buf[4], __u32 const in[12])
>  #define HASH_MASK ((1 << HASH_BITS) - 1)
>  
>  static struct keydata {
> -	__u32 count; /* already shifted to the final position */
>  	__u32 secret[12];
> +	__u32 count; /* already shifted to the final position */
>  } ____cacheline_aligned ip_keydata[2];
>  
>  static unsigned int ip_cnt;


-- 
Mathematics is the supreme nostalgia of our time.


