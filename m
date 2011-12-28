Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab1L1RfM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 12:35:12 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:33730 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823Ab1L1RfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 12:35:07 -0500
Date: Wed, 28 Dec 2011 21:35:02 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/4] Add routine for generating an ID for kernel pointer
Message-ID: <20111228173502.GB19321@moon>
References: <20111222125639.360640574@openvz.org>
 <20111222131139.457264003@openvz.org>
 <20111228165114.04fcae0f@pyramind.ukuu.org.uk>
 <20111228170521.GT27266@moon>
 <20111228172151.3a121d59@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111228172151.3a121d59@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 28, 2011 at 05:21:51PM +0000, Alan Cox wrote:
> > It can happen in case of object re-allocated from slab. But in case
> > of two living pids it's impossible to get same pointers for different
> > objects. Or I misunderstood the question, Alan? It's up to application
> > to not compare objects from dead tasks.
> 
> How will it know the task has not died and been reallocated, or its
> resources not been freed and reallocated during the comparison ?
> 
> Your comparison appears to have a zero time validity - you can ask "is A
> the same as B" but by the time you get an answer your answer may no
> longer be true. It also externalises a current implementation
> detail in a very ugly way.
>

It's not differ from reading other data from /proc. How make you be sure
the PPid read from a task status is the same once you've finished reading
it? The same applies to say ps output, it's valid for almost zero time,
then one need to restart ps again to get new process tree snapshot. The
same here -- if I need a precise results I have to either stop tasks or
froze them and compare IDs. That's what I've had in mind.

> Would it also not be better to do the job right and simply have an
> interface to ask "who shares with A" or even something a bit more high
> level, it seems you are creating something nastier by trying to push all
> this in userspace than if you did the job or part of it kernel side where
> you had access to the right locking infrastructure and where the public
> API doesn't need to expose innards of the kernel ?
> 

Need to think, thanks a lot for idea, Alan!

	Cyrill
