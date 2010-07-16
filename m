Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964834Ab0GPJcZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 05:32:25 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:54762 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964810Ab0GPJcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 05:32:24 -0400
Message-ID: <4C40271E.9070809@cs.helsinki.fi>
Date: Fri, 16 Jul 2010 12:32:14 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: Zeno Davatz <zdavatz@gmail.com>
CC: Damien Wyart <damien.wyart@free.fr>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "x86@kernel.org" <x86@kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: kmemleak, cpu usage jump out of nowhere
References: <AANLkTinGoUml9PQ8w7flukqwF9V1ae-YafiDVQy6Q8gC@mail.gmail.com>	<AANLkTimgn1Xa0YIwjC6xOfNDjlqJSQYy65ZvqCtlMWHD@mail.gmail.com>	<1279100846.8592.53.camel@e102109-lin.cambridge.arm.com>	<4C3D89AC.4040303@cs.helsinki.fi>	<1279205891.6664.46.camel@e102109-lin.cambridge.arm.com>	<AANLkTikJeA-bZEk652QwwT4iY21v5tr6RCzcZAZGgS8D@mail.gmail.com>	<4C3F2F52.2050101@cs.helsinki.fi>	<20100715162805.GA10240@brouette>	<20100715191638.GA3694@brouette>	<AANLkTim7SURv8DPTLC2JwOJvv1WMAR4mmyBp9XqXw_Py@mail.gmail.com>	<20100715200012.GA4175@brouette>	<F37ABC5E-E9F9-43BD-989E-4185135217D2@gmail.com>	<AANLkTimWFTUZTh2-3Bavmwcum2joQluMEDmXx3xjyHqQ@mail.gmail.com>	<AANLkTinqZs11kXx5afD4RDsVsy551S5lMnyAUwhdX2Sg@mail.gmail.com>	<AANLkTilv7cG9JMkZeO_GftTPWHxiIY5c8Q19pTBZT7Vy@mail.gmail.com> <AANLkTimGMUtzgO5HWHXX5RY-EDET61j6PxzwgILigIef@mail.gmail.com>
In-Reply-To: <AANLkTimGMUtzgO5HWHXX5RY-EDET61j6PxzwgILigIef@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Zeno,

Zeno Davatz wrote:
> This version has some problem with the DRM but no CPU eater yet.
> 
> http://www.flickr.com/photos/zrr/4798885756/
> 
> This version boots again just fine:
> 
> Linux zenogentoo 2.6.34-rc5-00059-gc2b4127 #105 SMP Fri Jul 16
> 11:13:21 CEST 2010 i686 Intel(R) Core(TM) i7 CPU 960 @ 3.20GHz
> GenuineIntel GNU/Linux

You're going into the wrong direction. If 2.6.34-rc7 works just fine, 
you shouldn't be testing 2.6.34-rc5.

> 
> As I understand I am bisecting upwards. Every time it does not boot
> correctly I do
> 
> git bisect bad after the next boot.

No, you should only do "git bisect bad" if you find a CPU eater and "git 
bisect good" if you don't. For the non-booting kernels you should do 
"git bisect skip"; otherwise git gets confused as we can see here.

Did you test v2.6.35-rc1? Does it have the CPU eater problem? If yes, 
please just reset your bisection

   git bisect reset
   git bisect start
   git bisect good v2.6.34-rc7
   git bisect bad v2.6.35-rc1

and use 'git bisect skip' for kernels that don't boot or build.

			Pekka
