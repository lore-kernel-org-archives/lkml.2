Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab2KBGWV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 02:22:21 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:32273 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752343Ab2KBGWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 02:22:18 -0400
X-IronPort-AV: E=Sophos;i="4.80,697,1344182400"; 
   d="scan'208";a="6122863"
Message-ID: <509367F5.9060801@cn.fujitsu.com>
Date: Fri, 02 Nov 2012 14:28:05 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-doc@vger.kernel.org, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jiang Liu <jiang.liu@huawei.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mgorman@suse.de>,
        Yinghai Lu <yinghai@kernel.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>
Subject: Re: [PART6 Patch] mempolicy: fix is_valid_nodemask()
References: <1351675458-11859-1-git-send-email-wency@cn.fujitsu.com> <1351675458-11859-2-git-send-email-wency@cn.fujitsu.com> <alpine.DEB.2.00.1210311119000.8809@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1210311119000.8809@chino.kir.corp.google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/02 14:21:28,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/02 14:21:29,
	Serialize complete at 2012/11/02 14:21:29
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 11/01/2012 02:21 AM, David Rientjes Wrote:
> On Wed, 31 Oct 2012, Wen Congyang wrote:
> 
>> From: Lai Jiangshan <laijs@cn.fujitsu.com>
>>
>> is_valid_nodemask() is introduced by 19770b32. but it does not match
>> its comments, because it does not check the zone which > policy_zone.
>>
>> Also in b377fd, this commits told us, if highest zone is ZONE_MOVABLE,
>> we should also apply memory policies to it. so ZONE_MOVABLE should be valid zone
>> for policies. is_valid_nodemask() need to be changed to match it.
>>
>> Fix: check all zones, even its zoneid > policy_zone.
>> Use nodes_intersects() instead open code to check it.
>>
> 
> This changes the semantics of MPOL_BIND to be considerably different than 
> what it is today: slab allocations are no longer bound by such a policy 
> which isn't consistent with what userspace expects or is specified by 
> set_mempolicy() and there's no way, with your patch, to actually specify 
> that we don't care about ZONE_MOVABLE and that the slab allocations 
> _should_ actually be allocated on movable-only zones.  You have to respect 
> cases where people aren't interested in node hotplug and not cause a 
> regression.
> 

Should we allow the user to bind a task to a node which has only ZONE_MOVABLE memory?

Thanks
Wen Congyang
