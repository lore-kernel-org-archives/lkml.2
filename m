Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab1ACWDk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 17:03:40 -0500
Received: from smtp-out.google.com ([74.125.121.67]:19075 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab1ACWDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 17:03:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=iWtMgMBTY32+/RGPvmIhCZqpHOSS9isi/gm51qvbgn0zmSGve24pAhUPyGxgEmH57U
         iHxTehUjSoTPHpCvhycw==
Date: Mon, 3 Jan 2011 14:03:31 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Minchan Kim <minchan.kim@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] writeback: avoid unnecessary determine_dirtyable_memory
 call
In-Reply-To: <1294072249-2916-1-git-send-email-minchan.kim@gmail.com>
Message-ID: <alpine.DEB.2.00.1101031400550.10636@chino.kir.corp.google.com>
References: <1294072249-2916-1-git-send-email-minchan.kim@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Jan 2011, Minchan Kim wrote:

> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index fc93802..c340536 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -390,9 +390,12 @@ void global_dirty_limits(unsigned long *pbackground, unsigned long *pdirty)
>  {
>  	unsigned long background;
>  	unsigned long dirty;
> -	unsigned long available_memory = determine_dirtyable_memory();
> +	unsigned long available_memory;

You need unsigned long uninitialized_var(available_memory) to avoid the 
warning.

>  	struct task_struct *tsk;
>  
> +	if (!vm_dirty_bytes || !dirty_background_bytes)
> +		available_memory = determine_dirtyable_memory();
> +
>  	if (vm_dirty_bytes)
>  		dirty = DIV_ROUND_UP(vm_dirty_bytes, PAGE_SIZE);
>  	else
