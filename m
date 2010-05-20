Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978Ab0ETABo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 20:01:44 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34321 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab0ETABm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 20:01:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xScgt4iHbSKclDnfJiGbiqmUtA40UEq9l6wMOCflAiPzkdd4FpNZ2WTu3+UWk+/TrG
         XWWCvADhj+K51lX4wW5ryBIlBJ1Lt0pwWW6W0OAsC+lL6vBykKZnswqRDbiVvELsgS5n
         naD2boOETKqsyZlquL2qggLLCkliqfwX7lU0k=
MIME-Version: 1.0
In-Reply-To: <4BF46D9B.4090806@zytor.com>
References: <AANLkTimwxXtNnmBuDJxg3i72VwWuHmemjrr1iGqj4j8e@mail.gmail.com>
	 <4BF42296.1030905@oracle.com> <4BF4235D.3080904@zytor.com>
	 <AANLkTikYcu6fM3yLoYIZOGZXgsRUfCgJeWS51Sjo-Fny@mail.gmail.com>
	 <4BF46D9B.4090806@zytor.com>
Date: Wed, 19 May 2010 17:01:41 -0700
Message-ID: <AANLkTiltANJ9eaGBkfJJOyZ8skCxxOmkAs1UvCLB_YQ9@mail.gmail.com>
Subject: Re: [PATCH] Prevent reserving RAM in the region already reserved by 
	BIOS
From: Mathieu Rondonneau <mathieu.rondonneau@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai <yinghai.lu@oracle.com>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

it' s not in ISA space.
once loading the NVIDIA driver, the warnign oops shows up.
4K starting at 0x9f800 (i.e. to 0xa007ff) overlap with the ISA space
(starting at 0xa0000).

When I don' t load the driver, no oops.
So I am assuming nvidia driver request 4K of memory, that happens to
be available in the bios area.

I think that there is a check missing somewhere to report that
available RAM buffer is already reserved (by BIOS) so we need to get
it from somewhere else.

Does it make sense?
-Mathieu

On Wed, May 19, 2010 at 4:00 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 05/19/2010 03:58 PM, Mathieu Rondonneau wrote:
>> Thanks for the feedback.
>>
>> No, I don' t see any changes in the /proc/iomem.
>>
>> I am trying to prevent a ioremap of a 4K size on a non aligned 4K
>> address that is below the ISA_START_ADDRESS.
>>
>> The problem generates a oops about overlapping.
>> I have a fix which instruct to not to do any re-map if the section
>> name is "reserved".
>> Which is not really clean.
>> I am looking for a clean way to tell the ioremap function to not remap
>> bios reserved memory.
>> That' s why I thought the e820 would be a good start.
>>
>> I will continue looking into this. It does not crash the systems. A
>> warning generates the oops.
>>
>
> Why are you mapping a fixed-address in ISA space to begin with?
>
> Requests to a fixed address (as opposed to dynamic allocation) have to
> be granted even in reserved space -- after all, that's what the address
> might be reserved for!
>
>        -hpa
>
