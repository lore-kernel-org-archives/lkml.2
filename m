Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471Ab1F2Rn3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 13:43:29 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:33363 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756746Ab1F2Rn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 13:43:27 -0400
Date: Wed, 29 Jun 2011 23:12:20 +0530
From: Ankita Garg <ankita@in.ibm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        svaidy@linux.vnet.ibm.com, thomas.abraham@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 00/10] mm: Linux VM Infrastructure to support Memory
 Power Management
Message-ID: <20110629174220.GA9152@in.ibm.com>
Reply-To: Ankita Garg <ankita@in.ibm.com>
References: <1306499498-14263-1-git-send-email-ankita@in.ibm.com>
 <20110629130038.GA7909@in.ibm.com>
 <1309367184.11430.594.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309367184.11430.594.camel@nimitz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jun 29, 2011 at 10:06:24AM -0700, Dave Hansen wrote:
> I was kinda hoping for something a bit simpler than that.  I'd boil down
> what you were saying to this:
> 
>      1. The kernel must be aware of how the pieces of hardware are
>         mapped in to the system's physical address space
>      2. The kernel must have a mechanism in place to minimize access to
>         specific pieces of hardware 
>      3. For destructive power-down operations, the kernel should have a
>         mechanism in place to ensure that no valuable data is contained
>         in the memory to be powered down.
>

	4. The kernel must have a mechanism to maintain utilization
	   statistics pertaining to a piece of hardware, so that it can
	   trigger the hardware to power it off
	5. Being able to group these pieces of hardware for purpose of
	   higher savings. 

> Is that complete?
> 
> On Wed, 2011-06-29 at 18:30 +0530, Ankita Garg wrote:
> > 1) Dynamic Power Transition: The memory controller can have the ability
> > to automatically transition regions of memory into lower power states
> > when they are devoid of references for a pre-defined threshold amount of
> > time. Memory contents are preserved in the low power states and accessing
> > memory that is at a low power state takes a latency hit.
> > 
> > 2) Dynamic Power Off: If a region is free/unallocated, the software can
> > indicate to the controller to completely turn off power to a certain
> > region. Memory contents are lost and hence the software has to be
> > absolutely sure about the usage statistics of the particular region. This
> > is a runtime capability, where the required amount of memory can be
> > powered 'ON' to match the workload demands.
> > 
> > 3) Partial Array Self-Refresh (PASR): If a certain regions of memory is
> > free/unallocated, the software can indicate to the controller to not
> > refresh that region when the system goes to suspend-to-ram state and
> > thereby save standby power consumption.
> 
> (3) is simply a subset of (2), but with the additional restriction that
> the power off can only occur during a suspend operation.  
> 
> Let's say we fully implemented support for (2).  What would be missing
> to support PASR?
> 

Yes, PASR is a subset of (2) from implementation perspective.

-- 
Regards,
Ankita Garg (ankita@in.ibm.com)
Linux Technology Center
IBM India Systems & Technology Labs,
Bangalore, India
