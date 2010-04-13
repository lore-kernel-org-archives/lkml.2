Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926Ab0DMFMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 01:12:18 -0400
Received: from gate.crashing.org ([63.228.1.57]:41462 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458Ab0DMFMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 01:12:16 -0400
Subject: Re: [PATCH 18/39] lmb: Add lmb_reserve_area_overlap_ok()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai <yinghai.lu@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <4BC3F6C8.4020303@oracle.com>
References: <1270793048-23796-1-git-send-email-yinghai@kernel.org>
	 <1270793048-23796-19-git-send-email-yinghai@kernel.org>
	 <1271132476.13059.66.camel@pasglop>  <4BC3F6C8.4020303@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Apr 2010 15:10:50 +1000
Message-ID: <1271135450.13059.72.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-12 at 21:44 -0700, Yinghai wrote:

> that is only for some special cases about area that is reserved for fw region.

And ? From what I can see in the code, it will still not work properly
unless all your special cases end up fitting right with the bug you
effectively have..

> and even there is overlapped area, it the code still can go through when lmb_to_bootmem or create range list for slab.
> because they are using range array subtract.

Well, either we just have overlapped areas or we don't ... we shouldn't
have some kind of overlap_ok() thing that does the right thing ..
sometimes, but maybe not, but we don't care anyways, which is what you
seem to be saying.

> > Besides, lmb_reserve_area_overlap_ok() sucks as a name :-)
> 
> any suggestion for better name?

Well, what you actually implemented is 

lmb_reserve_area_overlap_maybe_ok_not_too_sure_though()

What we should decide is once for all, is it ok to have lmb_reserve() be
called for overlapping ranges. I think the answer is yes and in fact, we
don't take special care in powerpc either there so overlap could happen
in theory.

Now, do we want to avoid actually creating overlapping regions in the
array ? I think we should look into it, but then we should fix
lmb_reserve() to do the right thing here and coalesce all the overlaps.

Cheers,
Ben.

> YH
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


