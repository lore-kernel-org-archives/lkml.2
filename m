Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883Ab1F2RHs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 13:07:48 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:35417 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752147Ab1F2RHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 13:07:46 -0400
Subject: Re: [PATCH 00/10] mm: Linux VM Infrastructure to support Memory
 Power Management
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Ankita Garg <ankita@in.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        svaidy@linux.vnet.ibm.com, thomas.abraham@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <20110629130038.GA7909@in.ibm.com>
References: <1306499498-14263-1-git-send-email-ankita@in.ibm.com>
	 <20110629130038.GA7909@in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Jun 2011 10:06:24 -0700
Message-ID: <1309367184.11430.594.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was kinda hoping for something a bit simpler than that.  I'd boil down
what you were saying to this:

     1. The kernel must be aware of how the pieces of hardware are
        mapped in to the system's physical address space
     2. The kernel must have a mechanism in place to minimize access to
        specific pieces of hardware 
     3. For destructive power-down operations, the kernel should have a
        mechanism in place to ensure that no valuable data is contained
        in the memory to be powered down.

Is that complete?

On Wed, 2011-06-29 at 18:30 +0530, Ankita Garg wrote:
> 1) Dynamic Power Transition: The memory controller can have the ability
> to automatically transition regions of memory into lower power states
> when they are devoid of references for a pre-defined threshold amount of
> time. Memory contents are preserved in the low power states and accessing
> memory that is at a low power state takes a latency hit.
> 
> 2) Dynamic Power Off: If a region is free/unallocated, the software can
> indicate to the controller to completely turn off power to a certain
> region. Memory contents are lost and hence the software has to be
> absolutely sure about the usage statistics of the particular region. This
> is a runtime capability, where the required amount of memory can be
> powered 'ON' to match the workload demands.
> 
> 3) Partial Array Self-Refresh (PASR): If a certain regions of memory is
> free/unallocated, the software can indicate to the controller to not
> refresh that region when the system goes to suspend-to-ram state and
> thereby save standby power consumption.

(3) is simply a subset of (2), but with the additional restriction that
the power off can only occur during a suspend operation.  

Let's say we fully implemented support for (2).  What would be missing
to support PASR?

-- Dave

