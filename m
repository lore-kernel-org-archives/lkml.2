Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab1JRJeR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 05:34:17 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:48565 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab1JRJeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 05:34:16 -0400
Date: Tue, 18 Oct 2011 11:34:11 +0200
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Elmar Vonlanthen <evonlanthen@gmail.com>, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>,
        Timo =?iso-8859-1?Q?Ter=E4s?= <timo.teras@iki.fi>
Subject: Re: PROBLEM: System call 'sendmsg' of process ospfd (quagga)
	causes kernel oops
Message-ID: <20111018093411.GA15165@gondor.apana.org.au>
References: <CA+0Zf5Be5JUSvssH9CrDQq=jtETZr=veAPC7jriM8B-FZKbbpg@mail.gmail.com> <1318604266.2223.29.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <CA+0Zf5A-8X5MaXC4+BbLKtMb8S8B-Ln_a3JNfz0jR4O-ruefuw@mail.gmail.com> <1318905032.2571.35.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318905032.2571.35.camel@edumazet-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 04:30:32AM +0200, Eric Dumazet wrote:
>
> If David/Herbert/Timo agree, then patch should find its way into current
> kernel, then to stable trees as well.

Actually, I think we should instead fix the users of needed_headroom
to not read it twice which is causing problems here.

GRE tunnels by their nature do not have a fixed value for
needed_headroom.  As the underlying routes change the necessary
headroom may need to be adjusted due to further encapsulation such
as IPsec.

Keeping it constant from tunnel creation may result in suboptimal
performance due to unnecessary header reallocations.

However, until we audit the stack to see if there are further
instances of double-readings such as the one causing the crash
here, I'm fine with your patch making it constant.

Once we're sure that all of the double-readings are gone we
can revert to a dynamic needed_headroom.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
