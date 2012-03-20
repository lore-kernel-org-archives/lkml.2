Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758860Ab2CTHpE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 03:45:04 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:45657 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758628Ab2CTHpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 03:45:00 -0400
Date: Tue, 20 Mar 2012 08:44:57 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: cpu_active vs pcrypt & padata
Message-ID: <20120320074457.GE29891@secunet.com>
References: <1331892788.18960.227.camel@twins>
 <20120316104409.GP15404@secunet.com>
 <1332018034.18960.247.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332018034.18960.247.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 20 Mar 2012 07:44:58.0035 (UTC) FILETIME=[59241030:01CD066D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 17, 2012 at 10:00:34PM +0100, Peter Zijlstra wrote:
> On Fri, 2012-03-16 at 11:44 +0100, Steffen Klassert wrote:
> > 
> > pcrypt uses cpu_active to tell padata which cpuset it whishes
> > to use for parallelization. I could try to push the cpumask
> > handling down to padata if you want to limit this to the core
> > kernel.
> 
> /me more confused now.. cpu_active isn't in any way shape or form
> related to cpusets.

When looking at this, it seems that cpu_online_mask is the mask
we should use instead of cpu_active_mask. I'll go in for a closer
look at the end of the week.

> > 
> > The padata code is generic and not limited to crypto, you can find
> > a documentation at Documentation/padata.txt.
> 
> Would be nice to have a short blurb in kernel/padata.c with a reference
> to that Documentation stuff for more in-depth bits.

Indeed, I'll take care for this.
