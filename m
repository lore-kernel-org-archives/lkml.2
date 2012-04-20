Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438Ab2DTXDk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 19:03:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41541 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187Ab2DTXDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 19:03:39 -0400
Date: Fri, 20 Apr 2012 16:03:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Xi Wang <xi.wang@gmail.com>
Cc: linux-kernel@vger.kernel.org, Alex Elder <elder@dreamhost.com>,
        David Airlie <airlied@linux.ie>, Pekka Enberg <penberg@kernel.org>
Subject: Re: [RFC][PATCH] introduce SIZE_MAX
Message-Id: <20120420160337.479eeac0.akpm@linux-foundation.org>
In-Reply-To: <1334809671-15288-1-git-send-email-xi.wang@gmail.com>
References: <1334809671-15288-1-git-send-email-xi.wang@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2012 00:27:51 -0400
Xi Wang <xi.wang@gmail.com> wrote:

> ULONG_MAX is often used to check for integer overflow when calculating
> allocation size.  While ULONG_MAX happens to work on most systems,
> there is no guarantee that `size_t' must be the same size as `long'.
> 
> This patch introduces SIZE_MAX, the maximum value of `size_t', to
> improve portability and readability for allocation size validation.
>
> ...
>
> @@ -331,7 +331,7 @@ static int build_snap_context(struct ceph_snap_realm *realm)
>  
>  	/* alloc new snap context */
>  	err = -ENOMEM;
> -	if (num > (ULONG_MAX - sizeof(*snapc)) / sizeof(u64))
> +	if (num > (SIZE_MAX - sizeof(*snapc)) / sizeof(u64))
>  		goto fail;
>  	snapc = kzalloc(sizeof(*snapc) + num*sizeof(u64), GFP_NOFS);
>  	if (!snapc)

hm, yes, I suppose that's better - hardwiring the assumption that
size_t has type unsigned long is pretty ugly.

Will we need something for ssize_t also?
