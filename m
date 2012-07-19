Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577Ab2GSXSL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 19:18:11 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:61291 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab2GSXSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 19:18:07 -0400
Message-ID: <500895AC.7020303@codemonkey.ws>
Date: Thu, 19 Jul 2012 18:18:04 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: KY Srinivasan <kys@microsoft.com>
CC: "Greg KH (gregkh@linuxfoundation.org)" <gregkh@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: Re: 0xB16B00B5? Really? (was Re: Move hyperv out of the drivers/staging/
 directory)
References: <6E21E5352C11B742B20C142EB499E048081E935D@TK5EX14MBXC124.redmond.corp.microsoft.com> <20110922173618.GA5624@suse.de> <6E21E5352C11B742B20C142EB499E048081EB789@TK5EX14MBXC124.redmond.corp.microsoft.com> <20111004170415.GA1320@suse.de> <6E21E5352C11B742B20C142EB499E048081EB86F@TK5EX14MBXC124.redmond.corp.microsoft.com> <20111004193414.GA15672@suse.de> <4FFFF711.8040003@redhat.com> <426367E2313C2449837CD2DE46E7EAF923547292@SN2PRD0310MB382.namprd03.prod.outlook.com> <20120719210709.GA32031@kroah.com> <426367E2313C2449837CD2DE46E7EAF9235475EE@SN2PRD0310MB382.namprd03.prod.outlook.com> <20120719220142.GA1513@kroah.com> <426367E2313C2449837CD2DE46E7EAF923547620@SN2PRD0310MB382.namprd03.prod.outlook.com>
In-Reply-To: <426367E2313C2449837CD2DE46E7EAF923547620@SN2PRD0310MB382.namprd03.prod.outlook.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2012 05:30 PM, KY Srinivasan wrote:
>
>
>> -----Original Message-----
>> From: Greg KH (gregkh@linuxfoundation.org)
>> [mailto:gregkh@linuxfoundation.org]
>> Sent: Thursday, July 19, 2012 6:02 PM
>> To: KY Srinivasan
>> Cc: Paolo Bonzini; devel@linuxdriverproject.org; linux-kernel@vger.kernel.org;
>> virtualization@lists.osdl.org
>> Subject: Re: 0xB16B00B5? Really? (was Re: Move hyperv out of the
>> drivers/staging/ directory)
>>
>> On Thu, Jul 19, 2012 at 09:22:53PM +0000, KY Srinivasan wrote:
>>>
>>>
>>>> -----Original Message-----
>>>> From: Greg KH (gregkh@linuxfoundation.org)
>>>> [mailto:gregkh@linuxfoundation.org]
>>>> Sent: Thursday, July 19, 2012 5:07 PM
>>>> To: KY Srinivasan
>>>> Cc: Paolo Bonzini; devel@linuxdriverproject.org; linux-
>> kernel@vger.kernel.org;
>>>> virtualization@lists.osdl.org
>>>> Subject: Re: 0xB16B00B5? Really? (was Re: Move hyperv out of the
>>>> drivers/staging/ directory)
>>>>
>>>> On Thu, Jul 19, 2012 at 02:11:47AM +0000, KY Srinivasan wrote:
>>>>>
>>>>>
>>>>>> -----Original Message-----
>>>>>> From: Paolo Bonzini [mailto:paolo.bonzini@gmail.com] On Behalf Of Paolo
>>>>>> Bonzini
>>>>>> Sent: Friday, July 13, 2012 6:23 AM
>>>>>> To: KY Srinivasan
>>>>>> Cc: Greg KH; devel@linuxdriverproject.org; linux-kernel@vger.kernel.org;
>>>>>> virtualization@lists.osdl.org
>>>>>> Subject: 0xB16B00B5? Really? (was Re: Move hyperv out of the
>>>> drivers/staging/
>>>>>> directory)
>>>>>>
>>>>>> Il 04/10/2011 21:34, Greg KH ha scritto:
>>>>>>> diff --git a/drivers/staging/hv/hyperv_vmbus.h
>>>> b/drivers/hv/hyperv_vmbus.h
>>>>>>> similarity index 99%
>>>>>>> rename from drivers/staging/hv/hyperv_vmbus.h
>>>>>>> rename to drivers/hv/hyperv_vmbus.h
>>>>>>> index 3d2d836..8261cb6 100644
>>>>>>> --- a/drivers/staging/hv/hyperv_vmbus.h
>>>>>>> +++ b/drivers/hv/hyperv_vmbus.h
>>>>>>> @@ -28,8 +28,7 @@
>>>>>>>   #include<linux/list.h>
>>>>>>>   #include<asm/sync_bitops.h>
>>>>>>>   #include<linux/atomic.h>
>>>>>>> -
>>>>>>> -#include "hyperv.h"
>>>>>>> +#include<linux/hyperv.h>
>>>>>>>
>>>>>>>   /*
>>>>>>>    * The below CPUID leaves are present if
>>>>>> VersionAndFeatures.HypervisorPresent
>>>>>>
>>>>>> git's rename detection snips away this gem:
>>>>>>
>>>>>> +#define HV_LINUX_GUEST_ID_LO		0x00000000
>>>>>> +#define HV_LINUX_GUEST_ID_HI		0xB16B00B5
>>>>>> +#define HV_LINUX_GUEST_ID		(((u64)HV_LINUX_GUEST_ID_HI
>>>>>> <<  32) | \
>>>>>> +					   HV_LINUX_GUEST_ID_LO)
>>>>>>
>>>>>> Somone was trying to be funny, I guess.
>>>>>>
>>>>>> KY, I suppose you have access to Hyper-V code or can ask someone who
>>>> does.
>>>>>> Is this signature actually used in the Hyper-V host code?
>>>>>
>>>>> Paolo,
>>>>>
>>>>> As I noted earlier, this is just a guest ID that needs to be registered with the
>>>>> hypervisor.  Thanks  for reporting this issue and on behalf of Microsoft, I
>> would
>>>>> like to  apologize for this offensive string. I have submitted a patch to fix this
>>>> issue.
>>>>
>>>> You only changed it to be in decimal, you did not change the id at all.
>>>> Is there some reason why you can not change it?  You said there was a
>>>> reserved range of ids that could be used, perhaps just pick another one?
>>>> What is the valid range that can be used here?
>>>
>>> Greg,
>>>
>>> As you know, this ID has been in use for a long time now. While the hypervisor
>>> does not interpret the guest ID that is registered, I am not sure what
>> dependencies
>>> there might be on this value.
>>
>> Could you please go find out the answer to this?
>
> That is easier said than done. I have sent emails out asking this very question and I have
> not received a definitive answer yet. Not knowing if and when I can get a definitive
> answer here, I chose the least risky approach in my patch.
>>
>> If, as you originally stated, there is a range of values we can use,
>> then we should probably use another one, right?
>
> On the Windows side this ID namespace is managed well. However on the Linux
> side, we have really had this current ID in use for almost five years now. I am not
> aware of any pool of IDs available for Linux usage except that Linux IDs be distinct from
> the guest IDs in use by MSFT operating systems. If I were to change the guest ID, I would
> probably want to comply with the MSFT guidance on constructing these IDs (although not
> all fields may be relevant for Linux).

Presumably, Hyper-V can deal with unexpected values here, no?  Otherwise, it 
wouldn't be future proof against new types of guests.

So worst case scenario, Hyper-V disables optimizations on Linux guests that 
report then new ID until they patch Hyper-V to know about the new ID.

That seems like a reasonable trade off to me.  I'm sure there's sufficient 
incentive to patch Hyper-V for this at Microsoft...

Regards,

Anthony Liguori

>
> Regards,
>
> K. Y
>
>
>

