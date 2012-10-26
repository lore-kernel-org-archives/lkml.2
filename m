Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab2JZBtG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 21:49:06 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:1971 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752997Ab2JZBtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 21:49:01 -0400
X-IronPort-AV: E=Sophos;i="4.80,651,1344182400"; 
   d="scan'208";a="6072455"
Message-ID: <5089E568.1000208@cn.fujitsu.com>
Date: Fri, 26 Oct 2012 09:20:40 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiang Liu <jiang.liu@huawei.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Mel Gorman <mgorman@suse.de>,
        FNST-Wen Congyang <wency@cn.fujitsu.com>, linux-doc@vger.kernel.org,
        linux-mm@kvack.org, Jianguo Wu <wujianguo@huawei.com>,
        Xishi Qiu <qiuxishi@huawei.com>
Subject: Re: [PATCH 1/2 V2] memory_hotplug: fix possible incorrect node_states[N_NORMAL_MEMORY]
References: <1351071840-5060-1-git-send-email-laijs@cn.fujitsu.com> <1351071840-5060-2-git-send-email-laijs@cn.fujitsu.com> <CAHGf_=rvDf56EjMv0vLsxDfHQzuSoXF6Yzx=wCCoQ+Z+3Ov+=w@mail.gmail.com>
In-Reply-To: <CAHGf_=rvDf56EjMv0vLsxDfHQzuSoXF6Yzx=wCCoQ+Z+3Ov+=w@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/26 09:17:39,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/26 09:17:45,
	Serialize complete at 2012/10/26 09:17:45
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2012 12:17 PM, KOSAKI Motohiro wrote:
> On Wed, Oct 24, 2012 at 5:43 AM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
>> Currently memory_hotplug only manages the node_states[N_HIGH_MEMORY],
>> it forgets to manage node_states[N_NORMAL_MEMORY]. it may cause
>> node_states[N_NORMAL_MEMORY] becomes incorrect.
>>
>> Example, if a node is empty before online, and we online a memory
>> which is in ZONE_NORMAL. And after online,  node_states[N_HIGH_MEMORY]
>> is correct, but node_states[N_NORMAL_MEMORY] is incorrect,
>> the online code don't set the new online node to
>> node_states[N_NORMAL_MEMORY].
>>
>> The same things like it will happen when offline(the offline code
>> don't clear the node from node_states[N_NORMAL_MEMORY] when needed).
>> Some memory managment code depends node_states[N_NORMAL_MEMORY],
>> so we have to fix up the node_states[N_NORMAL_MEMORY].
>>
>> We add node_states_check_changes_online() and node_states_check_changes_offline()
>> to detect whether node_states[N_HIGH_MEMORY] and node_states[N_NORMAL_MEMORY]
>> are changed while hotpluging.
>>
>> Also add @status_change_nid_normal to struct memory_notify, thus
>> the memory hotplug callbacks know whether the node_states[N_NORMAL_MEMORY]
>> are changed. (We can add a @flags and reuse @status_change_nid instead of
>> introducing @status_change_nid_normal, but it will add much more complicated
>> in memory hotplug callback in every subsystem. So introdcing
>> @status_change_nid_normal is better and it don't change the sematic
>> of @status_change_nid)
>>
>> Changed from V1:
>>         add more comments
>>         change the function name
> 
> Your patch didn't fix my previous comments and don't works correctly.
> Please test your own patch before resubmitting. You should consider both
> zone normal only node and zone high only node.
> 

The comments in the code already answered/explained your previous comments.

Thanks,
Lai
