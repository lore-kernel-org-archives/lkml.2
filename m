Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278Ab0LFDFI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 22:05:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468Ab0LFDFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 22:05:06 -0500
Message-ID: <4CFC52D7.8040003@redhat.com>
Date: Sun, 05 Dec 2010 22:04:55 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH v4 3/7] move memcg reclaimable page into tail of inactive
 list
References: <cover.1291568905.git.minchan.kim@gmail.com> <a11d438e09af9808ac0cb0aba3e74c8a8deb4076.1291568905.git.minchan.kim@gmail.com>
In-Reply-To: <a11d438e09af9808ac0cb0aba3e74c8a8deb4076.1291568905.git.minchan.kim@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2010 12:29 PM, Minchan Kim wrote:
> Golbal page reclaim moves reclaimalbe pages into inactive list
> to reclaim asap. This patch apply the rule in memcg.
> It can help to prevent unnecessary working page eviction of memcg.

The patch is right, but the description is wrong.

The rotate_reclaimable_page function moves just written out
pages, which the VM wanted to reclaim, to the end of the
inactive list.  That way the VM will find those pages first
next time it needs to free memory.

> Cc: Balbir Singh<balbir@linux.vnet.ibm.com>
> Cc: KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Rik van Riel<riel@redhat.com>
> Cc: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
> Signed-off-by: Minchan Kim<minchan.kim@gmail.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
