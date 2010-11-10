Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700Ab0KJVJL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 16:09:11 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43162 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755918Ab0KJVJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 16:09:10 -0500
Date: Wed, 10 Nov 2010 13:08:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Vasiliy Kulikov <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org,
        =?ISO-8859-1?Q?Andr=E9?= Goddard Rosa <andre.goddard@gmail.com>,
        Joe Perches <joe@perches.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib: vsprintf: fix invalid arg check
Message-Id: <20101110130834.02496b48.akpm@linux-foundation.org>
In-Reply-To: <1289421490-23950-1-git-send-email-segooon@gmail.com>
References: <1289421490-23950-1-git-send-email-segooon@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Nov 2010 23:38:08 +0300
Vasiliy Kulikov <segooon@gmail.com> wrote:

> "size" is size_t.  If we want to check whether it was underflowed
> then we should cast it to ssize_t instead of int.  When
> sizeof(size_t) > sizeof(int) the code sees UINT_MAX as underflow,
> but it is not.
> 

Does this patch fix any actual observed problem?

>  Compile tested.
> 

I guess not.

> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -1290,7 +1290,7 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
>  
>  	/* Reject out-of-range values early.  Large positive sizes are
>  	   used for unknown buffer sizes. */

Thousands of people would find that comment to be utterly mysterious. 
I am one.

> -	if (WARN_ON_ONCE((int) size < 0))
> +	if (WARN_ON_ONCE((ssize_t) size < 0))
>  		return 0;
>  
>  	str = buf;

