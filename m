Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757106Ab2E3Hab (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 03:30:31 -0400
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:59223 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757082Ab2E3Ha2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 03:30:28 -0400
Message-ID: <20120530103025.19252e1urui8sfb4@www.81.fi>
Date: Wed, 30 May 2012 10:30:25 +0300
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: Andi Kleen <andi@firstfloor.org>
Cc: Johannes Goetzfried 
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Tilo =?iso-8859-1?b?TfxsbGVy?= 
	<tilo.mueller@informatik.uni-erlangen.de>
Subject: Re: [PATCH] crypto: serpent - add x86_64/avx assembler
 implementation
References: <20120527145112.GF17705@kronos.redsun>
 <m2396il7xc.fsf@firstfloor.org>
In-Reply-To: <m2396il7xc.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.3.7)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andi Kleen <andi@firstfloor.org>:

>
> The driver needs CPUID annotations now (since 3.3), so that it can be
> autoloaded.  Something like:
>

Is it really good idea to autoload crypto modules? Currently loading  
different cipher implementations is handled via module-aliases and  
cipher priorities. With autoloading by CPUID, crypto-modules would be  
loaded and be mostly unused. For example, serpent-sse2 would be  
autoloaded on all x86-64 kernels (well, on those that have it compiled  
as module => probably most of distros).

IMHO these should be loaded only when needed, as is done with generic  
i586/x86-64 assembler cipher implementations.

-Jussi

