Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887Ab1L3Uso (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Dec 2011 15:48:44 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64314 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab1L3Usm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Dec 2011 15:48:42 -0500
Date: Sat, 31 Dec 2011 00:48:36 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Matt Helsley <matthltc@us.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch 1/4] Add routine for generating an ID for kernel pointer
Message-ID: <20111230204836.GP4806@moon>
References: <20111228164522.GO17712@google.com>
 <20111228165336.GS27266@moon>
 <20111228170116.GQ17712@google.com>
 <20111228171419.GA19321@moon>
 <20111229142438.GI4460@moon>
 <20111229161414.GC3516@google.com>
 <20111229162453.GC4806@moon>
 <20111230002309.GA11508@gondor.apana.org.au>
 <20111230073655.GE4806@moon>
 <4EFE1FA4.3090207@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EFE1FA4.3090207@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 30, 2011 at 03:31:32PM -0500, KOSAKI Motohiro wrote:
> (12/30/11 2:36 AM), Cyrill Gorcunov wrote:
> >On Fri, Dec 30, 2011 at 11:23:09AM +1100, Herbert Xu wrote:
> >>On Thu, Dec 29, 2011 at 08:24:53PM +0400, Cyrill Gorcunov wrote:
> >>>
> >>>Probably I've had to crypto_alloc_hash earlier and simply keep a reference
> >>>to algo but since I'm not sure if looking for modules in late-init-call
> >>>is good idea.
> >>
> >>Right, the allocation needs to occur in a sleepable context.
> >>
> >>If you're just hashing something small and have no need for
> >>hardware acceleration then lib/sha1.c is fine.
> >>
> >
> >Hi, yeah, it's just one message block hashing so I've switched
> >to lib/sha1.c. Herbert, I'm more interested in security analysis
> >-- would the sha1(msg), where the 'msg' is the kernel pointer
> >XOR'ed with random value and expanded to the 512 bits would be
> >safe enough for export to unprivilege users?
> 
> Even if now we don't know an attacking way of sha1 reverse hashing,
> we may discover within 10 years. Many secure messages lost from
> hardware speedup and new algorithm attack. so, nobody can say it's
> abi safe.
>

Yes, I know. But there is a big difference between direct hash crack and
indirect crack caused by limited space of data used for such hash. That's
the reason why random cookie was used and xor production was expanded to
the whole message block.

> And, if you don't use perfect hash, you may have a hash collision
> risk. What's happen if different pointer makes same ID?

Well, strictly speaking this is pretty bad case for me. Of course this
wont lead to catastrophic results for user-space application I think
but definitely I would prefer to not have collisions here.

Guys, this become more and more complex, finally I fear someone
propose to do ideal hashing run-time ;) Maybe we can step back and
live with root-only and plain pointers here? I'm not sure who else
might need such facility except us, and if once there will be a candidate
-- we could take a look on hashing again and provide safe hashes there. No?

	Cyrill
