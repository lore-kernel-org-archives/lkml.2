Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab1L1RO1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 12:14:27 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40800 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940Ab1L1ROZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 12:14:25 -0500
Date: Wed, 28 Dec 2011 21:14:19 +0400
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
Message-ID: <20111228171419.GA19321@moon>
References: <20111223124741.711871189@openvz.org>
 <20111223124920.661126615@openvz.org>
 <20111228160655.GL17712@google.com>
 <20111228161809.GQ27266@moon>
 <20111228162653.GM17712@google.com>
 <20111228164055.GR27266@moon>
 <20111228164522.GO17712@google.com>
 <20111228165336.GS27266@moon>
 <20111228170116.GQ17712@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111228170116.GQ17712@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 28, 2011 at 09:01:16AM -0800, Tejun Heo wrote:
> Hello,
> 
> On Wed, Dec 28, 2011 at 08:53:36PM +0400, Cyrill Gorcunov wrote:
> > Well, it is not deciding but it should be taken into account. One could
> > be reading this IDs again and again and again affecting performance of
> > the whole system,
> 
> I can't see how it would affect performance of the whole system.
> Calculating hash doesn't involve any further locking or use of scarce
> global resource.  It would add small amount memory and processing
> overhead for the task reading the hash.  It sure is something to be
> considered but I really don't think this should be a major factor
> here.
> 

Yeah, indeed.

> > which means I really would prefer to limit access to such
> > features (ie root-only). If (as I said) for other cases there is simply no way to
> > _not_ use crypto, our case might be the one where using crypto is redundant.
> 
> Limiting it to root and just exporting printer (or maybe XOR with a
> randomish value) may be good enough.  I don't know.  However, we no
> longer consider exporting pointers to unpriviliedged userland safe and
> this can be useful in many circumstances, so if it's not too
> difficult, I think trying to use proper hash would be nide.

OK, Tejun, I'll try, but no promises :) Thanks!

	Cyrill
