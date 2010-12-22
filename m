Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531Ab0LVKev (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 05:34:51 -0500
Received: from mail-px0-f179.google.com ([209.85.212.179]:48430 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab0LVKeu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 05:34:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=m9lS7rpxzU+5SrPsduRlay4JQRuR91k8nhdbT0+QlTDTbSBKA/8mjpzHYemLy7r676
         lnfMbDEPX0TZZ0Wphnh7oflYkU0sSw7vfS6WKx7OZHmZDqE9p1VyOAsCQ8WsH4IJEW0f
         zViwI26foLIUVDOoLEP57P8BQaIKsar7eqGhg=
MIME-Version: 1.0
In-Reply-To: <AANLkTinVHsVg0=S9T2A120MYjgOknVB_hXmkwAmjpv2D@mail.gmail.com>
References: <AANLkTi=kX8NraxuLn-f=s=nqja71Ayq2kYwgG6gq+7YF@mail.gmail.com>
	<20101220214445.85816469.akpm@linux-foundation.org>
	<AANLkTikpHn4EkaTUznshMOAnhC9FfL5Yy9vZohvoy8cG@mail.gmail.com>
	<AANLkTinVHsVg0=S9T2A120MYjgOknVB_hXmkwAmjpv2D@mail.gmail.com>
Date: Wed, 22 Dec 2010 10:34:49 +0000
Message-ID: <AANLkTimZOCWY4bAxo6WVn4R075zHZGr9NE3S9nRd407F@mail.gmail.com>
Subject: Re: [PATCH] include/linux/unaligned: Pack the whole struct rather
 than just the field.
From: Will Newton <will.newton@gmail.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 11:36 PM, Harvey Harrison
<harvey.harrison@gmail.com> wrote:
> On Tue, Dec 21, 2010 at 2:43 AM, Will Newton <will.newton@gmail.com> wrote:
>> On Tue, Dec 21, 2010 at 5:44 AM, Andrew Morton
>>>>  #include <linux/kernel.h>
>
>>>>
>>>> -struct __una_u16 { u16 x __attribute__((packed)); };
>>>> -struct __una_u32 { u32 x __attribute__((packed)); };
>>>> -struct __una_u64 { u64 x __attribute__((packed)); };
>>>> +struct __una_u16 { u16 x; } __attribute__((packed));
>>>> +struct __una_u32 { u32 x; } __attribute__((packed));
>>>> +struct __una_u64 { u64 x; } __attribute__((packed));
>>>>
>>>
>>> Yes, that was wrong.
>>>
>>> Do you think this bug affects 2.6.36 or earlier?
>
> Interesting, I thought about this when modifying this awhile ago, and
> was relying on this from the gcc manual:
>
> packed
> <snip>
>
>    Specifying this attribute for struct and union types is equivalent
> to specifying the packed attribute on each of the
>
>
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> structure or union members. Specifying the -fshort-enums flag on the
> line is equivalent to specifying the packed
> attribute on all enum definitions.

I think that's possibly a gcc documentation deficiency, it is
equivalent to adding the packed attribute to all the struct members
but *also* affects the assumed alignment of the struct.

Looking at the gcc svn it seems the documentation has been improved a
bit in this area.

> What version of gcc was this?

4.2.4
