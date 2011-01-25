Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298Ab1AYBi5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 20:38:57 -0500
Received: from smtp-out.google.com ([74.125.121.67]:28042 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab1AYBiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 20:38:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=RT4EwQ5CezXt8jHMSd+Jd8ILeoeBydwN7s7Lkjg9wuXfyhahKMQaO9K7erTyNk9FcX
         zIvJ1UQB5pbBHQxcLPwA==
Message-ID: <4D3E29A8.7030209@google.com>
Date: Mon, 24 Jan 2011 17:38:48 -0800
From: Mike Waychison <mikew@google.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Greg KH <greg@kroah.com>, torvalds@linux-foundation.org,
        San Mehat <san@google.com>, Aaron Durbin <adurbin@google.com>,
        Duncan Laurie <dlaurie@google.com>, linux-kernel@vger.kernel.org,
        Tim Hockin <thockin@google.com>
Subject: Re: [PATCH v1 4/6] driver: Google Bootlog
References: <20110125002433.12637.51091.stgit@mike.mtv.corp.google.com>	<20110125002454.12637.4700.stgit@mike.mtv.corp.google.com> <20110125004953.3e838962@lxorguk.ukuu.org.uk>
In-Reply-To: <20110125004953.3e838962@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/11 16:49, Alan Cox wrote:
>> +/*
>> + * Search for the BLOG pointer.
>> + */
>> +static struct bootlog_ptr * __init bootlog_find_pointer(void)
>> +{
>> +	unsigned long address, length, cur;
>> +	struct bootlog_ptr *bp;
>> +
>> +	/* EBDA pointer contains segment the extended BIOS data area */
>> +	address = *(uint16_t *)phys_to_virt(BLOG_EBDA_POINTER);
>> +	address<<= 4;	/* convert segment to physical address */
>> +
>> +	/* EBDA length is byte 0 of the EBDA (stored in kB) */
>> +	length = *(uint8_t *)phys_to_virt(address);
>> +	length<<= 10;	/* convert to bytes */
>
> Ok this is wrong on two counts
>
> 1.	If the EBDA pointer is zero then no EBDA is present (older
> boxes sometimes did this up to about the Athlon era).
>
> 2.	EBDA isn't an X86 property it's a PC property. asm/bios_ebda
> provides one helper and perhaps it all belongs in there (along with 'is
> it a PC' sanity check)

It's not obvious to me how one would make that sort of check (is a PC) 
at runtime. Suggestions?

>
> 3.	And its probably a good idea given the standard of BIOS code to
> also check the EBDA end if given is actually within the 640K limit ...
>
>
>
> Alan

