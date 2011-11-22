Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522Ab1KVAGh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 19:06:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43780 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267Ab1KVAGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 19:06:36 -0500
Date: Mon, 21 Nov 2011 16:06:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, torvalds@linux-foundation.org
Subject: Re: [PATCH] Fixed use of rounddown_pow_of_two in ramoops
Message-Id: <20111121160635.e3f92b7f.akpm@linux-foundation.org>
In-Reply-To: <4EC7AFDF.6030009@gmail.com>
References: <4EC7AFDF.6030009@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Nov 2011 14:32:15 +0100
Marco Stornelli <marco.stornelli@gmail.com> wrote:

> From: Marco Stornelli <marco.stornelli@gmail.com>
> 
> The return value of rounddown_pow_of_two wasn't evaluated, so the
> operation was a no-op.
> 
> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
> ---
>  drivers/char/ramoops.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/char/ramoops.c b/drivers/char/ramoops.c
> index 7c7f42a1f8..9658116 100644
> --- a/drivers/char/ramoops.c
> +++ b/drivers/char/ramoops.c
> @@ -126,8 +126,8 @@ static int __init ramoops_probe(struct platform_device *pdev)
>                 goto fail3;
>         }
> 
> -       rounddown_pow_of_two(pdata->mem_size);
> -       rounddown_pow_of_two(pdata->record_size);
> +       pdata->mem_size = rounddown_pow_of_two(pdata->mem_size);
> +       pdata->record_size = rounddown_pow_of_two(pdata->record_size);
> 
>         /* Check for the minimum memory size */
>         if (pdata->mem_size < MIN_MEM_SIZE &&

waah.

Reported-by: Andrew Morton <akpm@linux-foundation.org>

There goes my chance to get my name in the kernel tree :(
