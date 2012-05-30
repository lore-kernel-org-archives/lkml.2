Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932387Ab2E3IwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 04:52:18 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:56566 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932264Ab2E3IwQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 04:52:16 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdXf6O249NttPgeQzWkGfLu_Ocod80ecXaaFy+SqZQNmcg@mail.gmail.com>
References: <20120420020013.GA19964@windriver.com>
	<CAMuHMdUUgysVqz226jhK42nvYNaX7yvexpqRjOPx0QpvzUwVXg@mail.gmail.com>
	<4FC38DBD.4070406@redhat.com>
	<CAMuHMdXf6O249NttPgeQzWkGfLu_Ocod80ecXaaFy+SqZQNmcg@mail.gmail.com>
Date: Wed, 30 May 2012 10:52:14 +0200
X-Google-Sender-Auth: 3X_dbMNH9-pymfB0mfjkQlz7Xw8
Message-ID: <CAMuHMdVOuUAnD5ygBNY-8GEQgX0FVhw3BX7XN7sKe1YVSCSLvw@mail.gmail.com>
Subject: Re: linux-next: triage for April 19, 2012
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>, Avi Kivity <avi@redhat.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kbuild people,

On Mon, May 28, 2012 at 5:04 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Mon, May 28, 2012 at 4:37 PM, Avi Kivity <avi@redhat.com> wrote:
>> On 05/25/2012 11:59 PM, Geert Uytterhoeven wrote:
>>> On Fri, Apr 20, 2012 at 4:00 AM, Paul Gortmaker
>>> <paul.gortmaker@windriver.com> wrote:
>>>> The parisc got borked by some kvm header shuffle it seems?
>>>> Now complaining about "file 'asm-generic/kvm_para.h' is not exported"
>>>> [ http://kisskb.ellerman.id.au/kisskb/buildresult/6137786/ ]
>>>
>>> Not only parisc.
>>>
>>> This breakage has now entered mainline:
>>>
>>> parisc deconfig http://kisskb.ellerman.id.au/kisskb/buildresult/6365677/
>>> m68k allmodconfig: http://kisskb.ellerman.id.au/kisskb/buildresult/6365681/
>>
>>
>> Does the following patch help?
>
> Thanks, that fixes it!
>
> Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
>
>> From: Avi Kivity <avi@redhat.com>
>> Date: Mon, 28 May 2012 17:35:22 +0300
>> Subject: [PATCH] KVM: Export asm-generic/kvm_para.h
>>
>> Prevents build failures on non-KVM archs.
>>
>> Signed-off-by: Avi Kivity <avi@redhat.com>
>> ---
>>  include/asm-generic/Kbuild |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/include/asm-generic/Kbuild b/include/asm-generic/Kbuild
>> index 53f91b1..2c85a0f 100644
>> --- a/include/asm-generic/Kbuild
>> +++ b/include/asm-generic/Kbuild
>> @@ -8,6 +8,7 @@ header-y += int-ll64.h
>>  header-y += ioctl.h
>>  header-y += ioctls.h
>>  header-y += ipcbuf.h
>> +header-y += kvm_para.h
>>  header-y += mman-common.h
>>  header-y += mman.h
>>  header-y += msgbuf.h

I just noticed include/asm-generic/Kbuild.asm already had

ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/kvm_para.h \
                  $(srctree)/include/asm-$(SRCARCH)/kvm_para.h),)
header-y  += kvm_para.h
endif

but this doesn't seem to work.

Kbuild people: which one is correct?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
