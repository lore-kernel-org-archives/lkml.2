Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465Ab0EKILj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 04:11:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52403 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753531Ab0EKILg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 04:11:36 -0400
Date: Tue, 11 May 2010 10:11:34 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Bill Pemberton <wfp5p@virginia.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/11] agp:  use NULL instead of 0 when pointer is
 needed
In-Reply-To: <1272634478-4127-3-git-send-email-wfp5p@virginia.edu>
Message-ID: <alpine.LNX.2.00.1005111011110.28092@pobox.suse.cz>
References: <1272634478-4127-1-git-send-email-wfp5p@virginia.edu> <1272634478-4127-3-git-send-email-wfp5p@virginia.edu>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Apr 2010, Bill Pemberton wrote:

> Fixes sparse warning:
> 
> drivers/char/agp/generic.c:1217:33: warning: Using plain integer as
> NULL pointer
> 
> Signed-off-by: Bill Pemberton <wfp5p@virginia.edu>
> CC: linux-kernel@vger.kernel.org
> ---
>  drivers/char/agp/generic.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/char/agp/generic.c b/drivers/char/agp/generic.c
> index fb86708..4b51982 100644
> --- a/drivers/char/agp/generic.c
> +++ b/drivers/char/agp/generic.c
> @@ -1214,7 +1214,7 @@ struct agp_memory *agp_generic_alloc_user(size_t page_count, int type)
>  		return NULL;
>  
>  	for (i = 0; i < page_count; i++)
> -		new->pages[i] = 0;
> +		new->pages[i] = NULL;
>  	new->page_count = 0;
>  	new->type = type;
>  	new->num_scratch_pages = pages;

As this patch isn't present in linux-next as of today, I have applied the 
patch to my queue.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
