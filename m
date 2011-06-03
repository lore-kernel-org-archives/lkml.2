Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491Ab1FCVhQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 17:37:16 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59660 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756093Ab1FCVhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 17:37:14 -0400
Date: Fri, 3 Jun 2011 23:37:13 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Dave Anderson <anderson@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, jstancek@redhat.com
Subject: Re: [PATCH] x86-64: Prevent gcc from optimizing away venosys_1()
Message-ID: <20110603213713.GO27166@one.firstfloor.org>
References: <20110603204847.GM27166@one.firstfloor.org> <1972495451.7278.1307136726542.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1972495451.7278.1307136726542.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 03, 2011 at 05:32:06PM -0400, Dave Anderson wrote:
> 
> 
> ----- Original Message -----
> > >  	return 0;
> > >  }
> > >
> > > -static long __vsyscall(3) venosys_1(void)
> > > +long __vsyscall(3) venosys_1(void)
> > 
> > Better add a __used too. Otherwise it can be optimized out again
> > in some builds e.g. when someone enables gc-sections for the linker.
> 
> Considering that all of the vsyscall prototypes have this attribute:
> 
> #define __vsyscall(nr) \
>                 __attribute__ ((unused, __section__(".vsyscall_" #nr))) notrace
> 
> How would any of them work?

unused is just to prevent warnings I think. used stops the optimizer
from throwing it away.

It would make more sense to drop the unused and add an used.  I think
used prevents the warnings too.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
