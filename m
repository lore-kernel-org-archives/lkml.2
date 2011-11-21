Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab1KUSZz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 13:25:55 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58191 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748Ab1KUSZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 13:25:51 -0500
Message-ID: <4ECA97A0.3090005@gmail.com>
Date: Mon, 21 Nov 2011 10:25:36 -0800
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>
CC: linux-mips@linux-mips.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-embedded@vger.kernel.org, x86@kernel.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH RFC 1/5] scripts: Add sortextable to sort the kernel's
 exception table.
References: <1321645068-20475-1-git-send-email-ddaney.cavm@gmail.com> <1321645068-20475-2-git-send-email-ddaney.cavm@gmail.com> <201111201822.13614.vapier@gentoo.org>
In-Reply-To: <201111201822.13614.vapier@gentoo.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2011 03:22 PM, Mike Frysinger wrote:
> On Friday 18 November 2011 14:37:44 David Daney wrote:
>> --- /dev/null
>> +++ b/scripts/sortextable.c
>>
>> +/*
>> + * sortextable.c: Sort the kernel's exception table
>> + *
>> + * Copyright 2011 Cavium, Inc.
>> + *
>> + * Based on code taken from recortmcount.c which is:
>
> seems like it'd be nice if the duplicate helper funcs were placed in a common
> header file rather than copying&  pasting between them.
>

Yes, I may try to factor out some common code if we decide to move 
forward with the patch set.


>> +	switch (w2(ehdr->e_machine)) {
>> +	default:
>> +		fprintf(stderr, "unrecognized e_machine %d %s\n",
>> +			w2(ehdr->e_machine), fname);
>> +		fail_file();
>> +		break;
>> +	case EM_386:
>> +	case EM_MIPS:
>> +	case EM_X86_64:
>> +		break;
>> +	}  /* end switch */
>
> unlike recordmcount, this file doesn't do anything arch specific.  so let's just
> delete this and be done.

Not really true at this point.  We don't know the size or layout of the 
architecture specific exception table entries, likewise for 
CONFIG_ARCH_HAS_SORT_EXTABLE, we don't even know how to do the comparison.

I was trying to be a little conservative and only apply the build time 
sort to configurations that I could test.

David Daney
