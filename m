Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056Ab0J1BRu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 21:17:50 -0400
Received: from smtp-out.google.com ([216.239.44.51]:8094 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757980Ab0J1BRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 21:17:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=hawUrHX3EHrnaKLMYtlPVY/LUhuUseUdG8nrZV3mex8t4Csz5QPdW+xesQ4X/5EuXe
         rBJ5uWxmMjrElwNwxDGQ==
Date: Wed, 27 Oct 2010 18:17:39 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 1/2] mm, mem-hotplug: recalculate lowmem_reserve when
 memory hotplug occur
In-Reply-To: <20101026221017.B7DF.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1010271815430.32477@chino.kir.corp.google.com>
References: <20101026221017.B7DF.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Oct 2010, KOSAKI Motohiro wrote:

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index b48dea2..14ee899 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5002,7 +5002,7 @@ static void __init setup_per_zone_inactive_ratio(void)
>   * 8192MB:	11584k
>   * 16384MB:	16384k
>   */
> -static int __init init_per_zone_wmark_min(void)
> +int __meminit init_per_zone_wmark_min(void)
>  {
>  	unsigned long lowmem_kbytes;
>  

setup_per_zone_inactive_ratio() should be moved from __init to __meminit, 
right?
