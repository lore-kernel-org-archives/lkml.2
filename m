Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161614Ab2CPKoT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 06:44:19 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:40856 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030833Ab2CPKoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 06:44:17 -0400
Date: Fri, 16 Mar 2012 11:44:09 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: cpu_active vs pcrypt & padata
Message-ID: <20120316104409.GP15404@secunet.com>
References: <1331892788.18960.227.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331892788.18960.227.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 16 Mar 2012 10:44:09.0479 (UTC) FILETIME=[B7D93970:01CD0361]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Fri, Mar 16, 2012 at 11:13:08AM +0100, Peter Zijlstra wrote:
> Hi Steffen,
> 
> I found cpu_active usage in crypto/pcrypt.c and was wondering what
> that's doing there. I would really like to contain that thing to as
> narrow a piece of kernel as I possible can (sched/cpuset/hotplug) but it
> appears to be spreading.

pcrypt uses cpu_active to tell padata which cpuset it whishes
to use for parallelization. I could try to push the cpumask
handling down to padata if you want to limit this to the core
kernel.

> 
> Also, wth is all this kernel/padata.c stuff? There's next to no useful
> comment in there and the only consumer seems to be pcrypt, does that
> really need to be in kernel/ ?

The padata code is generic and not limited to crypto, you can find
a documentation at Documentation/padata.txt.

