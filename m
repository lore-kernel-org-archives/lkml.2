Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837Ab0DNOip (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 10:38:45 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35491 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755808Ab0DNOio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 10:38:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ACvybz2S06FXz8o4aPcKVp0iUoTbakvzMsUgXjVTwqEeAenH8TEtbsSmpz0vNlJUhI
         /7Zjpu0HhhJr/5UKERZgBZ0oqaGNNEKXNdc/o+QimowkLi7021OnxHkJo0zVKMH5QzF2
         Fpd/pVKaL8A/AIGsVtNxDgBF7Wu9TJq5RtUuc=
Message-ID: <4BC5D3C0.3010008@gmail.com>
Date: Wed, 14 Apr 2010 07:40:00 -0700
From: "Justin P. mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION PATCH] vsprintf: increase sizeof precision in printf_spec
References: <20100414011336.16139.68030.stgit@paris.rdu.redhat.com>	 <1271208801.1555.12.camel@Joe-Laptop.home>	 <1271213041.3008.35.camel@dhcp235-240.rdu.redhat.com> <1271214102.1555.27.camel@Joe-Laptop.home>
In-Reply-To: <1271214102.1555.27.camel@Joe-Laptop.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2010 08:01 PM, Joe Perches wrote:
> On Tue, 2010-04-13 at 22:44 -0400, Eric Paris wrote:
>> On Tue, 2010-04-13 at 18:33 -0700, Joe Perches wrote:
>>> On Tue, 2010-04-13 at 21:13 -0400, Eric Paris wrote:
>>>> Patch ef0658f3de484bf9b173639cd47544584e01efa5 changed the precision field
>>>> from and int to an s8.  Problem is that we have code which uses a much larger
>>>> precision in the kernel.  An example would in the audit code where we have:
>>>>
>>>> vsnprintf(...,..., " msg='%.1024s'", (char *)data);
>>>>
>>>> which causes precision to be too large and end up truncating to nothing.
>>>> Raising the size of the precision fixes the audit system issue.  It also does
>>>> not affect the alignment of the struct according to pahole and is still
>>>> approprietely packed.
>>>
>>> I don't see how it could be appropriately packed.
>>
>> I was just saying there was no padding inside the struct, although you
>> are right about it now being longer than 64.
>
> Which is bad.
>
>> But what does __attribute__((packed)) buy us?
>
> It could force the size to be 64 bits on more platforms.
>
>> I'll gladly resend with u8 type and s16 precision if that's the best
>> solution.
>
> Reordering struct members to keep width and precision
> together seems appropriate.  The attribute may not be.
>
> struct printf_spec {
> 	u8 type;
> 	u8 flags;		/* flags to number() */
> 	u8 base;
> 	u8 qualifier;
> 	s16 field_width;	/* width of output field */
> 	s16 precision;		/* # of digits/chars */
> };
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


o.k. just added this patch from the first post,
and the avc's look complete.(I'll keep an eye on
nscd to make sure those avc's are complete as well).

looks good over here.

Justin P. Mattock
