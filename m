Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074Ab2HTP04 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 11:26:56 -0400
Received: from www.linutronix.de ([62.245.132.108]:36042 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756963Ab2HTP0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 11:26:51 -0400
Message-ID: <50325734.3090905@linutronix.de>
Date: Mon, 20 Aug 2012 17:26:44 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.6esrpre) Gecko/20120817 Icedove/10.0.6
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: linux-kernel@vger.kernel.org, x86@kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakaynahalli <ananth@in.ibm.com>, stan_shebs@mentor.com,
        gdb-patches@sourceware.org
Subject: Re: [RFC 5/5] uprobes: add global breakpoints
References: <1344355952-2382-1-git-send-email-bigeasy@linutronix.de>  <1344355952-2382-6-git-send-email-bigeasy@linutronix.de> <1344857686.31459.25.camel@twins>
In-Reply-To: <1344857686.31459.25.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2012 01:34 PM, Peter Zijlstra wrote:
> I'm not really happy with any of this. I would suggest limiting this
> stuff much further, like say only have it affect ptraced
> processes/tasks. That way you cannot accidentally freeze the entire
> system into oblivion.

I'be been browsing over the cgroup Documentation and it seems to look
usefull. What I have in mind is the following:
/sys/fs/cgroup/gb

The root group is the default one where a breakpoint triggers. Below
you could have two groups:
- excluded
- active

The excluded group would never trigger a breakpoint.
Once a task in the root set triggers a breakpoint it will be moved into
to the active set. The eventfd notifcation API of cgroups could be used
to learn about this change.

The whole concept fails if the user does not move a single task into
the excluded group. To be overprotective here, I could try not do
anything until we have at least one pid in the "excluded" set.

So far I like this, it could be heat though.

Sebastian
