Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524Ab1DUWTN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 18:19:13 -0400
Received: from smtp-out.google.com ([74.125.121.67]:45299 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304Ab1DUWTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 18:19:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=VFzAM3hHi8AFk2HoVagBi+HWV4QI2gRMOPYJzDfvC73xl13PEeFSmj20+2VC+tAFag
         rllkNmW0Z/3addU3cmyg==
Date: Thu, 21 Apr 2011 15:19:01 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: James Bottomley <James.Bottomley@hansenpartnership.com>
cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        Matthew Wilcox <matthew@wil.cx>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, linux-parisc@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
        linux-arch@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH v3] mm: make expand_downwards symmetrical to
 expand_upwards
In-Reply-To: <1303401997.4025.8.camel@mulgrave.site>
Message-ID: <alpine.DEB.2.00.1104211517150.20201@chino.kir.corp.google.com>
References: <20110420102314.4604.A69D9226@jp.fujitsu.com> <BANLkTi=mxWwLPEnB+rGg29b06xNUD0XvsA@mail.gmail.com> <20110420161615.462D.A69D9226@jp.fujitsu.com> <BANLkTimfpY3gq8oY6bPDajBW7JN6Hp+A0A@mail.gmail.com> <20110420112020.GA31296@parisc-linux.org>
 <BANLkTim+m-v-4k17HUSOYSbmNFDtJTgD6g@mail.gmail.com> <1303308938.2587.8.camel@mulgrave.site> <alpine.DEB.2.00.1104200943580.9266@router.home> <1303311779.2587.19.camel@mulgrave.site> <alpine.DEB.2.00.1104201018360.9266@router.home>
 <alpine.DEB.2.00.1104201437180.31768@chino.kir.corp.google.com> <1303401997.4025.8.camel@mulgrave.site>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Apr 2011, James Bottomley wrote:

> diff --git a/mm/slub.c b/mm/slub.c
> index 94d2a33..243bd9c 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -235,7 +235,11 @@ int slab_is_available(void)
>  
>  static inline struct kmem_cache_node *get_node(struct kmem_cache *s, int node)
>  {
> +#ifdef CONFIG_NUMA
>  	return s->node[node];
> +#else
> +	return s->node[0];
> +#endif
>  }
>  
>  /* Verify that a pointer has an address that is valid within a slab page */

Looks like parisc may have been just fine before 7340cc84141d (slub: 
reduce differences between SMP and NUMA), which was merged into 2.6.37?
