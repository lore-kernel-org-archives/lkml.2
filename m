Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab2AYA0l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 19:26:41 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:55820 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163Ab2AYA0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 19:26:39 -0500
Message-ID: <1327451195.14373.28.camel@edumazet-laptop>
Subject: Re: [PATCH v2] proc:  speedup /proc/stat handling
From: Eric Dumazet <eric.dumazet@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Paul Tuner <pjt@google.com>
Date: Wed, 25 Jan 2012 01:26:35 +0100
In-Reply-To: <20120125091818.45e00b3c.kamezawa.hiroyu@jp.fujitsu.com>
References: <1327075164.12389.31.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <1327449683.14373.12.camel@edumazet-laptop>
	 <20120125091818.45e00b3c.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 25 janvier 2012 à 09:18 +0900, KAMEZAWA Hiroyuki a écrit :

> BTW, what is the reason of this change ?
> 
> > -	unsigned size = 4096 * (1 + num_possible_cpus() / 32);
> > +	unsigned size = 1024 + 128 * num_possible_cpus();
> 
> I think size of buffer is affected by the number of online cpus.
> (Maybe 128 is enough but please add comment why 128 ?)
> 

There is no change, as 4096/32 is 128 bytes per cpu.

Only change is granularity is not any more 32 cpus, but one.

Of course, kmalloc() is going to roundup to next power of two anyway.

So real allocation is bigger, unless we switch to vmalloc() eventually.



