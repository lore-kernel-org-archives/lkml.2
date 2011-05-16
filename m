Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755784Ab1EPUeL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 16:34:11 -0400
Received: from smtp-out.google.com ([74.125.121.67]:17539 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755575Ab1EPUeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 16:34:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=xRT4eIUwPWG55UzjgT6RgkU4hVM2jq23ZkOBwogA7snea/wK6MPVmhGCuPhbFKULPS
         tgRiRKy5ZUnNQklYUtfA==
Date: Mon, 16 May 2011 13:34:03 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: linux-kernel@vger.kernel.org
cc: mm-commits@vger.kernel.org, dkiper@net-space.pl, dave@linux.vnet.ibm.com
Subject: Re: + mm-remove-dependency-on-config_flatmem-from-online_page.patch
 added to -mm tree
In-Reply-To: <201105032335.p43NZqv0017520@imap1.linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1105161332420.4353@chino.kir.corp.google.com>
References: <201105032335.p43NZqv0017520@imap1.linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 May 2011, akpm@linux-foundation.org wrote:

> 
> The patch titled
>      mm: remove dependency on CONFIG_FLATMEM from online_page()
> has been added to the -mm tree.  Its filename is
>      mm-remove-dependency-on-config_flatmem-from-online_page.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
> out what to do about this
> 
> The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
> 
> ------------------------------------------------------
> Subject: mm: remove dependency on CONFIG_FLATMEM from online_page()
> From: Daniel Kiper <dkiper@net-space.pl>
> 
> Memory hotplug code strictly depends on CONFIG_SPARSEMEM.  It means that
> code depending on CONFIG_FLATMEM in online_page() is never compiled. 
> Remove it because it is not needed anymore.
> 

The changelog should read:

	online_pages() is only compiled for CONFIG_MEMORY_HOTPLUG_SPARSE,
	so there is no need to support CONFIG_FLATMEM code within it.

	This patch removes code that is never used.

since this code is dependant on CONFIG_MEMORY_HOTPLUG_SPARSE, not 
CONFIG_SPARSEMEM.

After that:

Acked-by: David Rientjes <rientjes@google.com>

> Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
> Acked-by: Dave Hansen <dave@linux.vnet.ibm.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/memory_hotplug.c |    4 ----
>  1 file changed, 4 deletions(-)
> 
> diff -puN mm/memory_hotplug.c~mm-remove-dependency-on-config_flatmem-from-online_page mm/memory_hotplug.c
> --- a/mm/memory_hotplug.c~mm-remove-dependency-on-config_flatmem-from-online_page
> +++ a/mm/memory_hotplug.c
> @@ -374,10 +374,6 @@ void online_page(struct page *page)
>  		totalhigh_pages++;
>  #endif
>  
> -#ifdef CONFIG_FLATMEM
> -	max_mapnr = max(pfn, max_mapnr);
> -#endif
> -
>  	ClearPageReserved(page);
>  	init_page_count(page);
>  	__free_page(page);
