Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372Ab2EMMsM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 08:48:12 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:37114 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752342Ab2EMMsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 08:48:11 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18aTztMM8Yau4pXQ3CC2C0ROOCKaXtyMPYhpfCbzp
	DrAAcA+7yJRisa
Message-ID: <4FAFAD7B.6090207@gmx.de>
Date: Sun, 13 May 2012 12:47:55 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Icedove/3.0.11
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>
CC: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH] video/smscufx: fix line counting in fb_write
References: <1334959867-3719-1-git-send-email-holler@ahsoftware.de> <4F92995B.6030805@ahsoftware.de>
In-Reply-To: <4F92995B.6030805@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander,

On 04/21/2012 11:26 AM, Alexander Holler wrote:
> Hello,
> 
> as for the patch for udlfb, I forgot to mention that this is a candidate
> for all stable trees 3.2 and above.
> 
> Btw., the address of the maintainer doesn't seem to be valid anymore.

it is better to cc me on patches to the framebuffer subsystem for such
cases. I don't have much free time so it's rare that I come around to
dig in the mailing list.

> 
> Regards,
> 
> Alexander
> 
> Am 21.04.2012 00:11, schrieb Alexander Holler:
>> Line 0 and 1 were both written to line 0 (on the display) and all
>> subsequent
>> lines had an offset of -1. The result was that the last line on the
>> display
>> was never overwritten by writes to /dev/fbN.
>>
>> The origin of this bug seems to have been udlfb.
>>
>> Signed-off-by: Alexander Holler<holler@ahsoftware.de>
> 
> Cc: stable@vger.kernel.org

Patch looks good to me but can be made simpler.

> 
>> ---
>>   drivers/video/smscufx.c |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/video/smscufx.c b/drivers/video/smscufx.c
>> index ccbfef5..1e1e2d2 100644
>> --- a/drivers/video/smscufx.c
>> +++ b/drivers/video/smscufx.c
>> @@ -904,7 +904,7 @@ static ssize_t ufx_ops_write(struct fb_info *info,
>> const char __user *buf,
>>       result = fb_sys_write(info, buf, count, ppos);
>>
>>       if (result>  0) {
>> -        int start = max((int)(offset / info->fix.line_length) - 1, 0);
>> +        int start = max((int)(offset / info->fix.line_length), 0);

the cast to int as well as the max is superfluous without the -1 as the
value can no longer be negative.

>>           int lines = min((u32)((result / info->fix.line_length) + 1),
>>                   (u32)info->var.yres);
>>
> 

Best regards,

Florian Tobias Schandinat
