Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049Ab0FIREg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 13:04:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:54897 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757276Ab0FIREf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 13:04:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,392,1272870000"; 
   d="scan'208";a="806293765"
Message-ID: <4C0FC9CE.30705@linux.intel.com>
Date: Wed, 09 Jun 2010 10:05:18 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: =?UTF-8?B?Um9iZXJ0IFNjaMO2bmU=?= <robert.schoene@tu-dresden.de>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] power_end event (Resend)
References: <1276091847.1763.18.camel@localhost>
In-Reply-To: <1276091847.1763.18.camel@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/9/2010 6:57 AM, Robert Schöne wrote:
> Original Mail was sent at 2010/05/14 10:38:43 CEST
>
> Hi,
> I reported the power_end tracing problem earlier this year
> (http://lkml.org/lkml/2010/2/24/79) and sent a patch which worked for my
> system. However this patch would have not worked on other systems (as
> for example Arjans). It would had lead to a double posting of these
> events.
>
> However. Here's a diff that should fix the problem on the correct spot.
>
> The reason that it worked for Arjan and not for me is that his system
> uses drivers/acpi/processor_idle.c when idling, mine uses the cpu_idle
> thread from arch/x86/kernel/process_64.c.
> A comparable idle thread also exists for 32 bit x86, so I added it in
> process_32.c too.
>
> However, is there any standard about where to report the start and end
> events? Currently it's the idle routine, which creates the power_start
> event, the routine which calls the idle_routine on the other hand
> creates the power_end event.
>    

only the actual idle routine knows what C state it goes in; there's no 
central way for that really.

> For these patches, I'm not sure whether the power_end event should even
> be reported. On kernels, which use the repnop loop when idling, there
> won't be a switch to another c-state and therefore no power_start event,
> the power_end event could belong to. Would that be a problem? If it
> would, the only way to fix this would be to move the power_end events
> into the idle routines, since cpu_idle is dumb and does not know whats
> behind pm_idle.
>
>    

the patch makes sense; Acked-by: Arjan van de Ven <arjan@linux.intel.com>
