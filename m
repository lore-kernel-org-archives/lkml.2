Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846Ab2KUFH7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 00:07:59 -0500
Received: from mail-gh0-f179.google.com ([209.85.160.179]:63979 "EHLO
	mail-gh0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536Ab2KUFHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 00:07:42 -0500
Date: Tue, 20 Nov 2012 21:07:39 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mm: trace filemap add and del
In-Reply-To: <1352404450-30100-1-git-send-email-robert.jarzmik@free.fr>
Message-ID: <alpine.LNX.2.00.1211202103460.16323@eggly.anvils>
References: <1352404450-30100-1-git-send-email-robert.jarzmik@free.fr>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Nov 2012, Robert Jarzmik wrote:
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -467,6 +471,7 @@ int add_to_page_cache_locked(struct page *page, struct address_space *mapping,
>  		} else {
>  			page->mapping = NULL;
>  			/* Leave page->index set: truncation relies upon it */
> +			trace_mm_filemap_add_to_page_cache(page);
>  			spin_unlock_irq(&mapping->tree_lock);
>  			mem_cgroup_uncharge_cache_page(page);
>  			page_cache_release(page);

I doubt if you really want your tracepoint sited just in this error path.

Hugh
