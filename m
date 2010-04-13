Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527Ab0DMBai (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 21:30:38 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44128 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453Ab0DMBah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 21:30:37 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH]vmscan: handle underflow for get_scan_ratio
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Shaohua Li <shaohua.li@intel.com>,
       "Wu, Fengguang" <fengguang.wu@intel.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4BBF9B34.5040909@redhat.com>
References: <20100409142057.be0ce5af.akpm@linux-foundation.org> <4BBF9B34.5040909@redhat.com>
Message-Id: <20100413102641.4A18.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 13 Apr 2010 10:30:34 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 04/09/2010 05:20 PM, Andrew Morton wrote:
> 
> > Come to that, it's not obvious that we need this in 2.6.34 either.  What
> > is the user-visible impact here?
> 
> I suspect very little impact, especially during workloads
> where we can just reclaim clean page cache at DEF_PRIORITY.
> FWIW, the patch looks good to me, so:
> 
> Acked-by: Rik van Riel <riel@redhat.com>
> 

I'm surprised this ack a bit. Rik, do you have any improvement plan about
streaming io detection logic?
I think the patch have a slightly marginal benefit, it help to <1% scan
ratio case. but it have big regression, it cause streaming io (e.g. backup
operation) makes tons swap.

So, I thought we sould do either,
1) drop this one
2) merge to change stream io detection logic improvement at first, and
   merge this one at second.

Am i missing something?


