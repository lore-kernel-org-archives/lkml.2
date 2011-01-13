Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932956Ab1AMPrW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 10:47:22 -0500
Received: from mga11.intel.com ([192.55.52.93]:30997 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757170Ab1AMPrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 10:47:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,317,1291622400"; 
   d="scan'208";a="877210311"
Message-ID: <4D2F1E84.2000200@linux.intel.com>
Date: Thu, 13 Jan 2011 07:47:16 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
CC: peterz@infradead.org, lenb@kernel.org, suresh.b.siddha@intel.com,
        benh@kernel.crashing.org, venki@google.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC V2 3/3] cpuidle: default idle driver for x86
References: <20110113125113.11174.78525.stgit@tringupt.in.ibm.com> <20110113125223.11174.60425.stgit@tringupt.in.ibm.com>
In-Reply-To: <20110113125223.11174.60425.stgit@tringupt.in.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/13/2011 4:52 AM, Trinabh Gupta wrote:
> This default cpuidle_driver parses idle= boot parameters, selects
> the optimal idle routine for x86 during bootup and registers with
> cpuidle. The code for idle routines and the selection of optimal
> routine is moved from arch/x86/kernel/process.c . At module_init this
> default driver is registered with cpuidle and for non ACPI platforms
> it continues to be used. For ACPI platforms, acpi_idle driver would
> replace this driver at a later point in time during bootup. Until
> this driver's registration, architecture supplied compile time
> default idle routine is called from within cpuidle_idle_call().
>


I like the general approach, but I'd think making idle drivers modular 
is going one step too far....
that looks like waaay overkill to me (also since most of the actual idle 
handlers are so small
that the overhead of the exported symbols alone is bigger than the idle 
handlers)

