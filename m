Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab2BCQTW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 11:19:22 -0500
Received: from mail.windriver.com ([147.11.1.11]:49988 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466Ab2BCQTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 11:19:21 -0500
Message-ID: <4F2C088E.3090106@windriver.com>
Date: Fri, 3 Feb 2012 11:17:18 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111109 Thunderbird/3.1.16
MIME-Version: 1.0
To: Cong Wang <xiyou.wangcong@gmail.com>
CC: <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Ram Pai <linuxram@us.ibm.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>, <trivial@kernel.org>
Subject: Re: [Patch] resource: move EXPORT_SYMBOL right after definition
References: <1328276573-15265-1-git-send-email-xiyou.wangcong@gmail.com>
In-Reply-To: <1328276573-15265-1-git-send-email-xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-02-03 08:42 AM, Cong Wang wrote:
> EXPORT_SYMBOL(adjust_resource) should be right after adjust_resource().

Presumably this is to get rid of a checkpatch warning?
Maybe it makes sense to have it go via the trivial tree?

TRIVIAL PATCHES
M:      Jiri Kosina <trivial@kernel.org>
T:      git git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial.git

Paul.

> 
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
> 
> ---
> diff --git a/kernel/resource.c b/kernel/resource.c
> index 7640b3a..7e8ea66 100644
> --- a/kernel/resource.c
> +++ b/kernel/resource.c
> @@ -749,6 +749,7 @@ int adjust_resource(struct resource *res, resource_size_t start, resource_size_t
>  	write_unlock(&resource_lock);
>  	return result;
>  }
> +EXPORT_SYMBOL(adjust_resource);
>  
>  static void __init __reserve_region_with_split(struct resource *root,
>  		resource_size_t start, resource_size_t end,
> @@ -792,8 +793,6 @@ void __init reserve_region_with_split(struct resource *root,
>  	write_unlock(&resource_lock);
>  }
>  
> -EXPORT_SYMBOL(adjust_resource);
> -
>  /**
>   * resource_alignment - calculate resource's alignment
>   * @res: resource pointer
