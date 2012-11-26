Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab2KZPwO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 10:52:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33390 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406Ab2KZPwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 10:52:13 -0500
Message-ID: <50B38F69.6020902@zytor.com>
Date: Mon, 26 Nov 2012 07:48:57 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tang Chen <tangchen@cn.fujitsu.com>
CC: wujianguo <wujianguo106@gmail.com>, akpm@linux-foundation.org,
        rob@landley.net, isimatu.yasuaki@jp.fujitsu.com, laijs@cn.fujitsu.com,
        wency@cn.fujitsu.com, linfeng@cn.fujitsu.com, jiang.liu@huawei.com,
        yinghai@kernel.org, kosaki.motohiro@jp.fujitsu.com,
        minchan.kim@gmail.com, mgorman@suse.de, rientjes@google.com,
        rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-doc@vger.kernel.org, wujianguo@huawei.com,
        qiuxishi@huawei.com
Subject: Re: [PATCH v2 5/5] page_alloc: Bootmem limit with movablecore_map
References: <1353667445-7593-1-git-send-email-tangchen@cn.fujitsu.com> <1353667445-7593-6-git-send-email-tangchen@cn.fujitsu.com> <50B36354.7040501@gmail.com> <50B36B54.7050506@cn.fujitsu.com>
In-Reply-To: <50B36B54.7050506@cn.fujitsu.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2012 05:15 AM, Tang Chen wrote:
> 
> Hi Wu,
> 
> That is really a problem. And, before numa memory got initialized,
> memblock subsystem would be used to allocate memory. I didn't find any
> approach that could fully address it when I making the patches. There
> always be risk that memblock allocates memory on ZONE_MOVABLE. I think
> we can only do our best to prevent it from happening.
> 
> Your patch is very helpful. And after a shot look at the code, it seems
> that acpi_numa_memory_affinity_init() is an architecture dependent
> function. Could we do this somewhere which is not depending on the
> architecture ?
> 

The movable memory should be classified as a non-RAM type in memblock,
that way we will not allocate from it early on.

	-hpa

