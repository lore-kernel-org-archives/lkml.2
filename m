Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758662Ab0GOUwb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 16:52:31 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62481 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab0GOUw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 16:52:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=EjAs09INMmvUHffF/5kRDC1PmLUymKGFYxYrmqfzEw2YpCclCQtZJ+1tS4+IV4Wj2E
         OXLHz3pgkWtCdwtyieJYSYC9PzvoVCuLnsVQr/oALq0g1Qkn/60PMvKRBhT8XtEZ4AcV
         pYbrbKINJrfIHibWphSr5S/1vG0VQwtrgKBtg=
MIME-Version: 1.0
In-Reply-To: <20100715200012.GA4175@brouette>
References: <AANLkTinGoUml9PQ8w7flukqwF9V1ae-YafiDVQy6Q8gC@mail.gmail.com>
	<AANLkTimgn1Xa0YIwjC6xOfNDjlqJSQYy65ZvqCtlMWHD@mail.gmail.com>
	<1279100846.8592.53.camel@e102109-lin.cambridge.arm.com>
	<4C3D89AC.4040303@cs.helsinki.fi>
	<1279205891.6664.46.camel@e102109-lin.cambridge.arm.com>
	<AANLkTikJeA-bZEk652QwwT4iY21v5tr6RCzcZAZGgS8D@mail.gmail.com>
	<4C3F2F52.2050101@cs.helsinki.fi>
	<20100715162805.GA10240@brouette>
	<20100715191638.GA3694@brouette>
	<AANLkTim7SURv8DPTLC2JwOJvv1WMAR4mmyBp9XqXw_Py@mail.gmail.com>
	<20100715200012.GA4175@brouette>
Date: Thu, 15 Jul 2010 23:52:25 +0300
X-Google-Sender-Auth: rAbu1MZgK4G6gkoeq8LK-XblVkI
Message-ID: <AANLkTilnLXVSkWfnaPtpzxH-C3-5h1mnBz3O0vAFHG32@mail.gmail.com>
Subject: Re: kmemleak, cpu usage jump out of nowhere
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Damien Wyart <damien.wyart@free.fr>
Cc: Zeno Davatz <zdavatz@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        mingo@elte.hu, yinghai@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 15, 2010 at 11:00 PM, Damien Wyart <damien.wyart@free.fr> wrote:
>> > For now, I can't reproduce the problem with CONFIG_NO_BOOTMEM disabled ;
>> > with the option and rc5 the problem was happening quite quickly after
>> > boot and normal use of the machine. So it seems I can confirme what Zeno
>> > has seen and I hope this will give a hint to debug the problem. I guess
>> > this has not been reported that much because many testers might not have
>> > enabled CONFIG_NO_BOOTMEM... Maybe the scheduler folks could test their
>> > benchmark with a kernel having this option enabled?
>
> * Pekka Enberg <penberg@cs.helsinki.fi> [2010-07-15 22:50]:
>> To be honest, the bug is bit odd. It's related to boot-time memory
>> allocator changes but yet it seems to manifest itself as a scheduling
>> problem. So if you have some spare time and want to speed up the
>> debugging process, please test v2.6.34 and v2.6.35-rc1 with
>> CONFIG_NO_BOOTMEM and if former is good and latter is bad, try to see
>> if you can identify the offending commit with "git bisect."
>
> Not sure I will have enough time in the coming days (doing that remotely
> is fishy since ssh access is almost stuck when the problem occurs); if
> Zeno can and would like to do it, maybe this could be done faster.
>
> As the scheduler is now very well instrumented (many debugging features
> are available), reproducing the bug on a test platform (it happens quite
> quickly for me) might also give some hints. So testers, if you have
> time, please test 2.6.35-rc5 with CONFIG_NO_BOOTMEM on a Core i7 and see
> if you can reproduce the problem!

Yeah, there's "perf sched" tool available for that:

  http://lwn.net/Articles/353295/

The only problem is that we'd need a scheduler hacker to decipher the
report and all of them seem to be missing at the moment (probably at
OLS). Anyway, like I said, git bisect will probably speed up the
debugging process, that's all.

                          Pekka
