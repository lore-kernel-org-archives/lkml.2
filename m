Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932261Ab0EKCp0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 22:45:26 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:62817 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932114Ab0EKCpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 22:45:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=R4jPkBzdNF2qf8SlUyfpHOcqHcHs1lA2q5zo2xjsbset1pyBc2OeHjiBgXu/K1f233
         70WENjT7sNpGsMCliPxmYkBOO/Ru2VSsw+JrmJ9Yn2HbgQbjq0Ikr62es3yEjx9q5ntY
         oDE5x9hNHltP509CB812qsclMAwXOCiqkTjws=
Message-ID: <4BE8C4E5.5030906@gmail.com>
Date: Mon, 10 May 2010 19:45:57 -0700
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
I'm using the latest HEAD, without any patches
applied. (I'll send a post with dmesg after this post).

Justin P. Mattock
