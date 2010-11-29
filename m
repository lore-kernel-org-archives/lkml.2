Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671Ab0K2BN2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 20:13:28 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55388 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001Ab0K2BN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 20:13:27 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Shaohua Li <shaohua.li@intel.com>
Subject: Re: Free memory never fully used, swapping
Cc: kosaki.motohiro@jp.fujitsu.com, Mel Gorman <mel@csn.ul.ie>,
        Simon Kirby <sim@hostway.ca>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>
In-Reply-To: <1290992638.12777.27.camel@sli10-conroe>
References: <20101126181604.B6E4.A69D9226@jp.fujitsu.com> <1290992638.12777.27.camel@sli10-conroe>
Message-Id: <20101129100707.82A2.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 29 Nov 2010 10:13:23 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ok let me clarify, in the for-loop of balance_pgdat() we reclaim 32
> pages one time. but we have
> if (!all_zones_ok) {
> ...
> 		if (sc.nr_reclaimed < SWAP_CLUSTER_MAX)
> 			order = sc.order = 0;
> 
> 		goto loop_again;
> 	}
> only when sc.nr_reclaimed < SWAP_CLUSTER_MAX or priority < 0, we set
> order to 0. before this, we still use high order for zone_watermark_ok()
> and it will fail and we keep doing page reclaim. So in the proposed
> patch by you or Mel, checking the freed pages or order in kswapd() is
> later. so I suggest we check if there is enough free pages in
> balance_pgdat() and break high order allocation if yes.

Ok, got it. Thanks. But I think Mel's approach is more conservative. I don't
think a lot of order-0 pages are good sign to ignore high order shortage.

I think we should prevent overkill reclaim, but number of order-0 pages
are not related high order overkill.

My point is, many cheap device require high order GFP_ATOMIC allocation
and high order ignorerance may makes system unstabilization on laptop world.

At least, your patch need more conservative guard.


