Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab0KETNE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 15:13:04 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39768 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502Ab0KETNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 15:13:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=UBxp/U+DVxsQLOyNo5eGCE9eDHs1Bl7Yv//Np3jIIzN78E/+wXyIofcvi5vr4iFxqp
         WOXLV+kS2ms9hl1liENI0vLptV0Cb5w+uIABY1gIJQ4lSQHrY604z22Ss3oQTc1Kpb0i
         UuC6VvJVgZevIgi8G+A8r5YuwInuGcwqlu3E4=
Subject: Re: [PATCH] atomic: add atomic_inc_not_zero_hint()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Nick Piggin <npiggin@kernel.dk>
In-Reply-To: <20101105184034.GG2850@linux.vnet.ibm.com>
References: <1288975980.2882.877.camel@edumazet-laptop>
	 <20101105102038.53e36f9e.akpm@linux-foundation.org>
	 <1288980046.2882.1054.camel@edumazet-laptop>
	 <20101105184034.GG2850@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Nov 2010 20:12:51 +0100
Message-ID: <1288984371.2665.13.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 05 novembre 2010 à 11:40 -0700, Paul E. McKenney a écrit :

> OK, so I cannot resist the challenge...  ;-)
> 

I knew that ;)

> Suppose that the atomic_inc_not_zero_hint() is in common code that might
> be invoked from a cleanup path.  On the cleanup path, perhaps within an
> RCU callback, if the reference is zero, we have the only reference and
> thus don't need to increment the reference count.  On the other hand,
> if the reference is non-zero, we want to obtain a reference in order
> to safely attempt to encourage the other reference holder to let go
> more quickly.
> 
> Perhaps a bit of a stretch, but why not just replace the above
> "return 0" with "atomic_inc_not_zero(v)"?  It will usually be
> compiled out, right?

Yes indeed, thanks !



