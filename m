Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab1L1Qpa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 11:45:30 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:46034 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753992Ab1L1Qp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 11:45:27 -0500
Date: Wed, 28 Dec 2011 08:45:22 -0800
From: Tejun Heo <tj@kernel.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Matt Helsley <matthltc@us.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [patch 1/4] Add routine for generating an ID for kernel pointer
Message-ID: <20111228164522.GO17712@google.com>
References: <20111223124741.711871189@openvz.org>
 <20111223124920.661126615@openvz.org>
 <20111228160655.GL17712@google.com>
 <20111228161809.GQ27266@moon>
 <20111228162653.GM17712@google.com>
 <20111228164055.GR27266@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111228164055.GR27266@moon>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Dec 28, 2011 at 08:40:55PM +0400, Cyrill Gorcunov wrote:
> > We have the whole crypto subsystem dealing with this.  It sure would
> > be more complex than ^ operator but it's not like you have to open
> > code the whole thing.  Is it really that complex to use?
> 
> No, Tejun, the use of crypto engine is not hard but it means more memory
> consumption (one need to carry resulting hashes and print them out into
> /proc) and more cpu consuption while we really need some fast and cheap
> solution. Unlike other usage of crypto engine (such as encoding for net
> layer, iirc ipsec uses it) I'm not really convinced we should use that
> heavy artillery here ;)

But the cost would be attributed to the user requesting that specific
data and given the amount of data to be hashed, I don't think the
computational or memory overhead should be the deciding design factor
here.  There are far more grave issues here.  Userland visible API and
security.

> I see, I could use some other form of output, it's not a problem. The main
> problem which interface community prefer, should I really switch to crypto
> usage or we can leave with root-only+plain-pointer approach?

I don't know either but if proper hashing (crypto or not) is simple
enough, this really isn't a tradeoff we need to make, no?

Thanks.

-- 
tejun
