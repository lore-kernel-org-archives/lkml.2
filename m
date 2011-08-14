Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742Ab1HNTGq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 15:06:46 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:56044 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653Ab1HNTGo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 15:06:44 -0400
MIME-Version: 1.0
In-Reply-To: <54B2EB610B7F1340BB6A0D4CA04A4F10013EFF76B1@orsmsx505.amr.corp.intel.com>
References: <1311529994-7924-1-git-send-email-minipli@googlemail.com>
	<1311529994-7924-3-git-send-email-minipli@googlemail.com>
	<20110804064436.GA16247@gondor.apana.org.au>
	<CA+rthh_nx2bvM71M=AdUuhEpT7EbhB5DbwkT=5zNF7MO-TGyHA@mail.gmail.com>
	<54B2EB610B7F1340BB6A0D4CA04A4F10013EFF76B1@orsmsx505.amr.corp.intel.com>
Date: Sun, 14 Aug 2011 21:06:43 +0200
Message-ID: <CA+rthh8TaYHJyuQ_kDz+DrXe2YK927dedpYTzSenuAhj7a8UNQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] crypto, x86: SSSE3 based SHA1 implementation for x86-64
From: Mathias Krause <minipli@googlemail.com>
To: "Locktyukhin, Maxim" <maxim.locktyukhin@intel.com>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Lutomirski <luto@mit.edu>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Max,

2011/8/8 Locktyukhin, Maxim <maxim.locktyukhin@intel.com>:
> I'd like to note that at Intel we very much appreciate Mathias effort to port/integrate this implementation into Linux kernel!
>
>
> $0.02 re tcrypt perf numbers below: I believe something must be terribly broken with the tcrypt measurements
>
> 20 (and more) cycles per byte shown below are not reasonable numbers for SHA-1 - ~6 c/b (as can be seen in some of the results for Core2) is the expected results ... so, while relative improvement seen is sort of consistent, the absolute performance numbers are very much off (and yes Sandy Bridge on AVX code is expected to be faster than Core2/SSSE3 - ~5.2 c/b vs. ~5.8 c/b on the level of the sha1_update() call to me more precise)
>
> this does not affect the proposed patch in any way, it looks like tcrypt's timing problem to me - I'd even venture a guess that it may be due to the use of RDTSC (that gets affected significantly by Turbo/EIST, TSC is isotropic in time but not with the core clock domain, i.e. RDTSC cannot be used to measure core cycles without at least disabling EIST and Turbo, or doing runtime adjustment of actual bus/core clock ratio vs. the standard ratio always used by TSC - I could elaborate more if someone is interested)

I found the Sandy Bridge numbers odd too but suspected, it might be
because of the laptop platform. The SSSE3 numbers on this platform
were slightly lower than the AVX numbers and that for still way off
the ones for the Core2 system. But your explanation fits well, too. It
might be EIST or Turbo mode that tampered with the numbers. Another,
maybe more likely point might be the overhead Andy mentioned.

> thanks again,
> -Max
>

Mathias
