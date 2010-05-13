Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932918Ab0EMUZF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 16:25:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40420 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932357Ab0EMUZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 16:25:03 -0400
Date: Thu, 13 May 2010 13:24:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kirjanov@gmail.com
Cc: joern@logfs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] lib/btree: Kill unused MAX macro
Message-Id: <20100513132434.3b1515fa.akpm@linux-foundation.org>
In-Reply-To: <20100512211724.GA5507@coldcone>
References: <20100512211724.GA5507@coldcone>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 May 2010 01:17:24 +0400
"Denis Kirjanov <kirjanov@gmail.com" <kirjanov@gmail.com> wrote:

> Kill unused MAX macro
> 
> Signed-off-by: Denis Kirjanov <kirjanov@gmail.com>
> ---
> diff --git a/lib/btree.c b/lib/btree.c
> index 41859a8..f833949 100644
> --- a/lib/btree.c
> +++ b/lib/btree.c
> @@ -45,7 +45,6 @@
>  #include <linux/slab.h>
>  #include <linux/module.h>
>  
> -#define MAX(a, b) ((a) > (b) ? (a) : (b))

It's used on the very next line:

>  #define NODESIZE MAX(L1_CACHE_BYTES, 128)

And we cannot use max() here because it's evaluated at compile-time.


Also, this reader is quite unable to determine why this forumation for
NODESIZE was chosen.  As few kernel programmers can read Joern's mind,
I'd suggest that a code comment is in order.

