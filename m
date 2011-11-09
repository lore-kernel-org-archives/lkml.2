Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972Ab1KIPUT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 10:20:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18674 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753974Ab1KIPUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 10:20:18 -0500
Date: Wed, 9 Nov 2011 10:20:13 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Dave Young <dyoung@redhat.com>
Cc: ebiederm@xmission.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kdump: kill redundant code
Message-ID: <20111109152012.GA12537@redhat.com>
References: <20111109070452.GA25768@darkstar.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111109070452.GA25768@darkstar.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 09, 2011 at 03:04:52PM +0800, Dave Young wrote:
> in while loop below, hole_end > crashk_res.end is impossible:
> while (hole_end <= crashk_res.end) {
> 	[snip]
> }
> Killing the check code here
> 
> Signed-off-by: Dave Young <dyoung@redhat.com>

Makes sense.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

> ---
>  kernel/kexec.c |    2 --
>  1 file changed, 2 deletions(-)
> 
> --- linux-2.6.orig/kernel/kexec.c	2011-11-01 13:06:20.000000000 +0800
> +++ linux-2.6/kernel/kexec.c	2011-11-09 14:57:17.487022644 +0800
> @@ -500,8 +500,6 @@ static struct page *kimage_alloc_crash_c
>  
>  		if (hole_end > KEXEC_CRASH_CONTROL_MEMORY_LIMIT)
>  			break;
> -		if (hole_end > crashk_res.end)
> -			break;
>  		/* See if I overlap any of the segments */
>  		for (i = 0; i < image->nr_segments; i++) {
>  			unsigned long mstart, mend;
