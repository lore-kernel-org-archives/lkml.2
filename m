Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700Ab1DTWPZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 18:15:25 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59062 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755639Ab1DTWPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 18:15:23 -0400
Subject: Re: [PATCH v3] mm: make expand_downwards symmetrical to
 expand_upwards
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>,
        Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, linux-parisc@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>
In-Reply-To: <alpine.DEB.2.00.1104201410350.31768@chino.kir.corp.google.com>
References: <20110420161615.462D.A69D9226@jp.fujitsu.com>
	 <BANLkTimfpY3gq8oY6bPDajBW7JN6Hp+A0A@mail.gmail.com>
	 <20110420174027.4631.A69D9226@jp.fujitsu.com>
	 <1303317178.2587.30.camel@mulgrave.site>
	 <alpine.DEB.2.00.1104201410350.31768@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Apr 2011 17:15:18 -0500
Message-ID: <1303337718.2587.51.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-20 at 14:18 -0700, David Rientjes wrote:
> This is probably because the parisc's DISCONTIGMEM memory ranges don't 
> have bits set in N_NORMAL_MEMORY.
> 
> diff --git a/arch/parisc/mm/init.c b/arch/parisc/mm/init.c
> --- a/arch/parisc/mm/init.c
> +++ b/arch/parisc/mm/init.c
> @@ -266,8 +266,10 @@ static void __init setup_bootmem(void)
>  	}
>  	memset(pfnnid_map, 0xff, sizeof(pfnnid_map));
>  
> -	for (i = 0; i < npmem_ranges; i++)
> +	for (i = 0; i < npmem_ranges; i++) {
> +		node_set_state(i, N_NORMAL_MEMORY);
>  		node_set_online(i);
> +	}
>  #endif

Yes, this seems to be the missing piece that gets it to boot.  We really
need this in generic code, unless someone wants to run through all the
other arch's doing it ...

James


