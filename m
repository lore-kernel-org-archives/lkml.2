Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757756Ab2K0BWJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 20:22:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45537 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755658Ab2K0BWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 20:22:08 -0500
Message-ID: <50B41573.4020205@zytor.com>
Date: Mon, 26 Nov 2012 17:20:51 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Jiang Liu <jiang.liu@huawei.com>
CC: Tang Chen <tangchen@cn.fujitsu.com>, wujianguo <wujianguo106@gmail.com>,
        akpm@linux-foundation.org, rob@landley.net,
        isimatu.yasuaki@jp.fujitsu.com, laijs@cn.fujitsu.com,
        wency@cn.fujitsu.com, linfeng@cn.fujitsu.com, yinghai@kernel.org,
        kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, mgorman@suse.de,
        rientjes@google.com, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-doc@vger.kernel.org, wujianguo@huawei.com, qiuxishi@huawei.com,
        Len Brown <lenb@kernel.org>
Subject: Re: [PATCH v2 5/5] page_alloc: Bootmem limit with movablecore_map
References: <1353667445-7593-1-git-send-email-tangchen@cn.fujitsu.com> <1353667445-7593-6-git-send-email-tangchen@cn.fujitsu.com> <50B36354.7040501@gmail.com> <50B36B54.7050506@cn.fujitsu.com> <50B38F69.6020902@zytor.com> <50B41395.60808@huawei.com>
In-Reply-To: <50B41395.60808@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2012 05:12 PM, Jiang Liu wrote:
> Hi Peter,
>
> I have tried to reserved movable memory from bootmem allocator, but the
> ACPICA subsystem is initialized later than setting up movable zone.
> So still trying to figure out a way to setup/reserve movable zones
> according to information from static ACPI tables such as SRAT/MPST etc.
>

[Adding Len Brown]

Right, for the case of platform-configured memory.  Len, I'm wondering 
if there is any reasonable way we can get memory-map-related stuff out 
of ACPI before we initialize the full ACPICA... we could of course write 
an ad hoc static parser (these are just static tables, after all), but 
I'm not sure if that fits into your overall view of how the subsystem 
should work?

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

