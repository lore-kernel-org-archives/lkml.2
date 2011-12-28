Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab1L1Q1B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 11:27:01 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:44568 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753967Ab1L1Q07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 11:26:59 -0500
Date: Wed, 28 Dec 2011 08:26:53 -0800
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
Message-ID: <20111228162653.GM17712@google.com>
References: <20111223124741.711871189@openvz.org>
 <20111223124920.661126615@openvz.org>
 <20111228160655.GL17712@google.com>
 <20111228161809.GQ27266@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111228161809.GQ27266@moon>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Dec 28, 2011 at 08:18:09PM +0400, Cyrill Gorcunov wrote:
> Hi Tejun, thanks for comment! Yes, XOR is useless here in security meaning,
> but it simply breaks impression that these generating numbers "mean" somthing
> (I remained them as Vasily asked).

But that comes at the cost of creating the impression that the XOR
does something, which doesn't seem like a good situation.  e.g. Why do
we need per-domain XOR random keys for then?  That code now doesn't
mean anything.

> I personally fine to simply leave plain pointers here and root-only access
> since that is enough for us (and our tool will require root privileges
> anyway :)
> 
> OTOH, we could add some sha2 here with pointer+cookie as an initial value but I fear
> this will bring more code comlexity and computing sha2 hash is not that
> fast operation, which should be taken into account (note on x86-32 since
> pointers are 32bit values one could compute prehash for all space covered
> and if an attacker will know somehow cookie value the hash will be easily
> broken, not sure if it's really usefull for someone, since if you have root
> access to the machine such IDs will be the last thing attacker should be
> interested in :)

We have the whole crypto subsystem dealing with this.  It sure would
be more complex than ^ operator but it's not like you have to open
code the whole thing.  Is it really that complex to use?

> And it seems noone except us need this interface yet, so maybe sticking with
> "pointer exported under root-only" would be enough?

Maybe, dunno.  But even if it's gonna be raw pointer or XOR'd value
for now, I would suggest exporting it in the form which can be
replaced by proper hash in the future.  ie. Don't let userland assume
it's 32bit or 64bit value.

Thanks.

-- 
tejun
