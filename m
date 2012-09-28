Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758326Ab2I1Oyh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 10:54:37 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:4603 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758188Ab2I1Oyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 10:54:36 -0400
Message-ID: <1348844071.1553.14.camel@x61.thuisdomein>
Subject: Re: [PATCH -v2] mm: frontswap: fix a wrong if condition in
 frontswap_shrink
From: Paul Bolle <pebolle@tiscali.nl>
To: zhenzhong.duan@oracle.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        levinsasha928@gmail.com, Feng Jin <joe.jin@oracle.com>,
        dan.carpenter@oracle.com
Date: Fri, 28 Sep 2012 16:54:31 +0200
In-Reply-To: <50651CF5.5030903@oracle.com>
References: <505C27FE.5080205@oracle.com>
	 <1348745730.1512.19.camel@x61.thuisdomein> <50651CF5.5030903@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Sep 2012 14:54:31.0576 (UTC) FILETIME=[2AAE5180:01CD9D89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-28 at 11:43 +0800, Zhenzhong Duan wrote:
> On 2012-09-27 19:35, Paul Bolle wrote:
> > I think setting pages_to_unuse to zero here is not needed. It is
> > initiated to zero in frontswap_shrink() and hasn't been touched since.
> > See my patch at https://lkml.org/lkml/2012/9/27/250.
> Yes, it's unneeded. But I didn't see warning as you said in above link 
> when run 'make V=1 mm/frontswap.o'.

Not even before applying your patch? Anyhow, after applying your patch
the warnings gone here too.

> >> -		return 0;
> >> +		return 1;
> >>   	}
> >>   	total_pages_to_unuse = total_pages - target_pages;
> >>   	return __frontswap_unuse_pages(total_pages_to_unuse, pages_to_unuse, type);
> >> @@ -302,7 +307,7 @@ void frontswap_shrink(unsigned long target_pages)
> >>   	spin_lock(&swap_lock);
> >>   	ret = __frontswap_shrink(target_pages,&pages_to_unuse,&type);
> >>   	spin_unlock(&swap_lock);
> >> -	if (ret == 0&&  pages_to_unuse)
> >> +	if (ret == 0)
> >>   		try_to_unuse(type, true, pages_to_unuse);
> >>   	return;
> >>   }
> >
> > Are you sure pages_to_unuse won't be zero here? I've stared quite a bit
> > at __frontswap_unuse_pages() and it's not obvious pages_to_unuse (there
> > also called unused) will never be zero when that function returns zero.
> pages_to_unuse==0 means all pages need to be unused.

Ah, now I see. I was focusing on changing the code as little as possible
and didn't realize that you actually wanted to change behavior here.
Looking at it again this change makes sense (though I hardly understand
frontswap, so I can't properly evaluate it). Anyhow, as I said, your
patch also does what I care about - silence a warning - so we might as
well forget about my patch.
 
Thanks,


Paul Bolle

