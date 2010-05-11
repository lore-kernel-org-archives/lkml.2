Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160Ab0EKC5t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 22:57:49 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:60031 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758131Ab0EKC5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 22:57:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=fRAkXifWO3peUW6+Kn5080LAEr0UgwVDXZ2W/W0mjt47oR/SQkKqPlEG3Oa9b8ujrc
         4OnThoDgVeiwae6aPu/GG4fsEig9dHgbzET83xydoSJlDdSTOueVRkRIvYJa3R+tkdit
         TFa5SWr2wEI9NyULSQ7PUulvzyxL64AYDDfUA=
Message-ID: <4BE8C7CD.7030206@gmail.com>
Date: Mon, 10 May 2010 19:58:21 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Michael Poole <mdpoole@troilus.org>
CC: Jiri Kosina <jkosina@suse.cz>, linux-bluetooth@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: magicmouse: claimed by neither input, hiddev nor hidraw
References: <j2idd18b0c31005101341o43b652c1zf8729f5f9a60e0d3@mail.gmail.com>	<alpine.LRH.2.00.1005102334140.14809@twin.jikos.cz>	<s2odd18b0c31005101439v22d03bfdw4e65d7c4b8315b6a@mail.gmail.com>	<alpine.LNX.2.00.1005102351220.28092@pobox.suse.cz>	<4BE8859E.3090305@gmail.com> <87mxw7i33j.fsf@troilus.org>
In-Reply-To: <87mxw7i33j.fsf@troilus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2010 07:28 PM, Michael Poole wrote:
> Justin P. Mattock writes:
>
>    
>> On 05/10/2010 02:52 PM, Jiri Kosina wrote:
>>      
> [snip]
>    
>>> This sounds a bit strange.
>>>
>>> hidraw shouldn't be making too much difference in the case you describe.
>>> hidraw is basically just a mean of relaying HID events to userspace so
>>> that any driver/application in userspace can access them. But magicmouse
>>> driver is written completely in kernelspace.
>>>
>>> Does anything on your system have /dev/hidraw* nodes open? (you could
>>> check by lsof).
>>>
>>>        
>>
>> right now I see
>> /dev/hidraw0,1,2,3
>>
>> ./lsof | grep /dev
>> (showing bluetooth)
>>
>> bluetooth 2020   root    0u      CHR                1,3       0t0 2551
>> /dev/null
>> bluetooth 2020   root    1u      CHR                1,3       0t0 2551
>> /dev/null
>> bluetooth 2020   root    2u      CHR                1,3       0t0 2551
>> /dev/null
>> bluetooth 2020   root   14u      CHR              10,62       0t0 3895
>> /dev/rfkill
>>
>> I can try a bisect on this and see.
>>      
> A list of which patches you have applied would also be helpful.  The
> standard 2.6.33.* kernels predate the merge of the hid-magicmouse
> driver, but the dmesg entry you pasted makes it look like the driver was
> present.
>
> Michael Poole
>
>    
The only other thing that I remember
when adding hidraw was adding
BT_HCIUART_LL=m
(not sure if it matters or not).

here is dmesg:
http://fpaste.org/OiDf/

Justin P. Mattock

