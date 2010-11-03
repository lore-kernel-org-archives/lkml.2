Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464Ab0KCSfx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 14:35:53 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34127 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932197Ab0KCSfs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 14:35:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=hZ6+rFZ/29FO4kr0giUZb96dx3RYW1ZYVViEZdNBoWNHwx47IlNIR3Bbmg+2y34loJ
         S+hW+Wji015/ou0+7mYC10o525wlqJvtoWaSwA0aTpChuq9nudxdPkfzJRQQiW+3sVf4
         zJCqzPGpXxKNPw8AxBGxfQNyFoEc/TWlhEuKc=
MIME-Version: 1.0
Reply-To: trapdoor6@gmail.com
In-Reply-To: <AANLkTi=1GdZVYr2z6P7PfR-VKREVzk__1ZodO2nu4dNY@mail.gmail.com>
References: <AANLkTik=04z2thHBS3Z9n68QnTs=i8g8qTFtNT3jb8cg@mail.gmail.com>
	<20101103164840.GC4683@hack>
	<AANLkTi=1GdZVYr2z6P7PfR-VKREVzk__1ZodO2nu4dNY@mail.gmail.com>
Date: Wed, 3 Nov 2010 18:35:46 +0000
Message-ID: <AANLkTimY+xFht4qLw+gx-axhfmkqBuO+GUtkt1HuCVnM@mail.gmail.com>
Subject: Re: Pure kernel '2.6.37-rc1-00001-ge99d11d' shown as ~-dirty after compilation
From: trapDoor <trapdoor6@gmail.com>
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 3, 2010 at 5:07 PM, trapDoor <trapdoor6@gmail.com> wrote:
> On Wed, Nov 3, 2010 at 4:48 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
>> On Tue, Nov 02, 2010 at 08:26:59AM +0000, trapDoor wrote:
>>>,Hello,
>>>When I run 'make kernelrelease' on freshly cloned Linus' git tree it
>>>shows kernel version as: '2.6.37-rc1-00001-ge99d11d' - and that's
>>>correct.
>>>But after compilation it turned up '2.6.37-rc1-00001-ge99d11d-dirty'.
>>>
>>>I didn't apply any custom patches to my local tree between 'make
>>>kernelrelease' and compilation. What I only added - and before running
>>>'make kernelrelease' - were the following Radeon firmware blobs for my
>>>graphic card, which I placed in <kernel-source>/firmware/radeon/, in
>>>order to compile them in:
>>>REDWOOD_me.bin
>>>REDWOOD_pfp.bin
>>>REDWOOD_rlc.bin
>>>
>>>That's how I always did and none of the git-kernels I compiled before
>>>was referred to as '-dirty' due to the firmware blobs added manually.
>>>Also, the kernel version shown by 'make kernelrelease' never differed
>>>from the final kernel version after compilation. Of course assuming
>>>that no patches were applied in the meantime and no extra string was
>>>appended manually to the kernel version.
>>>
>>>So, what's this '-dirty' about?
>>>
>>
>> That means your git tree is not clean, since you placed new firmwares
>> into the source tree.
>>
>> --
>> Live like a child, think like the god.
>>
>
> OK, but then 'make kernelrelease' should produce the same '..-dirty'
> version, not just '2.6.37-rc1-00001-ge99d11d', shouldn't it?
>
> I always do the following steps in the same order:
> 1) first I place the firmware files in <kernel-src>/firmware/radeon
Obviously I do that only on freshly cloned git tree or on a kernel
unpacked from tarball. If I just update my git tree, the firmware
files will be already in place after previous configuration. And here
is interesting thing: neither of these commands ..
	make mrproper
	make distclean
.. will remove the firmware files I had put in place manually. After
doing 'make mrproper && make distclean' my tree should be clean. But
those firmwares still remain there (I always check as I need to built
them in and hence my .config refers to them). And if I run 'make
oldonfig && make kernelrelease' afterwards, it will come up with a
'non-dirty' version string. And this seems consistent: 'make mrproper
&& make distclean' tell me that my tree is clean despite the FW files
so 'make kernelrelease' gives me a clean version string as well - and
exactly the same version should be propagated after compilation (in
vmlinuz, initrd-img, grub entry, etc.). And that how it always worked
for me before

It's not that I think that a kernel with (only) firmware file(s) added
manually should be considered as clean because 'make kernelrelease'
tells me so - actually I always thought it wasis wrong. I just want to
have 'make kernelrelease' coming up with the same version name as I'll
get after compilation.


-- 
Thanks,
Tomasz
