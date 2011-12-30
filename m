Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab1L3AX1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 19:23:27 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:52199 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899Ab1L3AXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 19:23:25 -0500
Date: Fri, 30 Dec 2011 11:23:09 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Pavel Emelyanov <xemul@parallels.com>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Matt Helsley <matthltc@us.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch 1/4] Add routine for generating an ID for kernel pointer
Message-ID: <20111230002309.GA11508@gondor.apana.org.au>
References: <20111228161809.GQ27266@moon> <20111228162653.GM17712@google.com> <20111228164055.GR27266@moon> <20111228164522.GO17712@google.com> <20111228165336.GS27266@moon> <20111228170116.GQ17712@google.com> <20111228171419.GA19321@moon> <20111229142438.GI4460@moon> <20111229161414.GC3516@google.com> <20111229162453.GC4806@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111229162453.GC4806@moon>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 29, 2011 at 08:24:53PM +0400, Cyrill Gorcunov wrote:
>
> Probably I've had to crypto_alloc_hash earlier and simply keep a reference
> to algo but since I'm not sure if looking for modules in late-init-call
> is good idea.

Right, the allocation needs to occur in a sleepable context.

If you're just hashing something small and have no need for
hardware acceleration then lib/sha1.c is fine.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
