Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946Ab0GANlM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 09:41:12 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41965 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920Ab0GANlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 09:41:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=cdawjE17Z9Bqh57xeJH7KNwY8Cf9CYLXRbFHwON3tYlQdKPFkqY3kMMwj4ZaSIWWuD
         ZeGSM/4CEC8XKsm4Kyuvj45nNoU9C1BsvXWwUCiB2NVJIpICvo7MPiNezQ7IHN8zeoDn
         LXOWa7rmBd94C+ZxSP2uQKpUEZjdGg64CsNZo=
Message-ID: <4C2C9B0C.80004@gmail.com>
Date: Thu, 01 Jul 2010 06:41:32 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, lenb@kernel.org
Subject: Re: [PATCH 3/5]acpi:glue.c Fix warning: variable 'ret' set but not
 used
References: <4C2B9F49.8090304@gmail.com> <4C2A6B6C.1000306@gmail.com> <4C29674C.9070503@gmail.com> <4C28E14D.5050701@gmail.com> <1277621246-10960-4-git-send-email-justinmattock@gmail.com> <1277621246-10960-1-git-send-email-justinmattock@gmail.com> <7214.1277729293@redhat.com> <8066.1277750854@redhat.com> <22319.1277826461@redhat.com> <25800.1277889215@redhat.com> <16513.1277976706@redhat.com>
In-Reply-To: <16513.1277976706@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2010 02:31 AM, David Howells wrote:
> Justin P. Mattock<justinmattock@gmail.com>  wrote:
>
>> +		if (fn) {
>> +			dev_warn(&acpi_dev->dev,
>> +				"Failed to create firmware_node link to %s %s: %d\n",
>> +				dev_driver_string(dev), dev_name(dev), fn);
>> +		} else if (pn) {
>> +			dev_warn(&acpi_dev->dev,
>> +				"Failed to create physical_node link to %s %s: %d\n",
>> +				dev_driver_string(dev), dev_name(dev), pn);
>> +				return AE_ERROR;
>> +		}			
>
> There's one more question to ask yourself: do you really need two dev_warn()
> statements?  You could have just one that prints both error values:
>
> 		if (fn || pn)
> 			dev_warn(&acpi_dev->dev,
> 				 "Failed to create link(s) to %s %s:"
> 				 " fn=%d pn=%d\n",
> 				 dev_driver_string(dev), dev_name(dev),
> 				 fn, pn);

ah... I did think about that a few days ago, but had no idea how to 
really follow through with this.. and from looking at what you did, it's 
as simple as  a || b

>
> Not sure it's worth going that far.  You could reduce it still further:
>
> 		if (fn || pn)
> 			dev_warn(&acpi_dev->dev,
> 				 "Failed to create link(s) to %s %s:"
> 				 " %d\n",
> 				 dev_driver_string(dev), dev_name(dev),
> 				 fn ?: pn);

I don't mind resending with your change to this.

>
> Is it that important to know which failed to be created, or that both failed
> to be created?
>
> David
>

maybe a simple test(prog) case can be created to simulate what this is 
doing, just to make sure.

Justin P. Mattock
