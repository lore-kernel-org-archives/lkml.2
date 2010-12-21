Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab0LUXgI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 18:36:08 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:48574 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab0LUXgG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 18:36:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Y1KA3Acqi5y5O+fRnkje1kNtuKNdeqFfwpq7tbL+B9VTLDrAs5RUulqIRpkJL9bKOV
         Tyg70pxR3n3Q+6f0m8Xd/1sCZ0Yy1yo4nnGS+csaIaNuJG8KLgknZ8jCIKqxnnPm65Np
         /+GHgtOfBjJgNaoYYNbO9CE0YVWH2kXEjrpT4=
MIME-Version: 1.0
In-Reply-To: <AANLkTikpHn4EkaTUznshMOAnhC9FfL5Yy9vZohvoy8cG@mail.gmail.com>
References: <AANLkTi=kX8NraxuLn-f=s=nqja71Ayq2kYwgG6gq+7YF@mail.gmail.com>
	<20101220214445.85816469.akpm@linux-foundation.org>
	<AANLkTikpHn4EkaTUznshMOAnhC9FfL5Yy9vZohvoy8cG@mail.gmail.com>
Date: Tue, 21 Dec 2010 15:36:04 -0800
Message-ID: <AANLkTinVHsVg0=S9T2A120MYjgOknVB_hXmkwAmjpv2D@mail.gmail.com>
Subject: Re: [PATCH] include/linux/unaligned: Pack the whole struct rather
 than just the field.
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Will Newton <will.newton@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>, stable@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 2:43 AM, Will Newton <will.newton@gmail.com> wrote:
> On Tue, Dec 21, 2010 at 5:44 AM, Andrew Morton
>>>  #include <linux/kernel.h>

>>>
>>> -struct __una_u16 { u16 x __attribute__((packed)); };
>>> -struct __una_u32 { u32 x __attribute__((packed)); };
>>> -struct __una_u64 { u64 x __attribute__((packed)); };
>>> +struct __una_u16 { u16 x; } __attribute__((packed));
>>> +struct __una_u32 { u32 x; } __attribute__((packed));
>>> +struct __una_u64 { u64 x; } __attribute__((packed));
>>>
>>
>> Yes, that was wrong.
>>
>> Do you think this bug affects 2.6.36 or earlier?

Interesting, I thought about this when modifying this awhile ago, and
was relying on this from the gcc manual:

packed
<snip>

    Specifying this attribute for struct and union types is equivalent
to specifying the packed attribute on each of the


^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
structure or union members. Specifying the -fshort-enums flag on the
line is equivalent to specifying the packed
attribute on all enum definitions.

What version of gcc was this?

So, no objection to specifying packed on the struct definition rather
than the member, it was only done that way
as that was what was there when I made some of the code common.

Harvey
