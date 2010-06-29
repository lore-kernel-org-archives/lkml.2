Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab0F2HG3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 03:06:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:39137 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752097Ab0F2HG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 03:06:28 -0400
Message-ID: <4C299B35.6010506@kernel.org>
Date: Tue, 29 Jun 2010 09:05:25 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: torvalds@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       oleg@redhat.com, axboe@kernel.dk, dwalker@codeaurora.org,
       stefanr@s5r6.in-berlin.de, florian@mickler.org, andi@firstfloor.org,
       mst@redhat.com, randy.dunlap@oracle.com
Subject: Re: [PATCHSET] workqueue: concurrency managed workqueue, take#6
References: <1277759063-24607-1-git-send-email-tj@kernel.org> <20100628231812.GC10104@nowhere>
In-Reply-To: <20100628231812.GC10104@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 29 Jun 2010 07:05:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 06/29/2010 01:18 AM, Frederic Weisbecker wrote:
> On Mon, Jun 28, 2010 at 11:03:48PM +0200, Tejun Heo wrote:
>> B. General documentation of Concurrency Managed Workqueue (cmwq)
>> ================================================================
> 
> 
> It would be nice to get this in Documentation/workqueue-design.txt,
> as the design is complicated enough to deserve this file :)

Yeah, I'm thinking about putting more technical description as the
head comment in workqueue.c and putting overview and information for
workqueue users under Documentation.

>> As multiple execution contexts are available for each wq, deadlocks
>> around execution contexts is much harder to create.  The default wq,
>> system_wq, has maximum concurrency level of 256 and unless there is a
>> scenario which can result in a dependency loop involving more than 254
>> workers, it won't deadlock.
> 
> Why this arbitrary limitation?

It's basically a safety mechanism to prevent a run away user from
saturating the system with workers.  256 seemed high enough for most
use cases yet low enough not to cause any major system failure.  So,
yeah, I pulled that number out of my ass.

Thanks.

-- 
tejun
