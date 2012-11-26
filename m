Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab2KZBtz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 20:49:55 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:28160 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753890Ab2KZBty convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 20:49:54 -0500
X-IronPort-AV: E=Sophos;i="4.83,317,1352044800"; 
   d="scan'208";a="6272104"
Message-ID: <50B2C38A.7010201@cn.fujitsu.com>
Date: Mon, 26 Nov 2012 09:19:06 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jiang Liu <jiang.liu@huawei.com>
CC: hpa@zytor.com, akpm@linux-foundation.org, rob@landley.net,
        isimatu.yasuaki@jp.fujitsu.com, laijs@cn.fujitsu.com,
        wency@cn.fujitsu.com, linfeng@cn.fujitsu.com, yinghai@kernel.org,
        kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, mgorman@suse.de,
        rientjes@google.com, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 1/5] x86: get pg_data_t's memory from other node
References: <1353667445-7593-1-git-send-email-tangchen@cn.fujitsu.com> <1353667445-7593-2-git-send-email-tangchen@cn.fujitsu.com> <50B020A4.9060801@huawei.com>
In-Reply-To: <50B020A4.9060801@huawei.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/26 09:19:45,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/26 09:19:53
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2012 09:19 AM, Jiang Liu wrote:
> On 2012-11-23 18:44, Tang Chen wrote:
>> From: Yasuaki Ishimatsu<isimatu.yasuaki@jp.fujitsu.com>
>> @@ -224,9 +224,14 @@ static void __init setup_node_data(int nid, u64 start, u64 end)
>>   	} else {
>>   		nd_pa = memblock_alloc_nid(nd_size, SMP_CACHE_BYTES, nid);
>>   		if (!nd_pa) {
>> -			pr_err("Cannot find %zu bytes in node %d\n",
>> -			       nd_size, nid);
>> -			return;
>> +			pr_warn("Cannot find %zu bytes in node %d\n",
>> +				nd_size, nid);
> Hi Tang，
> 	Should this be an "pr_info" because the allocation failure is expected?

Hi Liu,

Sure, followed. Thanks. :)

> Regards!
> Gerry
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

