Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751046Ab2L1FWn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 00:22:43 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:36901 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab2L1FWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 00:22:39 -0500
Message-ID: <50DD2AFB.6030701@linaro.org>
Date: Fri, 28 Dec 2012 10:45:39 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 08/14] xen: netback: Remove redundant check on unsigned
 variable
References: <1353048646-10935-1-git-send-email-tushar.behera@linaro.org>  <1353048646-10935-9-git-send-email-tushar.behera@linaro.org> <1353057394.3499.159.camel@zakaz.uk.xensource.com>
In-Reply-To: <1353057394.3499.159.camel@zakaz.uk.xensource.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2012 02:46 PM, Ian Campbell wrote:
> On Fri, 2012-11-16 at 06:50 +0000, Tushar Behera wrote:
>> No need to check whether unsigned variable is less than 0.
>>
>> CC: Ian Campbell <ian.campbell@citrix.com>
>> CC: xen-devel@lists.xensource.com
>> CC: netdev@vger.kernel.org
>> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> 
> Acked-by: Ian Campbell <ian.campbell@citrix.com>
> 
> Thanks.
> 

This patch was not picked up for 3.8-rc1. Any idea, who should pick this up?

>> ---
>>  drivers/net/xen-netback/netback.c |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
>> index aab8677..515e10c 100644
>> --- a/drivers/net/xen-netback/netback.c
>> +++ b/drivers/net/xen-netback/netback.c
>> @@ -190,14 +190,14 @@ static int get_page_ext(struct page *pg,
>>  
>>  	group = ext.e.group - 1;
>>  
>> -	if (group < 0 || group >= xen_netbk_group_nr)
>> +	if (group >= xen_netbk_group_nr)
>>  		return 0;
>>  
>>  	netbk = &xen_netbk[group];
>>  
>>  	idx = ext.e.idx;
>>  
>> -	if ((idx < 0) || (idx >= MAX_PENDING_REQS))
>> +	if (idx >= MAX_PENDING_REQS)
>>  		return 0;
>>  
>>  	if (netbk->mmap_pages[idx] != pg)
> 
> 


-- 
Tushar Behera
