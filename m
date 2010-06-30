Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836Ab0F3NVi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 09:21:38 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54760 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729Ab0F3NVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 09:21:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=VishjlHg3F7KwrczD9dF9pOwHFpDkqg7t2lltJfd2MIAzR/GPIGD5WC1CGqGykvg0J
         ShKHbvBSaUkM0C+cXCwQLfrBW0Uiy4Fd4rtgs5ay9bq3fxiWdmbB0vlPz3t89+yLH/lW
         AO7sgOBOc5O5oEQa6zFhiAndTM2H+Q4qFfRI8=
Message-ID: <4C2B44F6.7000808@gmail.com>
Date: Wed, 30 Jun 2010 06:21:58 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, lenb@kernel.org
Subject: Re: [PATCH 3/5]acpi:glue.c Fix warning: variable 'ret' set but not
 used
References: <4C2A6B6C.1000306@gmail.com> <4C29674C.9070503@gmail.com> <4C28E14D.5050701@gmail.com> <1277621246-10960-4-git-send-email-justinmattock@gmail.com> <1277621246-10960-1-git-send-email-justinmattock@gmail.com> <7214.1277729293@redhat.com> <8066.1277750854@redhat.com> <22319.1277826461@redhat.com> <25800.1277889215@redhat.com>
In-Reply-To: <25800.1277889215@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2010 02:13 AM, David Howells wrote:
> Justin P. Mattock<justinmattock@gmail.com>  wrote:
>
>>   	if (!ACPI_FAILURE(status)) {
>> -		int ret;
>>
>> -		ret = sysfs_create_link(&dev->kobj,&acpi_dev->dev.kobj,
>> +		fn = sysfs_create_link(&dev->kobj,&acpi_dev->dev.kobj,
>>   				"firmware_node");
>> -		ret = sysfs_create_link(&acpi_dev->dev.kobj,&dev->kobj,
>> +		pn = sysfs_create_link(&acpi_dev->dev.kobj,&dev->kobj,
>>   				"physical_node");
>> +	if (fn) {
>
> That new if-statement still needs indenting one more tab stop.  It's indented
> the same as the previous if-statement, but is actually in the body of that
> previous if-statement.
>
> The body of the second if-statement should be indented one tab beyond the if,
> and else/else-if statements and the final closing brace should be indented
> level with the if:
>
> 	if (...) {
> 		body;
> 	} else if (...) {
> 		body;
> 	} else {
> 		body;
> 	}
>
> so that they line up vertically.

Thanks for the info on this, I really appreciate it. I'll look at this 
today, and resend.
	

>
>> +		dev_warn(dev, "dev:%p Failed to create firmware_node: %d\n",
>> +			acpi_dev, fn);
>
> The "dev:%p " seems like it ought to be superfluous if you're using
> dev_warn(), and certainly, returning the pointer isn't really useful, I
> suspect.
>

I kept receiving an new warning for using acpi_dev the %p was the only 
option I saw in the Documentation that worked

> However, at this point you have two device struct pointers: dev and
> &acip_dev->dev, so printing them both is may be good.  Perhaps something like:
>
> +		dev_warn(&acpi_dev->dev,
> +			 "Failed to create firmware_node link to %s %s: %d\n",
> +			 dev_driver_string(dev), dev_name(dev), fn);
>
> David
>

o.k. I'll look at this today, and see if I can find/locate the device 
name and string for these.

Justin P. Mattock
