Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624Ab1L3HhD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Dec 2011 02:37:03 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:32953 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab1L3HhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Dec 2011 02:37:01 -0500
Date: Fri, 30 Dec 2011 11:36:55 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
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
Message-ID: <20111230073655.GE4806@moon>
References: <20111228162653.GM17712@google.com>
 <20111228164055.GR27266@moon>
 <20111228164522.GO17712@google.com>
 <20111228165336.GS27266@moon>
 <20111228170116.GQ17712@google.com>
 <20111228171419.GA19321@moon>
 <20111229142438.GI4460@moon>
 <20111229161414.GC3516@google.com>
 <20111229162453.GC4806@moon>
 <20111230002309.GA11508@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111230002309.GA11508@gondor.apana.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 30, 2011 at 11:23:09AM +1100, Herbert Xu wrote:
> On Thu, Dec 29, 2011 at 08:24:53PM +0400, Cyrill Gorcunov wrote:
> >
> > Probably I've had to crypto_alloc_hash earlier and simply keep a reference
> > to algo but since I'm not sure if looking for modules in late-init-call
> > is good idea.
> 
> Right, the allocation needs to occur in a sleepable context.
> 
> If you're just hashing something small and have no need for
> hardware acceleration then lib/sha1.c is fine.
> 

Hi, yeah, it's just one message block hashing so I've switched
to lib/sha1.c. Herbert, I'm more interested in security analysis
-- would the sha1(msg), where the 'msg' is the kernel pointer
XOR'ed with random value and expanded to the 512 bits would be
safe enough for export to unprivilege users?

	Cyrill
