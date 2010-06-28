Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab0F1Rvy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 13:51:54 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:49469 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab0F1Rvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 13:51:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=cvGlYEacV2KKGX6VaNCNQyUReqxXZl87ESqJgNC8FIzwDE8ylh9t2sEjtxMcO/8cEi
         9H6rlMJdhEORd15zp+fzCSAfFOuTBPz4slmho4lc4cbnFkbRKQjiwmy/qhw0kmRNJzeG
         Nn34hREgXTDf8FNaMB6+wVkM000v9oI87fvz0=
Message-ID: <4C28E14D.5050701@gmail.com>
Date: Mon, 28 Jun 2010 10:52:13 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: linux-kernel@vger.kernel.org, sds@tycho.nsa.gov, lenb@kernel.org,
       linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH 3/5]acpi:glue.c Fix warning: variable 'ret' set but not
 used
References: <1277621246-10960-4-git-send-email-justinmattock@gmail.com> <1277621246-10960-1-git-send-email-justinmattock@gmail.com> <7214.1277729293@redhat.com>
In-Reply-To: <7214.1277729293@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2010 05:48 AM, David Howells wrote:
> Justin P. Mattock<justinmattock@gmail.com>  wrote:
>
>> +		if (ret) {
>> +			printk(KERN_WARNING "dev%d: Failed to get exception\n", ret);
>> +		}
>
> That's not a good warning because it's a meaningless string and you're passing
> the error number to the dev%d.
>
> Better would perhaps be:
>
> 	"dev%d: Failed to create physical_node sysfs link: %d\n"
>

I'll throw that in.

> Note also that you're only checking the result of one sysfs_create_link().
> You should probably check both.
>

this is where I get confused with: &acpi_dev->dev.kobj, &dev->kobji
it's like a criss cross of code

> Also you're introducing a pair of unnecessary braces as there's only one
> statement in the if-body.
>
> David
>

would just removing ret be good or will things go out of whack because 
of no ret

Justin P. Mattock
