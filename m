Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096Ab0F1U5v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 16:57:51 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:2476 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751734Ab0F1U5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 16:57:50 -0400
X-Greylist: delayed 913 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Jun 2010 16:57:50 EDT
Message-ID: <4C290983.5050808@hetnet.nl>
Date: Mon, 28 Jun 2010 22:43:47 +0200
From: Henk de Groot <henk.de.groot@hetnet.nl>
Reply-To: henk.de.groot@hetnet.nl
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; nl; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>, Kulikov Vasiliy <segooon@gmail.com>,
       trivial@kernel.org, Kernel Janitors <kernel-janitors@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Henk de Groot <pe1dnn@amsat.org>,
       Joe Perches <joe@perches.com>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/16] trivial: use ARRAY_SIZE
References: <1277726143-24899-1-git-send-email-segooon@gmail.com> <20100628125224.GJ19184@bicker> <20100628131511.GA26416@shinshilla> <20100628132453.GK19184@bicker>
In-Reply-To: <20100628132453.GK19184@bicker>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jun 2010 20:42:35.0850 (UTC) FILETIME=[70B562A0:01CB1702]
X-RecipientDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 28-6-2010 15:24, Dan Carpenter schreef:
> On Mon, Jun 28, 2010 at 05:15:11PM +0400, Kulikov Vasiliy wrote:
>    
>> On Mon, Jun 28, 2010 at 14:52 +0200, Dan Carpenter wrote:
>>      
>>> On Mon, Jun 28, 2010 at 03:55:41PM +0400, Kulikov Vasiliy wrote:
>>>        
>>>> Change sizeof(x) / sizeof(*x) to ARRAY_SIZE(x).
>>>>
>>>> Signed-off-by: Kulikov Vasiliy<segooon@gmail.com>
>>>> ---
>>>>   drivers/staging/wlags49_h2/hcf.c |    2 +-
>>>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>>>
>>>> diff --git a/drivers/staging/wlags49_h2/hcf.c b/drivers/staging/wlags49_h2/hcf.c
>>>> index 390628c..c4fe0ec 100644
>>>> --- a/drivers/staging/wlags49_h2/hcf.c
>>>> +++ b/drivers/staging/wlags49_h2/hcf.c
>>>> @@ -502,7 +502,7 @@ HCF_STATIC hcf_16* BASED xxxx[ ] = {
>>>>   #endif // MSF_COMPONENT_ID
>>>>   	NULL									//endsentinel
>>>>     };
>>>> -#define xxxx_PRI_IDENTITY_OFFSET	(sizeof(xxxx)/sizeof(xxxx[0]) - 3)
>>>> +#define xxxx_PRI_IDENTITY_OFFSET	(ARRAY_SIZE(xxxx) - 3)
>>>>
>>>>          
>>> I would say the more critical problem with this macro is that it doesn't
>>> work unless you name all your arrays "xxxx[]" so it encourages sub par
>>> variable names.
>>>
>>> You could do:
>>> #define PRI_IDENTITY_OFFSET(x) (ARRAY_SIZE(x) - 3)
>>>        
>> Look at the patch:
>>
>>      
>>>> @@ -502,7 +502,7 @@ HCF_STATIC hcf_16* BASED xxxx[ ] = {
>>>>          
>> There is an array called 'xxxx' and macro xxxx_PRI_IDENTITY_OFFSET is defined
>> after array definition. This magic macroconstant is used in the code to get
>> elements of xxxx.
>>      
> Right right.  But xxxx is a stupid name for a variable.  I wanted to
> poke my eyes out with a fork.
>
> Not your fault obviously.  Your patch doesn't make it worse so I'm fine
> with it as far as it goes...
>
> regards,
> dan carpenter
>    

The whole HCF library code is full of this funny stuff. My guess is the 
code is generated and macro's are used to access arrays in a uniform 
way. At least that's the only thing I can think of why it is as it is. 
Only the original developers at Agere can tell the real story. The same 
with structure definitions. You could send this to the IOCCC easily (it 
is only too big to qualify)...

I think the best way to fix this is to take all this funny stuff out and 
make it simplified readable code. Currently its very hard to see through 
all the macro layers what actually happens which make is unmaintainable. 
Changing details is okay, but will never make any of this more readable.

When porting the driver from the original Agere 2.4 kernel code to the 
2.6 driver today I only need to change one or two casts, the rest of the 
HCF code is untouched. The only Linux code is in the wl_* files which 
coding style looks quite different from the rest and is actually readable.

Kind regards,

Henk.

