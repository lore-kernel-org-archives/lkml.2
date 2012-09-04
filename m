Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302Ab2IDAoT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 20:44:19 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53875 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176Ab2IDAoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 20:44:18 -0400
Message-ID: <50454EDC.7050101@gmail.com>
Date: Tue, 04 Sep 2012 10:44:12 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: yan <clouds.yan@gmail.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] proc: use kzalloc instead of kmalloc and memset
References: <1346681648-21427-1-git-send-email-clouds.yan@gmail.com> <1346681648-21427-4-git-send-email-clouds.yan@gmail.com>
In-Reply-To: <1346681648-21427-4-git-send-email-clouds.yan@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/12 00:14, yan wrote:
> Signed-off-by: yan <clouds.yan@gmail.com>
> ---
>  fs/proc/generic.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/proc/generic.c b/fs/proc/generic.c
> index 9e8f631..38de015 100644
> --- a/fs/proc/generic.c
> +++ b/fs/proc/generic.c
> @@ -616,10 +616,9 @@ static struct proc_dir_entry *__proc_create(struct proc_dir_entry **parent,
>  
>  	len = strlen(fn);
>  
> -	ent = kmalloc(sizeof(struct proc_dir_entry) + len + 1, GFP_KERNEL);
> +	ent = kzalloc(sizeof(struct proc_dir_entry) + len + 1, GFP_KERNEL);
>  	if (!ent) goto out;
>  
> -	memset(ent, 0, sizeof(struct proc_dir_entry));
>  	memcpy(ent->name, fn, len + 1);
>  	ent->namelen = len;
>  	ent->mode = mode;

Note that this change results in slightly different behaviour. Before
your change only sizeof(struct proc_dir_entry) is zero'ed by memset, and
then the name is filled in (the len + 1 part). After your change the
structure and the name field are both zeroed, so the name field is being
written to twice. The cost is probably negligible though.

~Ryan


