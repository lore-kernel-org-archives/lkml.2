Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763Ab2H0V5c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 17:57:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55386 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754484Ab2H0V5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 17:57:31 -0400
Message-ID: <503BED6A.4080802@suse.com>
Date: Mon, 27 Aug 2012 17:58:02 -0400
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Mike Turquette <mturquette@ti.com>
Subject: Re: [PATCH] exynos-rng: Depend on ARCH_EXYNOS
References: <503BE05F.40109@suse.com> <503BE429.7080301@codeaurora.org> <503BE5E7.106@suse.com> <20120827213719.GD4400@opensource.wolfsonmicro.com>
In-Reply-To: <20120827213719.GD4400@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 8/27/12 5:37 PM, Mark Brown wrote:
> On Mon, Aug 27, 2012 at 05:25:59PM -0400, Jeff Mahoney wrote:
>> On 8/27/12 5:18 PM, Stephen Boyd wrote:
> 
>>> Hmm the point of making it not depend on ARCH_EXYNOS was so
>>> that it would get more build coverage. Is it devm_clk_get()
>>> that's missing? I believe Mark Brown sent some patches that
>>> move devm_clk_get() to common code so that we don't have these 
>>> failures[1]. Can you try that patch?
> 
>> I'll give it a go since it should fix more than one issue for me.
>> My question remains, though: If this hardware is never going to
>> be found on powerpc hardware, what difference does it make if
>> there is build coverage there?
> 
> If you're trying to do some generic API changes or similar it's
> *much* easier if you can at least build test a good proportion of
> the kernel (or subsytem) with one build even if you've no intention
> of running the code.  Having to build lots of different configs to
> get coverage means that's likely to get skipped which in turn
> increases the error rate with these things.

I can see the advantage there. It's just a pain when I'm building
distro configs and need to research where a particular piece of
hardware might turn up. For USB devices, it's easy: "everywhere." A
lot of the details for SoC stuff can be tough to turn up. This driver
will never be used on powerpc hardware, but it does because it meets
the API requirements. If your generic clock API patches gain traction,
then the API dependencies will be satisfied everywhere. That's a win
for build coverage but noise for people trying to build a kernel that
will cover the maximum amount of hardware without wasting build cycles
or user disk space. A separate depends on that indicates a hardware
dependency instead of just an API dependency -- one that can be
ignored when doing build coverage tests -- would be a nice thing to
have. Also ponies.

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.18 (Darwin)
Comment: GPGTools - http://gpgtools.org
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJQO+1qAAoJEB57S2MheeWy/eYQAImEBKsCATQExqwRXTnKwk1q
rL2B2L11I6XTHRYDQlK65RcHMkpt6ZlIM6QyH5kpBdH5e+Eew9b5A5oU1xZlI74d
BqDHTSmvT9c6ZSFncaTrfnTDWan4OWWSWzhoLSohTvVDd0Kq3pw99w3IkAeQL1P+
8vAVVDTX6mhIWqsH3MT6sTLoKevGLDyVPZtOQY//zPi4qbpB6fZmk0dyqa7bVotl
bOGH7IGKR/drh5y+ZjUKitl9PQdLa8j734iKL0owj5k97i9C4foe/sQ4Jh+KiUhj
FVhpHKtiIWoH9AebUSAxq1KtUmDbC3sBgLxRS4uG/Dpn8PYXZGb1ryNlkXVZKuga
HvX6LvYrcnBC07o62uH1NfolElBvUDYZYjL9EaEjAqB8KeVEYACn0Ja0n6Jg/YWd
Ll9e0JpEFCIaygU6mMO82ZvFpVB6pdl6jsBZxHdM3rw7pC1c+GyQTO/dcCfNta8h
knczZCG7gM3RevkhRvuTYZ6KHiLG0cBc7RHGMxPTR2rxP1LGN6pQ8UIm/OJASC/u
6OYNZJDvCnvgipvRs9bjA+AAmX6Nm46znEnh42CXpYNE98OqiUrKGrDVShKUPC9O
d24nH+1O3QhbsRGCt8o7Nd1owEQyKHHXUPURzZego562k3oBg7Ta7y3JvpnrhbZi
6l+nyPcYqxuyP1DRkbBb
=tAKG
-----END PGP SIGNATURE-----
