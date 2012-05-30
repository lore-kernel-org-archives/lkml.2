Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145Ab2E3Rgo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 13:36:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53704 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754739Ab2E3Rgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 13:36:42 -0400
Date: Wed, 30 May 2012 19:36:36 +0200
From: Johannes Goetzfried 
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Tilo =?iso-8859-1?Q?M=FCller?= 
	<Tilo.Mueller@informatik.uni-erlangen.de>
Subject: Re: [PATCH] crypto: serpent - add x86_64/avx assembler
 implementation
Message-ID: <20120530173636.GQ17705@kronos.redsun>
References: <20120527145112.GF17705@kronos.redsun>
 <m2396il7xc.fsf@firstfloor.org>
 <20120530103025.19252e1urui8sfb4@www.81.fi>
 <20120530113235.GO17705@kronos.redsun>
 <20120530153949.GS27374@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120530153949.GS27374@one.firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Provags-ID: V02:K0:0F7VWYnzVnl9/evUsfXjKxUP5FF5FTAa6/V9AlFBeny
 NUaa4ZvndWUQ51I10tLGAB6gXQQwG9MBl+Xm5f2PTY5T4E1JNz
 Ay7mKHDvAaPyancPgMQoNgKuc3py54UUtKl+H2ACshQ9I+pqw4
 odFpLEN3EVVa6UQrQzsD92W+9kyWrpquTi2xTAzDN86e2Jx8Tw
 THb3ZZBXoB4WtG30jRftXtSOI4XyiCeJymM5uoksUQ2vxNFFNb
 JnJuqt1tDRTktfQjZkKqxNPww9TGxtOYG3tVeDPZ7NV0Kc4yW/
 tAdv07VhtG66hr3+Lb0yPcs/BhwZKOLdkZ3CmSFuW57SgwKkZ8
 YgFo4kvb1QtlnEsFZERI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 05:39:49PM +0200, Andi Kleen wrote:
> > I agree with that. Currently when I boot my PC with a new 3.4 kernel all the
> > ciphers from the intel-aesni module get loaded whether I need them or not. As
> > Jussi stated most people using distros probably won't need the
> > serpent-avx-x86_64 module get loaded automatically, so it's probably better to
> > leave it that way.
> 
> That means you got a 50% chance to use the wrong serpent.
> 
> This was a continuous problem with AESNI and the accelerated CRC,
> that is why the cpuid probing was implemented.
> 
> Without some form of auto probing you may as well not bother with
> the optimization.

Seems like I missunderstood the priority concept of the crypto API. I thought
both algorithms have module alias "serpent", so they get both loaded when they
are needed, for example by the device mapper, and after that the algorithm with
higher priority is selected. Where do you get the 50% chance of using the wrong
serpent?

If there is for some reason no possibility to make it work this way then cpuid
probing might be the better choice.

- Johannes
