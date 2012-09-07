Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078Ab2IGAtg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 20:49:36 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:32869 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914Ab2IGAtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 20:49:35 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <50494473.8030008@jp.fujitsu.com>
Date: Fri, 07 Sep 2012 09:48:51 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Xishi Qiu <qiuxishi@huawei.com>, Wen Congyang <wency@cn.fujitsu.com>
Subject: Re: [PATCH v3 4/4] memory-hotplug: fix pages missed by race rather
 than failng
References: <1346978372-17903-1-git-send-email-minchan@kernel.org> <1346978372-17903-5-git-send-email-minchan@kernel.org>
In-Reply-To: <1346978372-17903-5-git-send-email-minchan@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/09/07 9:39), Minchan Kim wrote:
> If race between allocation and isolation in memory-hotplug offline
> happens, some pages could be in MIGRATE_MOVABLE of free_list although
> the pageblock's migratetype of the page is MIGRATE_ISOLATE.
> 
> The race could be detected by get_freepage_migratetype
> in __test_page_isolated_in_pageblock. If it is detected, now EBUSY
> gets bubbled all the way up and the hotplug operations fails.
> 
> But better idea is instead of returning and failing memory-hotremove,
> move the free page to the correct list at the time it is detected.
> It could enhance memory-hotremove operation success ratio although
> the race is really rare.
> 
> Suggested-by: Mel Gorman <mgorman@suse.de>
> Signed-off-by: Minchan Kim <minchan@kernel.org>

Sounds reasonable. Thank you very much !

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


