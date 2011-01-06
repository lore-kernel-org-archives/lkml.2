Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab1AFXss (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 18:48:48 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54081 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751625Ab1AFXsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 18:48:46 -0500
Date: Thu, 6 Jan 2011 15:47:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH] sched: fix strncmp operation
Message-Id: <20110106154757.75fb6b2a.akpm@linux-foundation.org>
In-Reply-To: <AANLkTinOPuYsVovrZpbuCCmG5deEyc8WgA_A1RJx_YK7@mail.gmail.com>
References: <AANLkTinOPuYsVovrZpbuCCmG5deEyc8WgA_A1RJx_YK7@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Jan 2011 20:58:12 +0800
Hillf Danton <dhillf@gmail.com> wrote:

> One of the operands, buf, is incorrect, since it is stripped and the
> correct address for subsequent string comparing could change if
> leading white spaces, if any, are removed from buf.
> 
> It is fixed by replacing buf with cmp.
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
> 
> --- a/kernel/sched.c	2010-11-01 19:54:12.000000000 +0800
> +++ b/kernel/sched.c	2011-01-06 20:52:02.000000000 +0800
> @@ -751,7 +751,7 @@ sched_feat_write(struct file *filp, cons
>  	buf[cnt] = 0;
>  	cmp = strstrip(buf);
> 
> -	if (strncmp(buf, "NO_", 3) == 0) {
> +	if (strncmp(cmp, "NO_", 3) == 0) {
>  		neg = 1;
>  		cmp += 3;
>  	}

Just remove the strstrip(), I'd say.  The kernel practically never
strips leading whitespace from sysfs input, so why do it here? 


