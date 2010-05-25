Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758802Ab0EYP0r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 11:26:47 -0400
Received: from exprod5og111.obsmtp.com ([64.18.0.22]:41616 "EHLO
	exprod5og111.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757090Ab0EYP0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 11:26:45 -0400
Message-ID: <4BFBEBA8.2030300@ge.com>
Date: Tue, 25 May 2010 16:24:24 +0100
From: Martyn Welch <martyn.welch@ge.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Andy Whitcroft <apw@canonical.com>
CC: Greg KH <gregkh@suse.de>, devel@driverdev.osuosl.org, nanakos@wired-net.gr,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: vme: vme.c: fixed an EXPORT_SYMBOL warning
References: <1274792957-4602-1-git-send-email-nanakos@wired-net.gr>	<20100525134453.GA4818@suse.de> <4BFBDC74.6000000@ge.com>
In-Reply-To: <4BFBDC74.6000000@ge.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martyn Welch wrote:
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
>
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

Andy, this looks like a miss detection in checkpatch.pl to me, and from
Greg's comment I get the impression he thinks the same. What do you think?

Martyn

>> confused,
>>   
>>     
>
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
>   


-- 
Martyn Welch (Principal Software Engineer)   |   Registered in England and
GE Intelligent Platforms                     |   Wales (3828642) at 100
T +44(0)127322748                            |   Barbirolli Square, Manchester,
E martyn.welch@ge.com                        |   M2 3AB  VAT:GB 927559189

