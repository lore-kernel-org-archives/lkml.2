Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933102Ab1AMQXd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 11:23:33 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:37021 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933092Ab1AMQXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 11:23:30 -0500
Date: Thu, 13 Jan 2011 21:52:22 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Trinabh Gupta <trinabh@linux.vnet.ibm.com>, peterz@infradead.org,
        lenb@kernel.org, suresh.b.siddha@intel.com, benh@kernel.crashing.org,
        venki@google.com, ak@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC V2 3/3] cpuidle: default idle driver for x86
Message-ID: <20110113162222.GA10792@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20110113125113.11174.78525.stgit@tringupt.in.ibm.com>
 <20110113125223.11174.60425.stgit@tringupt.in.ibm.com>
 <4D2F1E84.2000200@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4D2F1E84.2000200@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arjan van de Ven <arjan@linux.intel.com> [2011-01-13 07:47:16]:

> On 1/13/2011 4:52 AM, Trinabh Gupta wrote:
> >This default cpuidle_driver parses idle= boot parameters, selects
> >the optimal idle routine for x86 during bootup and registers with
> >cpuidle. The code for idle routines and the selection of optimal
> >routine is moved from arch/x86/kernel/process.c . At module_init this
> >default driver is registered with cpuidle and for non ACPI platforms
> >it continues to be used. For ACPI platforms, acpi_idle driver would
> >replace this driver at a later point in time during bootup. Until
> >this driver's registration, architecture supplied compile time
> >default idle routine is called from within cpuidle_idle_call().
> >
> 
> 
> I like the general approach, but I'd think making idle drivers
> modular is going one step too far....
> that looks like waaay overkill to me (also since most of the actual
> idle handlers are so small
> that the overhead of the exported symbols alone is bigger than the
> idle handlers)

Agreed.  The idea of keeping them in a module is to keep the code
around for legacy systems and not have to use that code at all on
modern systems where ACPI driver can take over.

The current RFC still has not managed to pull out all the code into
the module, but suggest that it is possible.

We can keep them in-kernel and move to the next iteration where we
should ensure other architectures also can co-exist with pm_idle() and
slowly move to this approach.

--Vaidy

