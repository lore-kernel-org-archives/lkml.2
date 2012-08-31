Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890Ab2HaChR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 22:37:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49679 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051Ab2HaChP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 22:37:15 -0400
References: <1346319009.951368.767015086462.1.gpush@pecola> <503FA15F.7070506@zytor.com> <50400859.2080606@canonical.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <50400859.2080606@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [RFC,PATCH] efi: Add support for a UEFI variable filesystem
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 30 Aug 2012 19:36:48 -0700
To: Jeremy Kerr <jeremy.kerr@canonical.com>
CC: linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Matt Domsch <Matt_Domsch@Dell.com>
Message-ID: <5e40036f-b0da-47f3-acba-5dea9fdb7ed6@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wouldn't that be better handled by O_APPEND?



Jeremy Kerr <jeremy.kerr@canonical.com> wrote:

>Hi hpa,
>
>Thanks for the review!
>
>> However, I have a question... rather than putting the attributes as
>the
>> first data bytes, would it be better to make it either part of the
>> filename (assuming there is at least one character other than / which
>> can be reasonably relied upon to not be part of the name); for
>example:
>>
>> 	LangCodes,BS,RT
>>
>> ... or ...
>>
>> 	LangCodes,6
>
>This will get tricky when handling EFI_VARIABLE_APPEND_WRITE: this 
>attribute will never appear in the attributes returned by
>GetVariable(), 
>but may be passed to SetVariable(). If we put attributes in the 
>filename, we'd need to handle writes to both names, and/or have 
>duplicate dentries for each variable. We could do it, but the
>filesystem 
>interface might be a little messy.
>
>[Supporting append writes is essential for key database updates, which 
>may be signed]
>
>Cheers,
>
>
>Jeremy

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
