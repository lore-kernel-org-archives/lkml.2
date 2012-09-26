Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500Ab2IZNjY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 09:39:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34854 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493Ab2IZNjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 09:39:23 -0400
Date: Wed, 26 Sep 2012 15:39:05 +0200
From: Andrew Jones <drjones@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Avi Kivity <avi@redhat.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Rik van Riel <riel@redhat.com>, Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH RFC 0/2] kvm: Improving undercommit,overcommit scenarios
 in PLE handler
Message-ID: <20120926133905.GA8842@turtle.usersys.redhat.com>
References: <1348486479.11847.46.camel@twins>
 <50604988.2030506@linux.vnet.ibm.com>
 <1348490165.11847.58.camel@twins>
 <50606050.309@linux.vnet.ibm.com>
 <1348494895.11847.64.camel@twins>
 <50608176.1040805@redhat.com>
 <1348502600.11847.90.camel@twins>
 <5060883C.4050901@redhat.com>
 <20120926132013.GB7633@turtle.usersys.redhat.com>
 <1348665971.3881.102.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348665971.3881.102.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 03:26:11PM +0200, Peter Zijlstra wrote:
> On Wed, 2012-09-26 at 15:20 +0200, Andrew Jones wrote:
> > Wouldn't a clean solution be to promote a task's scheduler
> > class to the spinner class when we PLE (or come from some special
> > syscall
> > for userspace spinlocks?)? 
> 
> Userspace spinlocks are typically employed to avoid syscalls..

I'm guessing there could be a slow path - spin N times and then give
up and yield.

> 
> > That class would be higher priority than the
> > fair class and would schedule in FIFO order, but it would only run its
> > tasks for short periods before switching. 
> 
> Since lock hold times aren't limited, esp. for things like userspace
> 'spin' locks, you've got a very good denial of service / opportunity for
> abuse right there.

Maybe add some throttling to avoid overuse/maliciousness?

> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
