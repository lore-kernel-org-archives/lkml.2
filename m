Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754Ab0ESSb3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 14:31:29 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:40032 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab0ESSb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 14:31:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=tOrEj8IGYPW7Yj35wMxfTbFnFeobOy3k5BOaLoNU9n8LaY0LcCNen3uGCTB8nGh4Vu
         HlztBt6v/KQbhV4v/0ad0FofV0YY4uN3mNO36MvGWxm2tlOuhdShmY18RHxgQWLk8umN
         jj2fRVcQ4JuzxbMMGBnemzTzivAnZ/4Gs6i0M=
MIME-Version: 1.0
In-Reply-To: <AANLkTik0IjrVr-Cey0wumA5DpL5XutUwEtnp_1w2OQEY@mail.gmail.com>
References: <AANLkTil73ArhX2w6b_v1bmWjP1FA5zUTfPzK2N4waOu1@mail.gmail.com>
	 <AANLkTik0IjrVr-Cey0wumA5DpL5XutUwEtnp_1w2OQEY@mail.gmail.com>
Date: Wed, 19 May 2010 20:31:25 +0200
Message-ID: <AANLkTik4gyHBrCAfnVogj-DiEHkp3b1OlSYcja1pJ83R@mail.gmail.com>
Subject: Re: [ANNOUNCE] GSoC project: Improving kconfig using a SAT solver
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       Bart Massey <bart@cs.pdx.edu>, Michal Marek <mmarek@suse.cz>,
       Greg Kroah-Hartman <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>,
       James Bottomley <James.Bottomley@hansenpartnership.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 May 2010 13:05, Felipe Contreras <felipe.contreras@gmail.com> wrote:
> On Mon, May 17, 2010 at 3:02 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
>> Hi,
>>
>> I just wanted to say that I've been accepted into this year's Google
>> Summer of Code program and will spend this summer working on improving
>> the kconfig system in a very particular direction: I want to integrate
>> a proper boolean constraint satisfiability solver into the
>> configuration editors (menuconfig, etc.) in order to allow
>> partial/incomplete configuration specifications. In short, this means
>> that the user can choose to not specify a particular value for some
>> config options, but let the system deduce their values. This will
>> hopefully improve usability and also solve the select problem once and
>> for all.
>
> Very nice! I thought on this idea too.
>
> Does this means that if you have a pristine kernel, and you do 'make
> menuconfig' and don't change anything, the .config file will be empty?
> And then, anything that you change will be in the .config file?
>

Yes and no -- I think the plan is to retain the .config file as it is
(i.e. it specifies more or less every option completely), so that it
remains backwards compatible; bisection, for example, is very
important. But yes, I think there will be a new file, say, .satconfig,
which contains only the specific choices of the user. And this one
would be empty, as you say, with a pristine kernel.

I think, then, that the .config file will be regenerated from the
.satconfig one each time .satconfig changes.

> On another case I do 'make ARCH=arm omap3_beagle_defconfig' then my
> .config file will point to that particular defconfig, and I can add
> only the changes that I want. Also, omap3_beagle_defconfig probably
> points omap3_defconfig and only makes certain changes.
>
> If so, that would be awesome :)

Do you mean essentially a sort of cascade of configurations that
inherit options from a different file? That shouldn't be very hard to
do -- I'll make a note of it for when I get that far! That has the
potential to make the defconfig files a bit shorter and more
manageable (not sure how big a problem that is in practice today,
though).

Thanks,


Vegard
