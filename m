Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104Ab0GNKAH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 06:00:07 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33271 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895Ab0GNKAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 06:00:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=gF9L+366BS7M/tLg4ZQojnfZW0J6iXbNmKKc4NnvlWunqLvlPftg4CPSuPP5pNpCRd
         DzrR71ZCMS1qAuaykOXI+t5+B4oMN6frw0yZalHvfI8YSK7MqXebZ4ZUSYeXtCQlGWyp
         dbZ/XwPmTLRPqN6+E5/Xed//XP3biygxdHpoY=
MIME-Version: 1.0
In-Reply-To: <4C3D89AC.4040303@cs.helsinki.fi>
References: <AANLkTil6opQmTVVxuP1ngz72_ijpLzdlSFWDSyi4whOt@mail.gmail.com>
	<AANLkTinGoUml9PQ8w7flukqwF9V1ae-YafiDVQy6Q8gC@mail.gmail.com>
	<AANLkTimgn1Xa0YIwjC6xOfNDjlqJSQYy65ZvqCtlMWHD@mail.gmail.com>
	<1279100846.8592.53.camel@e102109-lin.cambridge.arm.com>
	<4C3D89AC.4040303@cs.helsinki.fi>
Date: Wed, 14 Jul 2010 12:00:02 +0200
Message-ID: <AANLkTikYlpkN6dc_BdQqsxIa-kyFmQQWJpNqqjC-p7Fw@mail.gmail.com>
Subject: Re: kmemleak, cpu usage jump out of nowhere
From: Zeno Davatz <zdavatz@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 11:55 AM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> Catalin Marinas wrote:
>>
>> On Wed, 2010-07-14 at 09:27 +0100, Zeno Davatz wrote:
>>>
>>> On Wed, Jul 14, 2010 at 10:05 AM, Pekka Enberg <penberg@cs.helsinki.fi>
>>> wrote:
>>>>
>>>> On Wed, Jul 14, 2010 at 9:12 AM, Zeno Davatz <zdavatz@gmail.com> wrote:
>>
>>>>> I am attaching you the file from /sys/kernel/debug/kmemleak
>>>>
>>>> Zeno, can you post your dmesg and .config, please?
>>>
>>> Sure, see attached files.
>>
>> It looks like NO_BOOTMEM is enabled. You can try the attached patch (I
>> need to post it again on the list).
>>
>>
>> kmemleak: Add support for NO_BOOTMEM configurations
>>
>> From: Catalin Marinas <catalin.marinas@arm.com>
>>
>> With commits 08677214 and 59be5a8e, alloc_bootmem()/free_bootmem() and
>> friends use the early_res functions for memory management when
>> NO_BOOTMEM is enabled. This patch adds the kmemleak calls in the
>> corresponding code paths for bootmem allocations.
>>
>> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Yinghai Lu <yinghai@kernel.org>
>> Cc: H. Peter Anvin <hpa@zytor.com>
>
> Makes sense.
>
> Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
>
> Zeno, this should fix the kmemleak false positives but not the big pauses
> you're seeing.

Thank for this detailed info Pekka! I will not apply the patch at the
moment. Will it be in with the next RC from Linus? Or do you recommend
I apply it?

What I want it is to tame the temper of Tux and restrict him from
eating my CPU-donuts (cores) at random. I need them for other
processes. ;)

Best
Zeno
