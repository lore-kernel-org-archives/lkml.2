Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783Ab2FSVSA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 17:18:00 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:49658 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108Ab2FSVR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 17:17:59 -0400
Message-ID: <4FE0EC86.706@gmail.com>
Date: Tue, 19 Jun 2012 17:17:58 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Hillf Danton <dhillf@gmail.com>
CC: Minchan Kim <minchan@kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, Nick Piggin <npiggin@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [resend][PATCH] mm, vmscan: fix do_try_to_free_pages() livelock
References: <1339661592-3915-1-git-send-email-kosaki.motohiro@gmail.com> <20120614145716.GA2097@barrios> <CAHGf_=qcA5OfuNgk0BiwyshcLftNWoPfOO_VW9H6xQTX2tAbuA@mail.gmail.com> <4FDAE3CC.60801@kernel.org> <CAJd=RBBSa2TuRDVGrY9JT9m3K68N1LWiZKyo3Y1mdQRo5TxBLQ@mail.gmail.com>
In-Reply-To: <CAJd=RBBSa2TuRDVGrY9JT9m3K68N1LWiZKyo3Y1mdQRo5TxBLQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Who left comment on unreclaimable there, and why?
> 		/*
> 		 * balance_pgdat() skips over all_unreclaimable after
> 		 * DEF_PRIORITY. Effectively, it considers them balanced so
> 		 * they must be considered balanced here as well if kswapd
> 		 * is to sleep
> 		 */

Thank you for finding this! I'll fix.



> BTW, are you still using prefetch_prev_lru_page?

No. we should kill it. ;-)

