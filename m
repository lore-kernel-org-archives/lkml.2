Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220Ab0C3KZf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 06:25:35 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:36308 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794Ab0C3KZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 06:25:34 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH]vmscan: handle underflow for get_scan_ratio
Cc: kosaki.motohiro@jp.fujitsu.com, Shaohua Li <shaohua.li@intel.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, fengguang.wu@intel.com
In-Reply-To: <28c262361003300317g6df68fc6m4385cfbe3e8a1b04@mail.gmail.com>
References: <20100330055304.GA2983@sli10-desk.sh.intel.com> <28c262361003300317g6df68fc6m4385cfbe3e8a1b04@mail.gmail.com>
Message-Id: <20100330192219.328C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 30 Mar 2010 19:25:29 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes. It made subtle change.
> But we should not depend that change.
> Current logic seems to be good and clear than old.
> I think you were lucky at that time by not-good and not-clear logic.
> 
> BTW, How about this?

Unfortunatelly, memcg need your removed code. if removed, swapping out
might happen although sc->may_swap==0 when priority==0.

Please give me little investigate time.



> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 79c8098..f0df563 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1646,11 +1646,6 @@ static void shrink_zone(int priority, struct zone *zone,
>                 int file = is_file_lru(l);
>                 unsigned long scan;
> 
> -               if (percent[file] == 0) {
> -                       nr[l] = 0;
> -                       continue;
> -               }
> -
>                 scan = zone_nr_lru_pages(zone, sc, l);
>                 if (priority) {
>                         scan >>= priority;
> 
> 
> 
> 
> -- 
> Kind regards,
> Minchan Kim
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a hrefmailto:"dont@kvack.org"> email@kvack.org </a>



