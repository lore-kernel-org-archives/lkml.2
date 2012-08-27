Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab2H0VZ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 17:25:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54337 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648Ab2H0VZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 17:25:27 -0400
Message-ID: <503BE5E7.106@suse.com>
Date: Mon, 27 Aug 2012 17:25:59 -0400
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mike Turquette <mturquette@ti.com>
Subject: Re: [PATCH] exynos-rng: Depend on ARCH_EXYNOS
References: <503BE05F.40109@suse.com> <503BE429.7080301@codeaurora.org>
In-Reply-To: <503BE429.7080301@codeaurora.org>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 8/27/12 5:18 PM, Stephen Boyd wrote:
> On 8/27/2012 2:02 PM, Jeff Mahoney wrote:
>> The exynos-rng device is only found on Samsung EXYNOS devices but
>> has dependencies that allow it to be built on other
>> architectures. This can result in build failures on powerpc due
>> to a missing clk_devm_get.
>> 
>> This patch makes it depend on ARCH_EXYNOS.
> 
> Hmm the point of making it not depend on ARCH_EXYNOS was so that
> it would get more build coverage. Is it devm_clk_get() that's
> missing? I believe Mark Brown sent some patches that move
> devm_clk_get() to common code so that we don't have these
> failures[1]. Can you try that patch?
> 
> [1] https://lkml.org/lkml/2012/6/5/186
> 

I'll give it a go since it should fix more than one issue for me. My
question remains, though: If this hardware is never going to be found
on powerpc hardware, what difference does it make if there is build
coverage there?

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.18 (Darwin)
Comment: GPGTools - http://gpgtools.org
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJQO+XmAAoJEB57S2MheeWy4FgQALl7Ea62K19+3aObLCC+HLL4
5YSRG865SGPvLqMYxYuAf+aS+uVKeBk8YbnG51o6TXMrXbePv3bNtSR36J7JI1gd
9ogl5a9I/TtZUU+4+elDjy27Aew60Ask1Yv3SWYPm1NEqbUwuccb6vr2cm3tVyA4
en9WP67EUv0qwiCJvtFdYuNaPzMyFbLcwxvzQgAMk0+7H4cJ1FvZvKzVFP7SrGaa
G9HtY8f3Bxglk/hovQax8l5je8oa7IrU19jFu78t73+u44yfVEc8H5vzWKEARlI4
jsXH0l4X+NYZ1waBjoyQMPsNjbuwrwP0OW11gdN5WYk0kRvI8mX/mGiUNV+NyDl9
xr5ekUQidyYvOE+/HpV2hFu3NLux8xKOHJE8QtEOFiAuTAVVNZYHftZcTblPq6CC
/F7DJ9iMsxjcGOEvJplF1DG9gu6RsqYYV191PFLvXQgnl2cvcso7F/05ypBfaCTb
MJ+YVcdjvkrtNGDwBwE8wdOVwEWObDeLljiU0tLH4X6LziBbG68pthJBFpBesO5m
KT+doKUD6J/TIF0Jp2/zn/KhdUJf3wX2Ozb7stwWKa08/XFw4ghAJnl8D+4PUyKs
Izh6+L6LudearE2ZuOkNXlhB3PMeuQVK+b0BMbbZkHdPCErWE72sT06B3T9IbqgE
jXhuHdN7JWrgAAGPAiTn
=SA08
-----END PGP SIGNATURE-----
