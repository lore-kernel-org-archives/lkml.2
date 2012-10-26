Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966185Ab2JZTft (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 15:35:49 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:35170 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966127Ab2JZTfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 15:35:48 -0400
Message-ID: <508AE611.3020504@mvista.com>
Date: Fri, 26 Oct 2012 14:35:45 -0500
From: Corey Minyard <cminyard@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: minyard@acm.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>
Subject: Re: [PATCH 4/5] IPMI: Fix some uninitialized warning
References: <1350420820-7156-1-git-send-email-minyard@acm.org> <1350420820-7156-5-git-send-email-minyard@acm.org> <20121022164902.9b204646.akpm@linux-foundation.org>
In-Reply-To: <20121022164902.9b204646.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2012 06:49 PM, Andrew Morton wrote:
> On Tue, 16 Oct 2012 15:53:39 -0500
> minyard@acm.org wrote:
>
>> From: Corey Minyard <cminyard@mvista.com>
>>
>> There was a spot where the compiler couldn't tell some variables
>> would be set.  So initialize them to make the warning go away.
>>
>> Signed-off-by: Corey Minyard <cminyard@mvista.com>
>> ---
>>   drivers/char/ipmi/ipmi_msghandler.c |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
>> index 2c29942..a0c84bb 100644
>> --- a/drivers/char/ipmi/ipmi_msghandler.c
>> +++ b/drivers/char/ipmi/ipmi_msghandler.c
>> @@ -1880,7 +1880,7 @@ int ipmi_request_supply_msgs(ipmi_user_t          user,
>>   			     struct ipmi_recv_msg *supplied_recv,
>>   			     int                  priority)
>>   {
>> -	unsigned char saddr, lun;
>> +	unsigned char saddr = 0, lun = 0;
>>   	int           rv;
>>   
>>   	if (!user)
> The kernel build actually generates quite a lot of "bar uninitialised"
> warnings for foo(&bar) expressions.  I just ignore them, because later
> versions of gcc stopped doing that.
>
> The fix is OK, I suppose.  But it will cause additional code to be
> emitted.  Using uninitialized_var() avoids that, and makes things
> clearer to the reader.
Well, warnings annoy me, especially when I get the emails about them.  
But I suppose that's the point of the emails :).

I'll do a patch to switch it to uninitialized_var() for the next set of 
things I send.  Thanks.

-corey

