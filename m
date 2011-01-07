Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab1AGCmd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 21:42:33 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59791
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751866Ab1AGCmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 21:42:31 -0500
Date: Thu, 06 Jan 2011 18:43:02 -0800 (PST)
Message-Id: <20110106.184302.193709839.davem@davemloft.net>
To: herbert@gondor.hengli.com.au
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: Crypto Update for 2.6.38
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110107001459.GA32068@gondor.apana.org.au>
References: <20110106225301.GA27358@gondor.apana.org.au>
	<AANLkTi=E3fqTos7A2fJ2PRKT=o5=sgWh+CzMv4G7P4rZ@mail.gmail.com>
	<20110107001459.GA32068@gondor.apana.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Fri, 7 Jan 2011 11:14:59 +1100

> Anyway, here is a test program that does a set number (1024 * 1024)
> of 4096-byte (total 4GB) encryptions with libssl and kernel crypto.
> The result on my Core 2 (in a KVM VM FWIW) is:
> 
> lenny0:~# time ./test_crypto > /dev/null 
> 
> real    0m30.340s
> user    0m0.172s
> sys     0m30.166s
> lenny0:~# time ./test_crypto software > /dev/null 
> 
> real    0m34.555s
> user    0m34.550s
> sys     0m0.004s
> lenny0:~# 
> 
> I'm not claiming these numbers make any sense but this is just
> a ballpark figure.
> 
> Dave, can you run this program on your N2 and see what it shows?

Sure, here goes, BTW I had to change the buffer size to 8192 since
vmsplice requires page aligned operation (I was getting -EINVAL
otherwise):

davem@maramba:~$ time ./crypto_user_test >/dev/null

real		 0m46.586s
user		 0m3.280s
sys		 0m43.230s
davem@maramba:~$ time ./crypto_user_test software >/dev/null

real		 10m40.336s
user		 10m40.540s
sys		 0m0.000s
davem@maramba:~$   

What's that, something like a factor of 13 faster? :-)
