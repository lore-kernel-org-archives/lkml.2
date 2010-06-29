Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab0F2SRc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 14:17:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:40158 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754354Ab0F2SRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 14:17:31 -0400
Message-ID: <4C2A385B.3010909@kernel.org>
Date: Tue, 29 Jun 2010 20:15:55 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>, torvalds@linux-foundation.org,
       mingo@elte.hu, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, oleg@redhat.com,
       axboe@kernel.dk, dwalker@codeaurora.org, stefanr@s5r6.in-berlin.de,
       florian@mickler.org, andi@firstfloor.org, mst@redhat.com,
       randy.dunlap@oracle.com, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 34/35] async: use workqueue for worker pool
References: <1277759063-24607-1-git-send-email-tj@kernel.org> <1277759063-24607-35-git-send-email-tj@kernel.org> <20100628225513.GB10104@nowhere> <4C299FD8.7030904@kernel.org> <20100629121855.GA5318@nowhere> <4C2A1558.7060007@kernel.org> <20100629155228.GK5318@nowhere> <4C2A176F.1090101@kernel.org> <4C2A220B.8080006@linux.intel.com> <4C2A2688.1020206@kernel.org> <4C2A3652.7030806@linux.intel.com>
In-Reply-To: <4C2A3652.7030806@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 29 Jun 2010 18:16:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Arjan.

On 06/29/2010 08:07 PM, Arjan van de Ven wrote:
> we might be talking past eachother. ;-)
> 
> let me define an example that is simple so that we can get on the same page
> 
> assume a system with "enough" cpus, say 32.
> lets say we have 2 async tasks, that each do an mdelay(1000); (yes I
> know stupid, but exagerating things makes things easier to talk about)

That's the main point to discuss tho.  If you exaggerate the use case
out of proportion, you'll end up with something which in the end is
useful only in the imagination and we'll be doing things just because
we can.  Creating full number of unbound threads might look like a
good idea to extract maximum cpu parallelism if you exaggerate the use
case like the above but with the current actual use case, it's not
gonna buy us anything and might even cost us more via unnecessary
thread creations.

So, let's talk about whether it's _actually_ useful for the current
use cases.  If so, sure, let's do it that way.  If not, there is no
reason to go there, right?

Thanks.

-- 
tejun
