Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447Ab0FHK6U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 06:58:20 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35619 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716Ab0FHK6S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 06:58:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=BEphicvA01fDb9Av2EhdYJR3uPWYPMeupechCqKBRYjvW3QYmP8/G9pLCzyL+F3LMm
         Q1aQodnRYPJZVqNSvJFea8EJP9L7JGG1g9j2+hgNTeu46+RPFTDSiTXm2EkZLAGyUYaO
         YJhDOT5THWmXLQg4GNUlcDJQDVAhtnLGmDN6o=
MIME-Version: 1.0
In-Reply-To: <AANLkTimIl6UL0HQT1wxRgXuj_m0O3CwMHQIa1xNE1Ax9@mail.gmail.com>
References: <AANLkTinG3jv6o8T00mDTEP5uxf4tKqOwSPEDIUcv4kVG@mail.gmail.com> 
	<20100602213429.GA14866@srcf.ucam.org> <57DF5FDC2DC0634FA2A310BC5B81A68D01DF4CD01E@AUSX7MCPC108.AMER.DELL.COM> 
	<AANLkTimIl6UL0HQT1wxRgXuj_m0O3CwMHQIa1xNE1Ax9@mail.gmail.com>
From: Islam Amer <pharon@gmail.com>
Date: Tue, 8 Jun 2010 13:57:57 +0300
Message-ID: <AANLkTin0qht1XR2rUgIXMEeJNU_gb3IZWqSBJb7NXD8K@mail.gmail.com>
Subject: Re: Dell Studio 1555 eject key does not work ( small patch to fix 
	included )
To: Rezwanul_Kabir@dell.com
Cc: mjg59@srcf.ucam.org, linux-kernel@vger.kernel.org,
       platform-driver-x86@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Rezwanul,

I have been using this fix for quite some time without any visible ill
effects on the other keys or the system in general.
Of course it would be necessary to get feedback from other dell users.

Thanks.

On Thu, Jun 3, 2010 at 11:16 PM, Islam Amer <pharon@gmail.com> wrote:
> Hello,
>
> I suspected the same about dell_new_hk_type, but I am confused that
> the rest of the fn keys work just fine out of the box. The only button
> that didn't work was the eject key.
>
> Attached is the dmidecode output.
>
> Thanks
>
> On Thu, Jun 3, 2010 at 5:57 AM,  <Rezwanul_Kabir@dell.com> wrote:
>>
>>>Hi Rez,
>>>
>>>Any thoughts on this?
>>>
>>
>>
>>  From the discussion below, it seems that this system does not implement the new
>> WMI scheme ( which is when dell_new_hk_type=true is set). So, at issue here is the
>> legacy code. Without knowing exactly why BIOS would behave differently in this particular case,
>> the fix seems arbitrary. Let me see if I can get hold of the BIOS developer(if possible) and provide feedback in this thread.
>>
>> Islam Amer
>>
>>   Can you attach dmidecode output from the system here?
>>
>> Thanks..
>>   --rez
>>
>>
>>
>>
>>
>>>On Thu, Jun 03, 2010 at 01:14:09AM +0400, Islam Amer wrote
>>>> Hello,
>>>>
>>>> Pressing the eject key on my Dell Studio 1555 does not work
>>>and dmesg
>>>> produces this message :
>>>> dell-wmi: Unknown key 0 pressed
>>>>
>>>> Adding a debugging printk in dell-wmi.c after line 222 like this :
>>>>
>>>> printk(KERN_INFO "dell:wmi 0x%x , 0x%x \n", buffer_entry[1],
>>>> buffer_entry[2]);
>>>>
>>>> dmesg now shows :
>>>>
>>>> dell:wmi 0x0 , 0xe009
>>>> dell-wmi: Unknown key 0 pressed
>>>>
>>>> So for some reason buffer_entry[1] is used although it is empty.
>>>>
>>>> Falling back to buffer_entry[2] in case buffer_entry[1] is 0x0 makes
>>>> the button work.
>>>>
>>>> I suspect it might be better to fix the "dell_new_hk_type" logic
>>>> though
>>>>
>>>> I had submitted this as
>>>> https://bugzilla.kernel.org/show_bug.cgi?id=16075 but repeating the
>>>> information and patch here as per Andrew Morton's suggestion.
>>>>
>>>>
>>>> Thanks.
>>>>
>>>> ---
>>>linux-sidux-2.6-2.6.34/drivers/platform/x86/dell-wmi.c.orig
>>>2010-06-03
>>>> 01:02:17.418824168 +0400
>>>> +++ linux-sidux-2.6-2.6.34/drivers/platform/x86/dell-wmi.c
>>>2010-06-03
>>>> 01:01:40.641833249 +0400
>>>> @@ -221,7 +221,7 @@ static void dell_wmi_notify(u32 value, v
>>>>                      return;
>>>>              }
>>>>
>>>> -            if (dell_new_hk_type)
>>>> +            if (dell_new_hk_type || buffer_entry[1] == 0x0)
>>>>                      reported_key = (int)buffer_entry[2];
>>>>              else
>>>>                      reported_key = (int)buffer_entry[1] & 0xffff;
>>>>
>>>--
>>>Matthew Garrett | mjg59@srcf.ucam.org
>>>
>
