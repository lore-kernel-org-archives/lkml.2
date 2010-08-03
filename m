Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076Ab0HCOnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 10:43:40 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47318 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756153Ab0HCOnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 10:43:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Jf1y2dYsEczo04LA/w7HgiPvAumDS2rRlJ7zCxoUSVIhrBacMgW7oBwJnHix8LD+9I
         8+Z7coVe0Ox0oVTkWqmVDI9xxONgF5Cbn6VTrJsLgg5tIqVBC7U/CcrAzYiKsmARcE4c
         dQlB6RM6AclvF0kVLjtQcGNPd7gO+Ifnkj/SA=
Message-ID: <4C582B2B.3080804@gmail.com>
Date: Tue, 03 Aug 2010 07:43:55 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Valdis.Kletnieks@vt.edu, linux-usb@vger.kernel.org,
        dbrownell@users.sourceforge.net, gregkh@suse.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2]drivers/usb/core/sysfs.c Fix variable 'retval' set
 but not used
References: <Pine.LNX.4.44L0.1008031027250.1853-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1008031027250.1853-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2010 07:29 AM, Alan Stern wrote:
> On Tue, 3 Aug 2010 Valdis.Kletnieks@vt.edu wrote:
>
>> On Mon, 02 Aug 2010 21:26:28 PDT, "Justin P. Mattock" said:
>>> diff --git a/drivers/usb/core/sysfs.c b/drivers/usb/core/sysfs.c
>>
>>>   	if (alt->string)
>>> -		retval = device_create_file(&intf->dev,&dev_attr_interface);
>>> +		device_create_file(&intf->dev,&dev_attr_interface);
>>>   	intf->sysfs_files_created = 1;
>>>   	return 0;
>
> Justin, did you try compiling your new code?  Those unused values are
> there because device_create_file is declared as __must_check.
>

I went as far as compiling, once I saw no warning then figured o.k
I'll send out what I have for feedback then go from there.
(and just for the record I want to thank those who took the time to go 
through and give feedback).


>> What should the code do if device_create_file() manages to fail? Yes, ignoring
>> the return value is one option, but is it the best one?  'return ret;' might be
>> another one. Somebody who understands this code and has more caffeine than me
>> should look this over.
>
> Failure to create a file in sysfs is almost never fatal and usually not
> even dangerous.  Ignoring the error is generally better than failing
> the entire operation.
>
> Alan Stern
>
>

ahh.. you made this more clear for me.. cool thanks!

Justin P. Mattock
