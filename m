Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab2ITBML (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 21:12:11 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:10628 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750852Ab2ITBMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 21:12:09 -0400
X-IronPort-AV: E=Sophos;i="4.80,452,1344182400"; 
   d="scan'208";a="5873862"
Message-ID: <505A6EB7.5070305@cn.fujitsu.com>
Date: Thu, 20 Sep 2012 09:17:43 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Shaohua Li <shli@fusionio.com>
Subject: Re: [PATCH] memory-hotplug: fix zone stat mismatch
References: <1348039748-32111-1-git-send-email-minchan@kernel.org> <CAHGf_=oSSsJEeh7eN+R6P3n0vq2h5+3DPmogpXqDiu1jJyKmpg@mail.gmail.com> <20120919201738.GA2425@barrios>
In-Reply-To: <20120919201738.GA2425@barrios>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/20 09:12:20,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/20 09:12:21,
	Serialize complete at 2012/09/20 09:12:21
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 09/20/2012 04:17 AM, Minchan Kim Wrote:
> Hi KOSAKI,
> 
> On Wed, Sep 19, 2012 at 02:05:20PM -0400, KOSAKI Motohiro wrote:
>> On Wed, Sep 19, 2012 at 3:29 AM, Minchan Kim <minchan@kernel.org> wrote:
>>> During memory-hotplug stress test, I found NR_ISOLATED_[ANON|FILE]
>>> are increasing so that kernel are hang out.
>>>
>>> The cause is that when we do memory-hotadd after memory-remove,
>>> __zone_pcp_update clear out zone's ZONE_STAT_ITEMS in setup_pageset
>>> without draining vm_stat_diff of all CPU.
>>>
>>> This patch fixes it.
>>
>> zone_pcp_update() is called from online pages path. but IMHO,
>> the statistics should be drained offline path. isn't it?
> 
> It isn't necessary because statistics is right until we reset it to zero
> in online path.
> Do you have something on your mind that we have to drain it in offline path?

When a node is offlined and onlined again. We create node_data[i] in the
function hotadd_new_pgdat(), and we will lost the statistics stored in
zone->pageset. So we should drain it in offline path.

Thanks
Wen Congyang

> 
>>
>> thanks.
> 

