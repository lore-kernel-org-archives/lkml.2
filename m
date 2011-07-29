Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523Ab1G2CR1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 22:17:27 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:35653 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308Ab1G2CR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 22:17:26 -0400
X-AuditID: cbfee61a-b7cf0ae000006bc6-7b-4e3218341e08
Date: Fri, 29 Jul 2011 11:17:11 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
Subject: Re: [PATCH 1/1] mmc: Fixed bug in IDMAC_SET_BUFFER1_SIZE Macro in
 dw_mmc.c
In-reply-to: <4E314562.2000001@imgtec.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: Shashidhar Hiremath <shashidharh@vayavyalabs.com>,
        Will Newton <will.newton@imgtec.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-id: <4E321827.5020606@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
User-Agent: Thunderbird 2.0.0.24 (X11/20100623)
References: <1311851023-3563-1-git-send-email-shashidharh@vayavyalabs.com>
 <4E314562.2000001@imgtec.com>
X-OriginalArrivalTime: 29 Jul 2011 02:17:44.0020 (UTC)
 FILETIME=[B347E140:01CC4D95]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi..

this patch is right.

Acked-by : Jaehoon Chung <jh80.chung@samsung.com>

Regards,
Jaehoon Chung

James Hogan wrote:
> On 07/28/2011 12:03 PM, Shashidhar Hiremath wrote:
>> The mask used inside this macro was assuming Buffer_Size1's[BS1's] width to be 14 bits,
>> it is actually of 13 bits, Modified masks used in IDMAC_SET_BUFFER1_SIZE such that
>> they use only 13 bits instead of current 14.
>>
>> Signed-off-by: Shashidhar Hiremath <shashidharh@vayavyalabs.com>
>> ---
>>  drivers/mmc/host/dw_mmc.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
>> index 77f0b6b..f13bb49 100644
>> --- a/drivers/mmc/host/dw_mmc.c
>> +++ b/drivers/mmc/host/dw_mmc.c
>> @@ -62,7 +62,7 @@ struct idmac_desc {
>>  
>>  	u32		des1;	/* Buffer sizes */
>>  #define IDMAC_SET_BUFFER1_SIZE(d, s) \
>> -	((d)->des1 = ((d)->des1 & 0x03ffc000) | ((s) & 0x3fff))
>> +	((d)->des1 = ((d)->des1 & 0x03ffe000) | ((s) & 0x1fff))
>>  
>>  	u32		des2;	/* buffer 1 physical address */
>>  
> 
> Yes, according to the TRM you appear to be correct
> 
> Reviewed-by: James Hogan <james.hogan@imgtec.com>
> 
> Thanks
> James
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

