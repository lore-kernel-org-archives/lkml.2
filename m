Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145Ab1FPCtK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 22:49:10 -0400
Received: from mta11.charter.net ([216.33.127.80]:65467 "EHLO
	mta11.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754964Ab1FPCtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 22:49:07 -0400
X-Authority-Analysis: v=1.1 cv=G6Q69DB3AUoJKS2BpLRaz8MQ2NORN7h5HRzrJMPOhRw=
 c=1 sm=1 a=p9YancsnzTcA:10 a=ATN9wnctRWoA:10 a=8nJEP1OIZ-IA:10
 a=xzrYXqw+0zwiO4gHSXHcAg==:17 a=v21-0AKBVq57tRSLXVgA:9
 a=ShJvtIunUxAr5zsxZqsA:7 a=wPNLvfGTeEIA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:117
Message-ID: <4DF96F22.5070508@cuw.edu>
Date: Wed, 15 Jun 2011 21:49:06 -0500
From: Greg Dietsche <gregory.dietsche@cuw.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110505 Icedove/3.0.11
MIME-Version: 1.0
To: Henry Ptasinski <henryp@broadcom.com>
CC: "gregkh@suse.de" <gregkh@suse.de>, Brett Rudley <brudley@broadcom.com>,
        Dowan Kim <dowan@broadcom.com>, Roland Vossen <rvossen@broadcom.com>,
        Arend Van Spriel <arend@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: brcm80211: return false if not a broadcom board
References: <1308176709-14765-1-git-send-email-Gregory.Dietsche@cuw.edu> <20110616013615.GA14700@broadcom.com>
In-Reply-To: <20110616013615.GA14700@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/15/2011 08:36 PM, Henry Ptasinski wrote:
> On Wed, Jun 15, 2011 at 03:25:09PM -0700, Greg Dietsche wrote:
>    
>> This code looks wrong to me. I think it meant to return false
>> if the board's vendor id isn't Broadcom's.
>>
>> Compile tested only.
>>
>> Signed-off-by: Greg Dietsche<Gregory.Dietsche@cuw.edu>
>> ---
>>   drivers/staging/brcm80211/brcmsmac/wlc_bmac.c |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
>> index 4534926..ee13238 100644
>> --- a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
>> +++ b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
>> @@ -1943,7 +1943,7 @@ static bool wlc_validboardtype(struct wlc_hw_info *wlc_hw)
>>   	}
>>
>>   	if (wlc_hw->sih->boardvendor != PCI_VENDOR_ID_BROADCOM)
>> -		return goodboard;
>> +		goodboard = false;
>>
>>   	return goodboard;
>>   }
>>      
> Actually, the original code is correct.
>
> For boards with the Broadcom ID, this function checks that the boardrev is
> sane. Dev boards that aren't properly configured may have invalid info, so this
> check is mainly to catch that problem.
>
> For boards with any other vendor, we don't have any sanity checks that we know
> should be done, so the board info is always considered good.
>
> The device ID is of course always checked.
>
> - Henry
>
>    
Hi Henry,
Thanks for the explanation - I'm still a little confused on this... 
probably more because of how the code reads. Let me explain:

The part that threw me off in this code when I originally read it is 
that it always returns goodboard. It doesn't actually matter what the 
vendor id is. So my first thought was "what did they really mean to code 
here...?" That's why I sent the patch. So if the patch isn't necessary, 
then great! :) But it seems like we could/should just drop the check for 
vendor id?

thanks,
Greg

