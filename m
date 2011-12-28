Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab1L1Qxo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 11:53:44 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61489 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047Ab1L1Qxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 11:53:42 -0500
Date: Wed, 28 Dec 2011 20:53:36 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Matt Helsley <matthltc@us.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [patch 1/4] Add routine for generating an ID for kernel pointer
Message-ID: <20111228165336.GS27266@moon>
References: <20111223124741.711871189@openvz.org>
 <20111223124920.661126615@openvz.org>
 <20111228160655.GL17712@google.com>
 <20111228161809.GQ27266@moon>
 <20111228162653.GM17712@google.com>
 <20111228164055.GR27266@moon>
 <20111228164522.GO17712@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111228164522.GO17712@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 28, 2011 at 08:45:22AM -0800, Tejun Heo wrote:
> Hello,
> 
> On Wed, Dec 28, 2011 at 08:40:55PM +0400, Cyrill Gorcunov wrote:
> > > We have the whole crypto subsystem dealing with this.  It sure would
> > > be more complex than ^ operator but it's not like you have to open
> > > code the whole thing.  Is it really that complex to use?
> > 
> > No, Tejun, the use of crypto engine is not hard but it means more memory
> > consumption (one need to carry resulting hashes and print them out into
> > /proc) and more cpu consuption while we really need some fast and cheap
> > solution. Unlike other usage of crypto engine (such as encoding for net
> > layer, iirc ipsec uses it) I'm not really convinced we should use that
> > heavy artillery here ;)
> 
> But the cost would be attributed to the user requesting that specific
> data and given the amount of data to be hashed, I don't think the
> computational or memory overhead should be the deciding design factor
> here.  There are far more grave issues here.  Userland visible API and
> security.
>

Well, it is not deciding but it should be taken into account. One could
be reading this IDs again and again and again affecting performance of
the whole system, which means I really would prefer to limit access to such
features (ie root-only). If (as I said) for other cases there is simply no way to
_not_ use crypto, our case might be the one where using crypto is redundant.

> > I see, I could use some other form of output, it's not a problem. The main
> > problem which interface community prefer, should I really switch to crypto
> > usage or we can leave with root-only+plain-pointer approach?
> 
> I don't know either but if proper hashing (crypto or not) is simple
> enough, this really isn't a tradeoff we need to make, no?
> 

Hell knows, I would prefer to escape strong-crypto usage, but if there is
no other way, of course I'll change the approach ;)

	Cyrill
