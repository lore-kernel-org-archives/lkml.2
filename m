Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758908Ab1LOOf4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 09:35:56 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34214 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab1LOOfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 09:35:55 -0500
Message-ID: <4EEA05C5.3070807@acm.org>
Date: Thu, 15 Dec 2011 08:35:49 -0600
From: Corey Minyard <tcminyard@gmail.com>
Reply-To: minyard@acm.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        gcase@redhat.com
Subject: Re: [PATCH] ipmi: Increase KCS timeouts
References: <1322680347-25743-1-git-send-email-mjg@redhat.com> <20111214211228.GA28019@srcf.ucam.org>
In-Reply-To: <20111214211228.GA28019@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is fine, if it is really necessary to make slow hardware work.  
I've pulled it in, I'll submit in a bit.

-corey

On 12/14/2011 03:12 PM, Matthew Garrett wrote:
> Ping?
>
> On Wed, Nov 30, 2011 at 02:12:27PM -0500, Matthew Garrett wrote:
>> We currently time out and retry KCS transactions after 1 second of waiting
>> for IBF or OBF. This appears to be too short for some hardware. The IPMI
>> spec says "All system software wait loops should include error timeouts. For
>> simplicity, such timeouts are not shown explicitly in the flow diagrams. A
>> five-second timeout or greater is recommended". Change the timeout to five
>> seconds to satisfy the slow hardware.
>>
>> Signed-off-by: Matthew Garrett<mjg@redhat.com>
>> ---
>>   drivers/char/ipmi/ipmi_kcs_sm.c |    4 ++--
>>   1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/char/ipmi/ipmi_kcs_sm.c b/drivers/char/ipmi/ipmi_kcs_sm.c
>> index cf82fed..e53fc24 100644
>> --- a/drivers/char/ipmi/ipmi_kcs_sm.c
>> +++ b/drivers/char/ipmi/ipmi_kcs_sm.c
>> @@ -118,8 +118,8 @@ enum kcs_states {
>>   #define MAX_KCS_WRITE_SIZE IPMI_MAX_MSG_LENGTH
>>
>>   /* Timeouts in microseconds. */
>> -#define IBF_RETRY_TIMEOUT 1000000
>> -#define OBF_RETRY_TIMEOUT 1000000
>> +#define IBF_RETRY_TIMEOUT 5000000
>> +#define OBF_RETRY_TIMEOUT 5000000
>>   #define MAX_ERROR_RETRIES 10
>>   #define ERROR0_OBF_WAIT_JIFFIES (2*HZ)
>>
>> -- 
>> 1.7.7.1
>>
>>

