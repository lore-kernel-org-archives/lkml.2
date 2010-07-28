Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159Ab0G1MVa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 08:21:30 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:48948 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763Ab0G1MV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 08:21:26 -0400
X-SpamScore: -29
X-BigFish: VPS-29(zz1dbaL1432N98dN936eM4015L148cMzz1202hzzz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L69OZ9-02-831-02
X-M-MSG: 
Date: Wed, 28 Jul 2010 14:21:11 +0200
From: Robert Richter <robert.richter@amd.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Carl E. Love" <cel@us.ibm.com>,
        Michael Ellerman <michaele@au1.ibm.com>
Subject: Re: Possible Oprofile crash/race when stopping
Message-ID: <20100728122111.GO26154@erda.amd.com>
References: <1279775680.1970.13.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1279775680.1970.13.camel@pasglop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.07.10 01:14:40, Benjamin Herrenschmidt wrote:
> Hi folks !
> 
> We've hit a strange crash internally, that we -think- we have tracked
> down to an oprofile bug. It's hard to hit, so I can't guarantee yet that
> we have fully smashed it but I'd like to share our findings in case you
> guys have a better idea.
> 
> So the initial observation is a spinlock bad magic followed by a crash
> in the spinlock debug code:

Benjamin,

thanks for reporting this. I was trying to reproduce this with various
loads and scenarios, but without success so far. Can you give me a
hint of the load you have (number of processes running, cpu load, do
you switch off oprofile while many processes are still running)? Are
you able to regularly trigger it?

> I think the right sequence however requires breaking up end_sync. Ie, we
> need to do in that order:
> 
>   - cancel the workqueues
>   - unregister the notifier
>   - process the mortuary
> 
> What do you think ?

This could potentially fix it, I will have to look deeper into the
code. Try to do this next week.

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

