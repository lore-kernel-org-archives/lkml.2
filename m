Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696Ab2DIUXx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 16:23:53 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:50795 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324Ab2DIUXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 16:23:51 -0400
Message-ID: <4F83454A.3050007@linux.vnet.ibm.com>
Date: Mon, 09 Apr 2012 15:23:38 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] staging: zsmalloc: fix memory leak
References: <<1333376036-9841-1-git-send-email-sjenning@linux.vnet.ibm.com>> <d858d87f-6e07-4303-a9b3-e41ff93c8080@default> <4F7C7626.40506@linux.vnet.ibm.com>
In-Reply-To: <4F7C7626.40506@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12040920-3352-0000-0000-000003E882ED
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Greg,

Haven't heard back from you on this patch and it needs to
get into the 3.4 -rc releases ASAP.  It fixes a substantial
memory leak when frontswap/zcache are enabled.

Let me know if you need me to repost.

The patch was sent on 4/2.

Thanks,
Seth

On 04/04/2012 11:26 AM, Seth Jennings wrote:
> On 04/04/2012 11:03 AM, Dan Magenheimer wrote:
>>> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
>>> Sent: Monday, April 02, 2012 8:14 AM
>>> To: Greg Kroah-Hartman
>>> Cc: Nitin Gupta; Dan Magenheimer; Konrad Rzeszutek Wilk; Robert Jennings; Seth Jennings;
>>> devel@driverdev.osuosl.org; linux-kernel@vger.kernel.org; linux-mm@kvack.org
>>> Subject: [PATCH] staging: zsmalloc: fix memory leak
>>>
>>> From: Nitin Gupta <ngupta@vflare.org>
>>>
>>> This patch fixes a memory leak in zsmalloc where the first
>>> subpage of each zspage is leaked when the zspage is freed.
>>>
>>> Based on 3.4-rc1.
>>>
>>> Signed-off-by: Nitin Gupta <ngupta@vflare.org>
>>> Acked-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
>>
>> This is a rather severe memory leak and will affect most
>> benchmarking anyone does to evaluate zcache in 3.4 (e.g. as
>> to whether zcache is suitable for promotion), so t'would be nice
>> to get this patch in for -rc2.  (Note it fixes a "regression"
>> since it affects zcache only in 3.4+ because the fix is to
>> the new zsmalloc allocator... so no change to stable trees.)
>>
>> Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>
> 
> Thanks Dan for this clarification and the Ack.
> 
> I should have tagged this as urgent for the 3.4 release
> and no impact on stable trees, since 3.4 is the first release
> with this code.
> 
> --
> Seth

