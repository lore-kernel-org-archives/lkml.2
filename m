Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402Ab1DZKvw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 06:51:52 -0400
Received: from static-87-79-237-121.netcologne.de ([87.79.237.121]:2518 "EHLO
	herc.mirbsd.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907Ab1DZKvv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 06:51:51 -0400
Date: Tue, 26 Apr 2011 10:50:13 +0000 (UTC)
From: Thorsten Glaser <tg@mirbsd.de>
X-X-Sender: tg@herc.mirbsd.org
To: Michael Schmitz <schmitzmic@googlemail.com>
cc: David Rientjes <rientjes@google.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Zippel <zippel@linux-m68k.org>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org, schwab@linux-m68k.org
Subject: Re: [patch] m68k, mm: set all online nodes in N_NORMAL_MEMORY
In-Reply-To: <4DB63349.3070808@gmail.com>
Message-ID: <Pine.BSM.4.64L.1104261049350.4851@herc.mirbsd.org>
References: <1303317178.2587.30.camel@mulgrave.site>
 <alpine.DEB.2.00.1104201410350.31768@chino.kir.corp.google.com>
 <20110421220351.9180.A69D9226@jp.fujitsu.com>
 <alpine.DEB.2.00.1104211237250.5829@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1104211500170.5741@router.home>
 <alpine.DEB.2.00.1104211411540.20201@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1104211501470.20201@chino.kir.corp.google.com>
 <4DB3840F.3060503@gmail.com> <alpine.DEB.2.00.1104251355410.31884@chino.kir.corp.google.com>
 <4DB63349.3070808@gmail.com>
X-Message-Flag: Your mailer is broken. Get an update at http://www.washington.edu/pine/getpine/pcpine.html for free.
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Schmitz dixit:

>       be done unconditionally since information about present memory has not
> yet
>       been recorded.
>                    If N_NORMAL_MEMORY is not accurate, slub may encounter
> errors since it

Hrm…

> @@ -300,6 +300,8 @@ void __init paging_init(void)
>               zones_size[ZONE_DMA] = m68k_memory[i].size >> PAGE_SHIFT;
>               free_area_init_node(i, zones_size,
>                                   m68k_memory[i].addr >> PAGE_SHIFT, NULL);
> +                if (node_present_pages(i))
> +                        node_set_state(i, N_NORMAL_MEMORY);
>       }
> }

No, this has whitespace problems (tabs are expanded to spaces).

bye,
//mirabilos
-- 
13:47⎜<tobiasu> if i were omnipotent, i would divide by zero
                all day long ;)
(thinking about http://lobacevski.tumblr.com/post/3260866481 by waga)
