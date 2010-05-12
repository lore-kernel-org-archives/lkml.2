Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274Ab0ELOZP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 10:25:15 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:36507 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab0ELOZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 10:25:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=soovf0DZTiMgnvT938iLjJX4QvlgxorZ7pdAfRRqgT1JgzjFPkjnq2Gyypyn3vyvah
         SVEe+3aRH1GBF3lA4niQMAHXXjQ1OfWSIhfE6YKMfkKzsiFLrJvkCkhjOsCpW5av1sBY
         xNPV6V8J83iFYZXGzadD0XH/8WPzHZGCkai34=
Message-ID: <4BEABA71.7000508@gmail.com>
Date: Wed, 12 May 2010 07:25:53 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
       mdpoole@troilus.org
Subject: Re: [PATCH] HID:magicmouse: This fixes a connection problem with
 the magicmouse.
References: <1273595363-4020-1-git-send-email-justinmattock@gmail.com> <alpine.LNX.2.00.1005121456150.28092@pobox.suse.cz> <4BEAAF9C.909@gmail.com> <alpine.LNX.2.00.1005121540340.28092@pobox.suse.cz> <4BEAB3AF.6020909@gmail.com> <alpine.LNX.2.00.1005121602240.28092@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1005121602240.28092@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2010 07:03 AM, Jiri Kosina wrote:
> On Wed, 12 May 2010, Justin P. Mattock wrote:
>
>    
>>>>>> --- a/drivers/hid/hid-magicmouse.c
>>>>>> +++ b/drivers/hid/hid-magicmouse.c
>>>>>> @@ -354,7 +354,7 @@ static int magicmouse_probe(struct hid_device
>>>>>> *hdev,
>>>>>>     		goto err_free;
>>>>>>     	}
>>>>>>
>>>>>> -	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT&
>>>>>> ~HID_CONNECT_HIDINPUT);
>>>>>> +	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
>>>>>>
>>>>>>
>>>>>>              
>>>>> This is not particularly right, as we'll end up having dangling
>>>>> input device.
>>>>>
>>>>> The problem is, that when HIDRAW is not set, hid_hw_start()
>>>>> returns ENODEV as no subsystem has claimed the device, and probe
>>>>> routine bails out. Which is not what we want.
>>>>>
>>>>> Does the testing patch below fix the problems you are seeing?
>>>>>
>>>>>            
>>>> works good.. rebooted a few times mouse connects. suspended a few times
>>>> mouse reconnects.
>>>>
>>>>          
>>> I'd be glad if you could also double-check that device removal and
>>> re-connecting it works well as well with this patch.
>>>
>>>        
>> with  test I did different techniques,
>> 1) regular suspend(leave device on)
>> 2)suspend then shut off device
>> 3)shut off device then suspend
>> all of these techniques work properly
>>      
> Thanks for reporting and testing, I have queued the patch.
>
>    
cool...

Justin P. Mattock
