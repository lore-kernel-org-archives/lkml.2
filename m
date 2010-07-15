Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934627Ab0GOUAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 16:00:17 -0400
Received: from smtp-118-thursday.nerim.net ([62.4.16.118]:52259 "EHLO
	maiev.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934530Ab0GOUAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 16:00:14 -0400
X-Greylist: delayed 2612 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Jul 2010 16:00:14 EDT
Date: Thu, 15 Jul 2010 22:00:12 +0200
From: Damien Wyart <damien.wyart@free.fr>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Zeno Davatz <zdavatz@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        mingo@elte.hu, yinghai@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: kmemleak, cpu usage jump out of nowhere
Message-ID: <20100715200012.GA4175@brouette>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim7SURv8DPTLC2JwOJvv1WMAR4mmyBp9XqXw_Py@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > For now, I can't reproduce the problem with CONFIG_NO_BOOTMEM disabled ;
> > with the option and rc5 the problem was happening quite quickly after
> > boot and normal use of the machine. So it seems I can confirme what Zeno
> > has seen and I hope this will give a hint to debug the problem. I guess
> > this has not been reported that much because many testers might not have
> > enabled CONFIG_NO_BOOTMEM... Maybe the scheduler folks could test their
> > benchmark with a kernel having this option enabled?

* Pekka Enberg <penberg@cs.helsinki.fi> [2010-07-15 22:50]:
> To be honest, the bug is bit odd. It's related to boot-time memory
> allocator changes but yet it seems to manifest itself as a scheduling
> problem. So if you have some spare time and want to speed up the
> debugging process, please test v2.6.34 and v2.6.35-rc1 with
> CONFIG_NO_BOOTMEM and if former is good and latter is bad, try to see
> if you can identify the offending commit with "git bisect."

Not sure I will have enough time in the coming days (doing that remotely
is fishy since ssh access is almost stuck when the problem occurs); if
Zeno can and would like to do it, maybe this could be done faster.

As the scheduler is now very well instrumented (many debugging features
are available), reproducing the bug on a test platform (it happens quite
quickly for me) might also give some hints. So testers, if you have
time, please test 2.6.35-rc5 with CONFIG_NO_BOOTMEM on a Core i7 and see
if you can reproduce the problem!

-- 
Damien
