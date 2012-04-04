Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914Ab2DDQ0g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 12:26:36 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:55635 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756837Ab2DDQ0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 12:26:34 -0400
Message-ID: <4F7C7626.40506@linux.vnet.ibm.com>
Date: Wed, 04 Apr 2012 11:26:14 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120310 Thunderbird/11.0
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] staging: zsmalloc: fix memory leak
References: <<1333376036-9841-1-git-send-email-sjenning@linux.vnet.ibm.com>> <d858d87f-6e07-4303-a9b3-e41ff93c8080@default>
In-Reply-To: <d858d87f-6e07-4303-a9b3-e41ff93c8080@default>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12040416-1976-0000-0000-00000C118BD1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2012 11:03 AM, Dan Magenheimer wrote:
>> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
>> Sent: Monday, April 02, 2012 8:14 AM
>> To: Greg Kroah-Hartman
>> Cc: Nitin Gupta; Dan Magenheimer; Konrad Rzeszutek Wilk; Robert Jennings; Seth Jennings;
>> devel@driverdev.osuosl.org; linux-kernel@vger.kernel.org; linux-mm@kvack.org
>> Subject: [PATCH] staging: zsmalloc: fix memory leak
>>
>> From: Nitin Gupta <ngupta@vflare.org>
>>
>> This patch fixes a memory leak in zsmalloc where the first
>> subpage of each zspage is leaked when the zspage is freed.
>>
>> Based on 3.4-rc1.
>>
>> Signed-off-by: Nitin Gupta <ngupta@vflare.org>
>> Acked-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
> 
> This is a rather severe memory leak and will affect most
> benchmarking anyone does to evaluate zcache in 3.4 (e.g. as
> to whether zcache is suitable for promotion), so t'would be nice
> to get this patch in for -rc2.  (Note it fixes a "regression"
> since it affects zcache only in 3.4+ because the fix is to
> the new zsmalloc allocator... so no change to stable trees.)
> 
> Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>

Thanks Dan for this clarification and the Ack.

I should have tagged this as urgent for the 3.4 release
and no impact on stable trees, since 3.4 is the first release
with this code.

--
Seth

