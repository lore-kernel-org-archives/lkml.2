Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377Ab1DYU4z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:56:55 -0400
Received: from smtp-out.google.com ([74.125.121.67]:6787 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757316Ab1DYU4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:56:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=jzOrPWrg5L5kLDJNr3AdlHKSQRLGWfSx4GSnJ8zGzHjLgxGE0lfJLIBVD7qZcR0myz
         mxj7v00yLANUTiym0aVg==
Date: Mon, 25 Apr 2011 13:56:38 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michael Schmitz <schmitzmic@googlemail.com>
cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Zippel <zippel@linux-m68k.org>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org, schwab@linux-m68k.org,
        "tg@mirbsd.de >> Thorsten Glaser" <tg@mirbsd.de>
Subject: Re: [patch] m68k, mm: set all online nodes in N_NORMAL_MEMORY
In-Reply-To: <4DB3840F.3060503@gmail.com>
Message-ID: <alpine.DEB.2.00.1104251355410.31884@chino.kir.corp.google.com>
References: <1303317178.2587.30.camel@mulgrave.site> <alpine.DEB.2.00.1104201410350.31768@chino.kir.corp.google.com> <20110421220351.9180.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1104211237250.5829@chino.kir.corp.google.com> <alpine.DEB.2.00.1104211500170.5741@router.home>
 <alpine.DEB.2.00.1104211411540.20201@chino.kir.corp.google.com> <alpine.DEB.2.00.1104211501470.20201@chino.kir.corp.google.com> <4DB3840F.3060503@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Apr 2011, Michael Schmitz wrote:

> diff --git a/arch/m68k/mm/motorola.c b/arch/m68k/mm/motorola.c
> index 02b7a03..b806c19 100644
> --- a/arch/m68k/mm/motorola.c
> +++ b/arch/m68k/mm/motorola.c
> @@ -300,6 +300,8 @@ void __init paging_init(void)
>                zones_size[ZONE_DMA] = m68k_memory[i].size >> PAGE_SHIFT;
>                free_area_init_node(i, zones_size,
>                                    m68k_memory[i].addr >> PAGE_SHIFT, NULL);
> +                if (node_present_pages(i))
> +                        node_set_state(i, N_NORMAL_MEMORY);
>        }
> }
> 

Ok, would you like to write a changelog for this similar to mine and then 
propose it as an alternative?

Thanks!
