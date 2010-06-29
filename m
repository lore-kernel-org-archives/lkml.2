Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667Ab0F2ROX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 13:14:23 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42739 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917Ab0F2ROV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 13:14:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=FDGkqCudzAyoJCAJIAf7uPEFUZ8uq/BvcfhAqUzc1sBgHm7NVdN+P9XYgE6X3S5thW
         1UFi4mq4kC9zOKMejymAPMS/F/C7LnuPr6ZQaDz68/KKYPS2iPgrr0GqOSIiK21GRZSq
         Yhj7yzkLVHjT7AO7YqFrP2rKTG3v+RIIV8hxc=
Message-ID: <4C2A2A01.9010307@gmail.com>
Date: Tue, 29 Jun 2010 10:14:41 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, lenb@kernel.org
Subject: Re: [PATCH 3/5]acpi:glue.c Fix warning: variable 'ret' set but not
 used
References: <4C29674C.9070503@gmail.com> <4C28E14D.5050701@gmail.com> <1277621246-10960-4-git-send-email-justinmattock@gmail.com> <1277621246-10960-1-git-send-email-justinmattock@gmail.com> <7214.1277729293@redhat.com> <8066.1277750854@redhat.com> <22319.1277826461@redhat.com>
In-Reply-To: <22319.1277826461@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2010 08:47 AM, David Howells wrote:
> Justin P. Mattock<justinmattock@gmail.com>  wrote:
>
>> +	if (fn) {
>> + 			printk(KERN_WARNING "dev%d: Failed to create
>> firmware_node: %d\n", status, fn);
>> +	}else if (pn) {
>> +			printk(KERN_WARNING "dev%d: Failed to create
>> physical_node: %d\n", status, pn);
>> + 			return 0;
>> +		}
>
> The if-statement should be correctly indented (it's inside another
> if-body, so needs to be one more tab over) and there needs to be a space
> before the else.
>
o.k., so it should look something like this:
if (fn) {
	code...
	} else if (pn) {


> You should probably split your printks up so they don't exceed 80 chars too,
> for example:
>
> 			printk(KERN_WARNING
> 			       "dev%d: Failed to create physical_node: %d\n",
> 			       status, pn);
>
> Also 'status' is probably the wrong thing to print as the number in "dev%d".
> If it worked, that should be unconditionally AE_OK, I think.  Can you not use
> dev_warn() or similar instead or printk?
>
> David
>

alright, I'll look at this today. I'm not the best at making printks in 
fact I'm more intimidated by them..(so with this in mind, I'm going to 
sit and make myself learn this, so I atleast have a better idea of doing 
these than I have now.)

Justin P. Mattock








