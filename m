Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161704Ab1FAMjX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 08:39:23 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:55102 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161441Ab1FAMjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 08:39:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=hxcUCoiMO5LyHn4O4nsl+/BwDgn0J3SqNgk2oeD0Jmpwcl44afRnnyGn8us5zCUeHO
         uQZGGYAGyXQHqPnsOCSm8Lic7HeeR7/9uh1aCE9OPT9EOpUD64kRENxqNAMLFinDvIzr
         Ff8cryjY9gWhlyAOstuoCDaff342F5yuUHGeA=
MIME-Version: 1.0
In-Reply-To: <1306922672-9012-1-git-send-email-dbaryshkov@gmail.com>
References: <1306922672-9012-1-git-send-email-dbaryshkov@gmail.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Wed, 1 Jun 2011 21:38:59 +0900
X-Google-Sender-Auth: XkGLfhSrlr1I35K65RX42qMuUYw
Message-ID: <BANLkTinBkdVd90g3-uiQP41z1S1sXUdRmQ@mail.gmail.com>
Subject: Re: [PATCH] Make GFP_DMA allocations w/o ZONE_DMA emit a warning
 instead of failing
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        David Rientjes <rientjes@google.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/1 Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>:
> Please be more polite to other people. After a197b59ae6 all allocations
> with GFP_DMA set on nodes without ZONE_DMA fail nearly silently (only
> one warning during bootup is emited, no matter how many things fail).
> This is a very crude change on behaviour. To be more civil, instead of
> failing emit noisy warnings each time smbd. tries to allocate a GFP_DMA
> memory on non-ZONE_DMA node.
>
> This change should be reverted after one or two major releases, but
> we should be more accurate rather than hoping for the best.
>
> Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>

Instaed of, shouldn't we revert a197b59ae6? Some arch don't have
DMA_ZONE at all.
and a197b59ae6 only care x86 embedded case. If we accept your patch, I
can imagine
other people will claim warn foold is a bug. ;)

However, I think, you should explain which platform and drivers hit
this breakage.
Otherwise developers can't learn which platform should care.

Thanks.
