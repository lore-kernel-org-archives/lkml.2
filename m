Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814Ab0DOS5M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 14:57:12 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:62934 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755480Ab0DOS5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 14:57:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MwIktiLio7v4AaJTzrPVVI1X1TlUNaVsyZkHIxUr2CWWzVESTk8KyjGNlvLCmVxzlO
         7CnkB6nbteuou2YKW0w/99/CAp7AEDdei2ZxV38YlvUFpOLdzJsT4YN3X54TCNk7rLiv
         f220qSTnIwTVPAk2Ho3fxZFtXFULl/vi8h5qo=
Date: Thu, 15 Apr 2010 20:57:05 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, David Miller <davem@davemloft.net>,
       a.p.zijlstra@chello.nl, mingo@elte.hu, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Weird rcu lockdep warning
Message-ID: <20100415185702.GC5069@nowhere>
References: <20100413200432.GB5099@nowhere> <20100413234043.GG2538@linux.vnet.ibm.com> <20100414000226.GH5602@nowhere> <20100413.171306.25868761.davem@davemloft.net> <20100414014930.GI2538@linux.vnet.ibm.com> <4BC537C9.8050600@cn.fujitsu.com> <20100414154302.GC2516@linux.vnet.ibm.com> <20100414155110.GG5142@nowhere> <20100414160057.GD2516@linux.vnet.ibm.com> <20100415042426.GA4254@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100415042426.GA4254@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 14, 2010 at 09:24:26PM -0700, Paul E. McKenney wrote:
> On Wed, Apr 14, 2010 at 09:00:57AM -0700, Paul E. McKenney wrote:
> > On Wed, Apr 14, 2010 at 05:51:11PM +0200, Frederic Weisbecker wrote:
> 
> [ . . .]
> 
> > > Note I just tested the patch the previous one and it looks fine now.
> > > You can then safely consider the "general idea" fixes the problem :)
> > 
> > Thank you, Frederic!!!
> 
> And here is what I hope is the official fix.
> 
> Could you please test it?
> 
> 							Thanx, Paul
> 
> ------------------------------------------------------------------------
> 
> commit 9be39c445a41e458d53cf9a57d25dbfa4b74c970
> Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Date:   Tue Apr 13 18:45:51 2010 -0700
> 
>     rcu: Make RCU lockdep check the lockdep_recursion variable
>     
>     The lockdep facility temporarily disables lockdep checking by incrementing
>     the current->lockdep_recursion variable.  Such disabling happens in NMIs
>     and in other situations where lockdep might expect to recurse on itself.
>     This patch therefore checks current->lockdep_recursion, disabling RCU
>     lockdep splats when this variable is non-zero.  In addition, this patch
>     removes the "likely()", as suggested by Lai Jiangshan.
>     
>     Reported-by: Frederic Weisbecker <fweisbec@gmail.com>
>     Reported-by: David Miller <davem@davemloft.net>
>     Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>


Tested-by: Frederic Weisbecker <fweisbec@gmail.com>

Thanks!

