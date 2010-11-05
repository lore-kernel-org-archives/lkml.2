Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab0KEAbs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 20:31:48 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:29691 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab0KEAbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 20:31:47 -0400
Date: Fri, 5 Nov 2010 01:20:50 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Marcus Meissner <meissner@suse.de>
cc: linux-kernel@vger.kernel.org, jason.wessel@windriver.com,
        fweisbec@gmail.com, tj@kernel.org, mort@sgi.com, akpm@osdl.org,
        security@kernel.org
Subject: Re: [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of
 attacking
In-Reply-To: <20101104100914.GC25118@suse.de>
Message-ID: <alpine.LNX.2.00.1011050119080.16015@swampdragon.chaosbits.net>
References: <20101104100914.GC25118@suse.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Nov 2010, Marcus Meissner wrote:

> 
> Hi,
> 
> Making /proc/kallsyms readable only for root makes it harder
> for attackers to write generic kernel exploits by removing
> one source of knowledge where things are in the kernel.
> 
> Signed-off-by: Marcus Meissner <meissner@suse.de>
> ---
>  kernel/kallsyms.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
> index 6f6d091..a8db257 100644
> --- a/kernel/kallsyms.c
> +++ b/kernel/kallsyms.c
> @@ -546,7 +546,7 @@ static const struct file_operations kallsyms_operations = {
>  
>  static int __init kallsyms_init(void)
>  {
> -	proc_create("kallsyms", 0444, NULL, &kallsyms_operations);
> +	proc_create("kallsyms", 0400, NULL, &kallsyms_operations);
>  	return 0;
>  }
>  device_initcall(kallsyms_init);
> 

This doesn't harden things much, but a little is better than nothing.
This makes sense to me and looks OK.

Reviewed-by: Jesper Juhl <jj@chaosbits.net>


-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

