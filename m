Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933086Ab0EYPHS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 11:07:18 -0400
Received: from mail.wired-net.gr ([86.35.2.10]:39289 "EHLO enigma.wired-net.gr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932854Ab0EYPHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 11:07:16 -0400
Message-ID: <4BFBE793.5030103@wired-net.gr>
Date: Tue, 25 May 2010 18:06:59 +0300
From: Nanakos Chrysostomos <nanakos@wired-net.gr>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Martyn Welch <martyn.welch@ge.com>
CC: Greg KH <gregkh@suse.de>, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: vme: vme.c: fixed an EXPORT_SYMBOL warning
References: <1274792957-4602-1-git-send-email-nanakos@wired-net.gr> <20100525134453.GA4818@suse.de> <4BFBDC74.6000000@ge.com>
In-Reply-To: <4BFBDC74.6000000@ge.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/5/2010 17:19, Martyn Welch wrote:
> Greg KH wrote:
>   
>> On Tue, May 25, 2010 at 01:09:17PM +0000, nanakos@wired-net.gr wrote:
>>   
>>     
>>> From: Nanakos Chrysostomos <nanakos@wired-net.gr>
>>>
>>> Fixed an EXPORT_SYMBOL warning.
>>>     
>>>       
>> What type of warning?  a checkpatch.pl one?  a gcc one?  a sparse one?
>>
>> Please be more verbose.
>>
>>   
>>     
>>> Signed-off-by: Nanakos Chrysostomos <nanakos@wired-net.gr>
>>> ---
>>>  drivers/staging/vme/vme.c |    2 +-
>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/drivers/staging/vme/vme.c b/drivers/staging/vme/vme.c
>>> index 093fbff..a0b63d5 100644
>>> --- a/drivers/staging/vme/vme.c
>>> +++ b/drivers/staging/vme/vme.c
>>> @@ -1519,7 +1519,6 @@ struct bus_type vme_bus_type = {
>>>  	.probe = vme_bus_probe,
>>>  	.remove = vme_bus_remove,
>>>  };
>>> -EXPORT_SYMBOL(vme_bus_type);
>>>  
>>>  static int __init vme_init(void)
>>>  {
>>> @@ -1530,6 +1529,7 @@ static void __exit vme_exit(void)
>>>  {
>>>  	bus_unregister(&vme_bus_type);
>>>  }
>>> +EXPORT_SYMBOL(vme_bus_type);
>>>     
>>>       
>> This does not look correct, why move this away from where the structure
>> is defined?
>>
>>   
>>     
> It's a checkpatch error:
>
> $ scripts/checkpatch.pl -f drivers/staging/vme/vme.c
> WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
> #1522: FILE: staging/vme/vme.c:1522:
> +EXPORT_SYMBOL(vme_bus_type);
>
> total: 0 errors, 1 warnings, 1539 lines checked
>
>
>   
>> confused,
>>   
>>     
> Yup, confused me as well. :-)
>
> Martyn
>
>   
>> greg k-h
>>   
>>     
>
>   
Yes you are right, this is a checkpatch error as well.

Thanks for your time looking the patches.
