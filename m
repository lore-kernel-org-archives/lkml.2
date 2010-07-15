Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934577Ab0GOTuJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 15:50:09 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53598 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934528Ab0GOTuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 15:50:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=jnpAqoeeUYt5Syy6W+p/yjkAVZxIMWA8whZrkv5Ed//J8kRDR0rIh1A67YU+bfCpsl
         oUAyNrHZxr98f5cJc53u6v9ZGDvIkE/rTEvG5RviRkvnxKAydGN7M/UEQKT5Kzs/c27z
         O5OmP9bwIXLKcJ82eBkG9NhtcqH3/xTZNGDS0=
MIME-Version: 1.0
In-Reply-To: <20100715191638.GA3694@brouette>
References: <AANLkTil6opQmTVVxuP1ngz72_ijpLzdlSFWDSyi4whOt@mail.gmail.com>
	<AANLkTinGoUml9PQ8w7flukqwF9V1ae-YafiDVQy6Q8gC@mail.gmail.com>
	<AANLkTimgn1Xa0YIwjC6xOfNDjlqJSQYy65ZvqCtlMWHD@mail.gmail.com>
	<1279100846.8592.53.camel@e102109-lin.cambridge.arm.com>
	<4C3D89AC.4040303@cs.helsinki.fi>
	<1279205891.6664.46.camel@e102109-lin.cambridge.arm.com>
	<AANLkTikJeA-bZEk652QwwT4iY21v5tr6RCzcZAZGgS8D@mail.gmail.com>
	<4C3F2F52.2050101@cs.helsinki.fi>
	<20100715162805.GA10240@brouette>
	<20100715191638.GA3694@brouette>
Date: Thu, 15 Jul 2010 22:50:02 +0300
X-Google-Sender-Auth: jvgbtA00PFRnOgeKMo0JTuiTPxY
Message-ID: <AANLkTim7SURv8DPTLC2JwOJvv1WMAR4mmyBp9XqXw_Py@mail.gmail.com>
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

On Thu, Jul 15, 2010 at 10:16 PM, Damien Wyart <damien.wyart@free.fr> wrote:
>> > > I also did not have anymore hangs and random bad moods of my CPUs
>> > > that all of a sudden grab 100% of all 8 cores of my CPU power across
>> > > my machine since I disabled
>> > > CONFIG_NO_BOOTMEM:
>
>> * Pekka Enberg <penberg@cs.helsinki.fi> [2010-07-15 18:54]:
>> > Interesting. Damien, does disabling CONFIG_NO_BOOTMEM fix you problem too?
>
>> I will test in the coming hours, and report back tomorrow... Just
>> recompiled 2.6.35-rc5-git1 with this option disabled.
>
> For now, I can't reproduce the problem with CONFIG_NO_BOOTMEM disabled ;
> with the option and rc5 the problem was happening quite quickly after
> boot and normal use of the machine. So it seems I can confirme what Zeno
> has seen and I hope this will give a hint to debug the problem. I guess
> this has not been reported that much because many testers might not have
> enabled CONFIG_NO_BOOTMEM... Maybe the scheduler folks could test their
> benchmark with a kernel having this option enabled?

To be honest, the bug is bit odd. It's related to boot-time memory
allocator changes but yet it seems to manifest itself as a scheduling
problem. So if you have some spare time and want to speed up the
debugging process, please test v2.6.34 and v2.6.35-rc1 with
CONFIG_NO_BOOTMEM and if former is good and latter is bad, try to see
if you can identify the offending commit with "git bisect."

                         Pekka
