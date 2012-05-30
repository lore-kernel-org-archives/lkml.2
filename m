Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004Ab2E3Lck (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 07:32:40 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:50118 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab2E3Lcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 07:32:39 -0400
Date: Wed, 30 May 2012 13:32:35 +0200
From: Johannes Goetzfried 
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Andi Kleen <andi@firstfloor.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Tilo =?iso-8859-1?Q?M=FCller?= 
	<Tilo.Mueller@informatik.uni-erlangen.de>
Subject: Re: [PATCH] crypto: serpent - add x86_64/avx assembler
 implementation
Message-ID: <20120530113235.GO17705@kronos.redsun>
References: <20120527145112.GF17705@kronos.redsun>
 <m2396il7xc.fsf@firstfloor.org>
 <20120530103025.19252e1urui8sfb4@www.81.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120530103025.19252e1urui8sfb4@www.81.fi>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Provags-ID: V02:K0:bzbtC8Yo2z+oyGieb17kcJudHIpyHDdTJcr5hZsJwYb
 kPihyKa2h9b04LHf78wg5e9cU1wBzp4sN1TOs1qFVx275+8PTn
 iuuSNf2dbM8GyRfw3xjd5ktkISJ5pmAkrpgqJEGObmKq23rnVX
 I7g6Dk3XDi4kdh5Xjd4y63JaREBLn9MId6DsNTEcINGEiLL3p5
 nY+ZVEtR1IOsvMCjxvU5tsn8LaW/Wqd7zKAyTo9y6SUJMtk9j3
 5PMNAF/kpsvWHqQcMzysf4qL80NUwR34J1WUqkFystIgpQiWhk
 //pmeOx9ZclRTozH8GBpouCFGawSXpaIsp+M8+HV+YXjlqwK8X
 i2tmpBf2kcFfByclzI4w=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 10:30:25AM +0300, Jussi Kivilinna wrote:
> Quoting Andi Kleen <andi@firstfloor.org>:
> 
> >
> >The driver needs CPUID annotations now (since 3.3), so that it can be
> >autoloaded.  Something like:
> >
> 
> Is it really good idea to autoload crypto modules? Currently loading
> different cipher implementations is handled via module-aliases and
> cipher priorities. With autoloading by CPUID, crypto-modules would
> be loaded and be mostly unused. For example, serpent-sse2 would be
> autoloaded on all x86-64 kernels (well, on those that have it
> compiled as module => probably most of distros).
> 
> IMHO these should be loaded only when needed, as is done with
> generic i586/x86-64 assembler cipher implementations.

I agree with that. Currently when I boot my PC with a new 3.4 kernel all the
ciphers from the intel-aesni module get loaded whether I need them or not. As
Jussi stated most people using distros probably won't need the
serpent-avx-x86_64 module get loaded automatically, so it's probably better to
leave it that way.
