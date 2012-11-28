Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377Ab2K1DuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 22:50:20 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:36537 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751497Ab2K1DuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 22:50:17 -0500
X-IronPort-AV: E=Sophos;i="4.83,331,1352044800"; 
   d="scan'208";a="6289196"
Message-ID: <50B58965.7040703@cn.fujitsu.com>
Date: Wed, 28 Nov 2012 11:47:49 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: wujianguo <wujianguo106@gmail.com>
CC: hpa@zytor.com, akpm@linux-foundation.org, rob@landley.net,
        isimatu.yasuaki@jp.fujitsu.com, laijs@cn.fujitsu.com,
        wency@cn.fujitsu.com, linfeng@cn.fujitsu.com, jiang.liu@huawei.com,
        yinghai@kernel.org, kosaki.motohiro@jp.fujitsu.com,
        minchan.kim@gmail.com, mgorman@suse.de, rientjes@google.com,
        rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 0/5] Add movablecore_map boot option
References: <1353667445-7593-1-git-send-email-tangchen@cn.fujitsu.com> <50B42F32.4050107@gmail.com>
In-Reply-To: <50B42F32.4050107@gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/28 11:48:24,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/28 11:48:31,
	Serialize complete at 2012/11/28 11:48:31
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2012 11:10 AM, wujianguo wrote:
>
> Hi Tang,
> 	DMA address can't be set as movable, if some one boot kernel with
> movablecore_map=4G@0xa00000 or other memory region that contains DMA address,
> system maybe boot failed. Should this case be handled or mentioned
> in the change log and kernel-parameters.txt?

Hi Wu,

I think we can use MAX_DMA_PFN and MAX_DMA32_PFN to prevent setting DMA
address as movable. Just ignore the address lower than them, and set
the rest as movable. How do you think ?

And, since we cannot figure out the minimum of memory kernel needs, I
think for now, we can just add some warning into kernel-parameters.txt.

Thanks. :)

>
> Thanks,
> Jianguo Wu
>
