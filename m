Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118Ab2K0Fce (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 00:32:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47028 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825Ab2K0Fcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 00:32:32 -0500
Message-ID: <50B45021.2000009@zytor.com>
Date: Mon, 26 Nov 2012 21:31:13 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Wen Congyang <wency@cn.fujitsu.com>
CC: Tang Chen <tangchen@cn.fujitsu.com>, wujianguo <wujianguo106@gmail.com>,
        akpm@linux-foundation.org, rob@landley.net,
        isimatu.yasuaki@jp.fujitsu.com, laijs@cn.fujitsu.com,
        linfeng@cn.fujitsu.com, jiang.liu@huawei.com, yinghai@kernel.org,
        kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, mgorman@suse.de,
        rientjes@google.com, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-doc@vger.kernel.org, wujianguo@huawei.com, qiuxishi@huawei.com
Subject: Re: [PATCH v2 5/5] page_alloc: Bootmem limit with movablecore_map
References: <1353667445-7593-1-git-send-email-tangchen@cn.fujitsu.com> <1353667445-7593-6-git-send-email-tangchen@cn.fujitsu.com> <50B36354.7040501@gmail.com> <50B36B54.7050506@cn.fujitsu.com> <50B38F69.6020902@zytor.com> <50B4304F.4070302@cn.fujitsu.com>
In-Reply-To: <50B4304F.4070302@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2012 07:15 PM, Wen Congyang wrote:
>
> Hi, hpa
>
> The problem is that:
> node1 address rang: [18G, 34G), and the user specifies movable map is [8G, 24G).
> We don't know node1's address range before numa init. So we can't prevent
> allocating boot memory in the range [24G, 34G).
>
> The movable memory should be classified as a non-RAM type in memblock. What
> do you want to say? We don't save type in memblock because we only
> add E820_RAM and E820_RESERVED_KERN to memblock.
>

We either need to keep the type or not add it to the memblocks.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

