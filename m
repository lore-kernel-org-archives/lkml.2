Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759Ab1DNVjz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 17:39:55 -0400
Received: from www.sr71.net ([198.145.64.142]:49968 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673Ab1DNVjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 17:39:54 -0400
Subject: Re: BUILD_BUG_ON() breaks sparse gfp_t checks
From: Dave Hansen <dave@sr71.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Jan Beulich <JBeulich@novell.com>,
        Christoph Lameter <cl@linux.com>, linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20110414132220.970cfb2a.akpm@linux-foundation.org>
References: <1302795695.14658.6801.camel@nimitz>
	 <20110414132220.970cfb2a.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 14 Apr 2011 14:39:51 -0700
Message-ID: <1302817191.16562.1036.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-14 at 13:22 -0700, Andrew Morton wrote:
> The kernel calls gfp_zone() with a constant arg in very few places. 
> This?
> 
> --- a/include/linux/gfp.h~a
> +++ a/include/linux/gfp.h
> @@ -249,14 +249,9 @@ static inline enum zone_type gfp_zone(gf
>  
>         z = (GFP_ZONE_TABLE >> (bit * ZONES_SHIFT)) &
>                                          ((1 << ZONES_SHIFT) - 1);
> -
> -       if (__builtin_constant_p(bit))
> -               BUILD_BUG_ON((GFP_ZONE_BAD >> bit) & 1);
> -       else {
>  #ifdef CONFIG_DEBUG_VM
> -               BUG_ON((GFP_ZONE_BAD >> bit) & 1);
> +       BUG_ON((GFP_ZONE_BAD >> bit) & 1);
>  #endif
> -       }
>         return z;
>  } 

That definitely makes sparse happier.  I hope the folks on cc will chime
in if they wanted something special at build time.

-- Dave

