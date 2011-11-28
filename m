Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab1K1Hzf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 02:55:35 -0500
Received: from smtp-out-213.synserver.de ([212.40.185.213]:1087 "HELO
	smtp-out-211.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1751161Ab1K1Hze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 02:55:34 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 25128
Message-ID: <4ED33EB1.6030200@metafoo.de>
Date: Mon, 28 Nov 2011 08:56:33 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Iceowl/1.0b2 Icedove/3.1.16
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        drivers@analog.com, stable@kernel.org
Subject: Re: [PATCH 2/8] firmware: Sigma: Skip header during CRC generation
References: <1322138908-32127-1-git-send-email-lars@metafoo.de> <201111241222.00189.vapier@gentoo.org> <4ECF580E.3060301@metafoo.de> <201111251500.52711.vapier@gentoo.org>
In-Reply-To: <201111251500.52711.vapier@gentoo.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2011 09:00 PM, Mike Frysinger wrote:
> On Friday 25 November 2011 03:55:42 Lars-Peter Clausen wrote:
>> On 11/24/2011 06:21 PM, Mike Frysinger wrote:
>>> On Thursday 24 November 2011 07:48:21 Lars-Peter Clausen wrote:
>>>> The firmware header is not part of the CRC, so skip it. Otherwise the
>>>> firmware will be rejected due to non-matching CRCs.
>>>
>>> that's because you didn't compare to the right value ;).  include the CRC
>>> -> compare to 0.  omit the CRC -> compare to the CRC value.
>>
>> Does this really work if the CRC is inserted somewhere in the middle of the
>> bytestream?
> 
> i don't think the position matters to the CRC algorithm used by sigmadsp.  
> math principle: a ^ b ^ c is the same thing as b ^ a ^ c and c ^ b ^ a.

If CRC algorithms  were commutative they would be pretty weak, I guess ;)
> 
> i could be wrong as to the CRC algo used though.  simple enough for you to 
> check -- i implemented this firmware code based on a spec i wrote up for the 
> sigmadsp peeps; i never actually had real firmware to test with.
> -mike

It does not work.

- Lars
