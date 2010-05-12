Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422Ab0ELN4Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 09:56:24 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:37766 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab0ELN4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 09:56:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=t/oEoE0VRHmMRd9wnu7lgPA0w6syl7Jllw1kTYGpddkzxewJuamRdtXH0m7kpYkBab
         6t4mLsuWgpkjPNksKCtxocjcE+FvlF9DW/RCdtmMhycG26kviCR31T5MMvJ4BDZfTtsu
         bb+nuNNnLbWt0RTpEq1tyq64hOnKHbETvQvqE=
Message-ID: <4BEAB3AF.6020909@gmail.com>
Date: Wed, 12 May 2010 06:57:03 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
       mdpoole@troilus.org
Subject: Re: [PATCH] HID:magicmouse: This fixes a connection problem with
 the magicmouse.
References: <1273595363-4020-1-git-send-email-justinmattock@gmail.com> <alpine.LNX.2.00.1005121456150.28092@pobox.suse.cz> <4BEAAF9C.909@gmail.com> <alpine.LNX.2.00.1005121540340.28092@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1005121540340.28092@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2010 06:41 AM, Jiri Kosina wrote:
> On Wed, 12 May 2010, Justin P. Mattock wrote:
>
>    
>>>> --- a/drivers/hid/hid-magicmouse.c
>>>> +++ b/drivers/hid/hid-magicmouse.c
>>>> @@ -354,7 +354,7 @@ static int magicmouse_probe(struct hid_device *hdev,
>>>>    		goto err_free;
>>>>    	}
>>>>
>>>> -	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT&   ~HID_CONNECT_HIDINPUT);
>>>> +	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
>>>>
>>>>          
>>> This is not particularly right, as we'll end up having dangling input
>>> device.
>>>
>>> The problem is, that when HIDRAW is not set, hid_hw_start() returns ENODEV
>>> as no subsystem has claimed the device, and probe routine bails out. Which
>>> is not what we want.
>>>
>>> Does the testing patch below fix the problems you are seeing?
>>>
>>>
>>>
>>>        
>> works good.. rebooted a few times mouse connects. suspended a few times
>> mouse reconnects.
>>      
> I'd be glad if you could also double-check that device removal and
> re-connecting it works well as well with this patch.
>
>    
with  test I did different techniques,
1) regular suspend(leave device on)
2)suspend then shut off device
3)shut off device then suspend
all of these techniques work properly
(let me know if this is what you meant).
>>> diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
>>> index 0d471fc..f10d56a 100644
>>> --- a/drivers/hid/hid-magicmouse.c
>>> +++ b/drivers/hid/hid-magicmouse.c
>>> @@ -354,12 +354,15 @@ static int magicmouse_probe(struct hid_device *hdev,
>>>    		goto err_free;
>>>    	}
>>>
>>> -	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT&   ~HID_CONNECT_HIDINPUT);
>>> +	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
>>>    	if (ret) {
>>>    		dev_err(&hdev->dev, "magicmouse hw start failed\n");
>>>    		goto err_free;
>>>    	}
>>>
>>> +	/* we are handling the input ourselves */
>>> +	hidinput_disconnect(hdev);
>>> +
>>>    	report = hid_register_report(hdev, HID_INPUT_REPORT, TOUCH_REPORT_ID);
>>>    	if (!report) {
>>>    		dev_err(&hdev->dev, "unable to register touch report\n");
>>>
>>>
>>>        
>> looks good over here.. If you'd like I can re-du this patch, add your
>> sign off etc.. and re-send, or not worry.. either way this little
>> quirk/problem is fixed.
>>      
> No problem, once you confirm that device removal wasn't broken again and
> if I don't hear any objections from Michael, I will queue the patch
> myself.
>
> Thanks,
>
>    
alright buddy,
looks good over here.

cheers.

Justin P. Mattock
