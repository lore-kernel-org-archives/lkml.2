Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933558Ab0FCCB1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 22:01:27 -0400
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:26959 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933518Ab0FCCBZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 22:01:25 -0400
X-Loopcount0: from 10.166.62.177
From: <Rezwanul_Kabir@Dell.com>
To: <mjg59@srcf.ucam.org>, <pharon@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <platform-driver-x86@vger.kernel.org>,
       <akpm@linux-foundation.org>
Date: Wed, 2 Jun 2010 20:57:10 -0500
Subject: RE: Dell Studio 1555 eject key does not work ( small patch to fix
	included )
Thread-Topic: Dell Studio 1555 eject key does not work ( small patch to fix
	included )
Thread-Index: AcsCm2s5qEY+gFUASs6unUg6QrV25AAIn5+Q
Message-ID: <57DF5FDC2DC0634FA2A310BC5B81A68D01DF4CD01E@AUSX7MCPC108.AMER.DELL.COM>
References: <AANLkTinG3jv6o8T00mDTEP5uxf4tKqOwSPEDIUcv4kVG@mail.gmail.com>
 <20100602213429.GA14866@srcf.ucam.org>
In-Reply-To: <20100602213429.GA14866@srcf.ucam.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 03 Jun 2010 01:57:12.0771 (UTC) FILETIME=[157D7130:01CB02C0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>Hi Rez,
>
>Any thoughts on this?
>


 From the discussion below, it seems that this system does not implement the new
WMI scheme ( which is when dell_new_hk_type=true is set). So, at issue here is the
legacy code. Without knowing exactly why BIOS would behave differently in this particular case,
the fix seems arbitrary. Let me see if I can get hold of the BIOS developer(if possible) and provide feedback in this thread.

Islam Amer

   Can you attach dmidecode output from the system here?

Thanks..
   --rez


  


>On Thu, Jun 03, 2010 at 01:14:09AM +0400, Islam Amer wrote
>> Hello,
>> 
>> Pressing the eject key on my Dell Studio 1555 does not work 
>and dmesg 
>> produces this message :
>> dell-wmi: Unknown key 0 pressed
>> 
>> Adding a debugging printk in dell-wmi.c after line 222 like this :
>> 
>> printk(KERN_INFO "dell:wmi 0x%x , 0x%x \n", buffer_entry[1], 
>> buffer_entry[2]);
>> 
>> dmesg now shows :
>> 
>> dell:wmi 0x0 , 0xe009
>> dell-wmi: Unknown key 0 pressed
>> 
>> So for some reason buffer_entry[1] is used although it is empty.
>> 
>> Falling back to buffer_entry[2] in case buffer_entry[1] is 0x0 makes 
>> the button work.
>> 
>> I suspect it might be better to fix the "dell_new_hk_type" logic 
>> though
>> 
>> I had submitted this as
>> https://bugzilla.kernel.org/show_bug.cgi?id=16075 but repeating the 
>> information and patch here as per Andrew Morton's suggestion.
>> 
>> 
>> Thanks.
>> 
>> --- 
>linux-sidux-2.6-2.6.34/drivers/platform/x86/dell-wmi.c.orig	
>2010-06-03
>> 01:02:17.418824168 +0400
>> +++ linux-sidux-2.6-2.6.34/drivers/platform/x86/dell-wmi.c	
>2010-06-03
>> 01:01:40.641833249 +0400
>> @@ -221,7 +221,7 @@ static void dell_wmi_notify(u32 value, v
>>  			return;
>>  		}
>> 
>> -		if (dell_new_hk_type)
>> +		if (dell_new_hk_type || buffer_entry[1] == 0x0)
>>  			reported_key = (int)buffer_entry[2];
>>  		else
>>  			reported_key = (int)buffer_entry[1] & 0xffff;
>> 
>--
>Matthew Garrett | mjg59@srcf.ucam.org
>