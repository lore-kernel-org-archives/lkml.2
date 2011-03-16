Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983Ab1CPRRm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 13:17:42 -0400
Received: from smtp-out.google.com ([216.239.44.51]:26285 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688Ab1CPRRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 13:17:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=t1SauZGM3HM0BN4sYnstRAunh9ng91rqN8HwRalfPCmnt86OjIV8FbN3GNBCvDzzrK
         LYLqDIl6YcnIo+Pt1i4g==
Date: Wed, 16 Mar 2011 10:17:19 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: George Spelvin <linux@horizon.com>
cc: penberg@cs.helsinki.fi, herbert@gondor.hengli.com.au, mpm@selenic.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] drivers/random: Cache align ip_random better
In-Reply-To: <20110316022804.27679.qmail@science.horizon.com>
Message-ID: <alpine.LSU.2.00.1103161011370.13407@sister.anvils>
References: <20110316022804.27679.qmail@science.horizon.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Mar 2011, George Spelvin wrote:

> Cache aligning the secret[] buffer makes copying from it infinitesimally
> more efficient.
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

I'm intrigued: please educate me.  On what architectures does cache-
aligning a 48-byte buffer (previously offset by 4 bytes) speed up
copying from it, and why?  Does the copying involve 8-byte or 16-byte
instructions that benefit from that alignment, rather than cacheline
alignment?
 
Thanks,
Hugh
