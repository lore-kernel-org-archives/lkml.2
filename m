Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758916Ab0FVDYF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 23:24:05 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45842 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758760Ab0FVDYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 23:24:03 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [Patch] Call cond_resched() at bottom of main look in  balance_pgdat()
Cc: kosaki.motohiro@jp.fujitsu.com, Larry Woodman <lwoodman@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <AANLkTilN3EcYq400ajA2-rf3Xs4MhD-sKCg44fjzKlX1@mail.gmail.com>
References: <20100622112416.B554.A69D9226@jp.fujitsu.com> <AANLkTilN3EcYq400ajA2-rf3Xs4MhD-sKCg44fjzKlX1@mail.gmail.com>
Message-Id: <20100622114739.B563.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 22 Jun 2010 12:23:59 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> Kosaki's patch's goal is that kswap doesn't yield cpu if the zone doesn't meet its
> >> min watermark to avoid failing atomic allocation.
> >> But this patch could yield kswapd's time slice at any time.
> >> Doesn't the patch break your goal in bb3ab59683?
> >
> > No. it don't break.
> >
> > Typically, kswapd periodically call shrink_page_list() and it call
> > cond_resched() even if bb3ab59683 case.
> 
> Hmm. If it is, bb3ab59683 is effective really?
> 
> The bb3ab59683's goal is prevent CPU yield in case of free < min_watermark.
> But shrink_page_list can yield cpu from kswapd at any time.
> So I am not sure what is bb3ab59683's benefit.
> Did you have any number about bb3ab59683's effectiveness?
> (Of course, I know it's very hard. Just out of curiosity)
> 
> As a matter of fact, when I saw this Larry's patch, I thought it would
> be better to revert bb3ab59683. Then congestion_wait could yield CPU
> to other process.
> 
> What do you think about?

No. The goal is not prevent CPU yield. The goal is avoid unnecessary
_long_ sleep (i.e. congestion_wait(BLK_RW_ASYNC, HZ/10)).
Anyway we can't refuse CPU yield on UP. it lead to hangup ;)

What do you mean the number? If it mean how much reduce congestion_wait(),
it was posted a lot of time. If it mean how much reduce page allocation 
failure bug report, I think it has been observable reduced since half 
years ago. 

If you have specific worried concern, can you please share it?



