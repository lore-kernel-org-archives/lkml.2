Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933508Ab0GOPPn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 11:15:43 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58552 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933418Ab0GOPPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 11:15:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=OIA/rgLpW1sKzMruYdbqrlMqfRIbVrAYLz+L732VpaRO56Dw9/pzKU1gtYQfk7fyE/
         zBWmCujT+OL8QuJB0vBvVWOuJUg76WsTMj+ecVPtJffpHI+d0sziwzPHlQFxGI5fsW0T
         qsGDNQ00w4o29biHPwk3ipCUROLDBjPdRncV4=
MIME-Version: 1.0
In-Reply-To: <1279205891.6664.46.camel@e102109-lin.cambridge.arm.com>
References: <AANLkTil6opQmTVVxuP1ngz72_ijpLzdlSFWDSyi4whOt@mail.gmail.com>
	<AANLkTinGoUml9PQ8w7flukqwF9V1ae-YafiDVQy6Q8gC@mail.gmail.com>
	<AANLkTimgn1Xa0YIwjC6xOfNDjlqJSQYy65ZvqCtlMWHD@mail.gmail.com>
	<1279100846.8592.53.camel@e102109-lin.cambridge.arm.com>
	<4C3D89AC.4040303@cs.helsinki.fi>
	<1279205891.6664.46.camel@e102109-lin.cambridge.arm.com>
Date: Thu, 15 Jul 2010 17:15:40 +0200
Message-ID: <AANLkTikJeA-bZEk652QwwT4iY21v5tr6RCzcZAZGgS8D@mail.gmail.com>
Subject: Re: kmemleak, cpu usage jump out of nowhere
From: Zeno Davatz <zdavatz@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Catalin

On Thu, Jul 15, 2010 at 4:58 PM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> On Wed, 2010-07-14 at 10:55 +0100, Pekka Enberg wrote:
>> Catalin Marinas wrote:
>> > On Wed, 2010-07-14 at 09:27 +0100, Zeno Davatz wrote:
>> >> On Wed, Jul 14, 2010 at 10:05 AM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
>> >>> On Wed, Jul 14, 2010 at 9:12 AM, Zeno Davatz <zdavatz@gmail.com> wrote:
>> >
>> >>>> I am attaching you the file from /sys/kernel/debug/kmemleak
>> >>> Zeno, can you post your dmesg and .config, please?
>> >> Sure, see attached files.
>> >
>> > It looks like NO_BOOTMEM is enabled. You can try the attached patch (I
>> > need to post it again on the list).
>> >
>> >
>> > kmemleak: Add support for NO_BOOTMEM configurations
>> >
>> > From: Catalin Marinas <catalin.marinas@arm.com>
>> >
>> > With commits 08677214 and 59be5a8e, alloc_bootmem()/free_bootmem() and
>> > friends use the early_res functions for memory management when
>> > NO_BOOTMEM is enabled. This patch adds the kmemleak calls in the
>> > corresponding code paths for bootmem allocations.
>> >
>> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
>> > Cc: Yinghai Lu <yinghai@kernel.org>
>> > Cc: H. Peter Anvin <hpa@zytor.com>
>>
>> Makes sense.
>>
>> Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
>
> I'll post an updated patch since I missed a callback. I've been testing
> it since yesterday and seems ok.

I also did not have anymore hangs and random bad moods of my CPUs that
all of a sudden grab 100% of all 8 cores of my CPU power across my
machine since I disabled

CONFIG_NO_BOOTMEM:

Best
Zeno
