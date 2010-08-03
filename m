Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab0HCNaL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 09:30:11 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39405 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab0HCNaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 09:30:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=iYK1o98nfPzG4O9SAuZrZUncIfoLUeCXHHYst/T5RadtsxbVam0jTeTcnpGG7z/839
         K1PECfmGm+Oc8DJCdgAwQkoRa/ZrO1+9wcrBzDfuAkO5AI7tyVFigybyqn/2wBdEFhtB
         BU+seGHHtB4/DkXYfIgOHpLWzaB2qOjLVnEMY=
Message-ID: <4C5819F0.3040104@gmail.com>
Date: Tue, 03 Aug 2010 06:30:24 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: linux-usb@vger.kernel.org, dbrownell@users.sourceforge.net, gregkh@suse.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2]drivers/usb/core/sysfs.c Fix variable 'retval' set
 but not used
References: <1280809589-23649-1-git-send-email-justinmattock@gmail.com> <58611.1280834905@localhost>
In-Reply-To: <58611.1280834905@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2010 04:28 AM, Valdis.Kletnieks@vt.edu wrote:
> On Mon, 02 Aug 2010 21:26:28 PDT, "Justin P. Mattock" said:
>> diff --git a/drivers/usb/core/sysfs.c b/drivers/usb/core/sysfs.c
>
>>   	if (alt->string)
>> -		retval = device_create_file(&intf->dev,&dev_attr_interface);
>> +		device_create_file(&intf->dev,&dev_attr_interface);
>>   	intf->sysfs_files_created = 1;
>>   	return 0;
>
> What should the code do if device_create_file() manages to fail? Yes, ignoring
> the return value is one option, but is it the best one?  'return ret;' might be
> another one. Somebody who understands this code and has more caffeine than me
> should look this over.
>
ignoring the return value is one option, but is it the best one? 
probably not. As for return ret; the option did cross my mind, but 
figured to do what I had done by removing the retval

> (Nothing personal Justin - it's just my opinion that *anytime* we have a patch
> that remove a check for a return code, it needs to justify that ignoring the
> return code is appropriate).
>

nothing personal taken.. in fact I agree with that whole paragraph. 
looking back I should of really explained why I was removing this code 
besides a warning message.

Thanks for the response and info on this..

Justin P. Mattock

