Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932597Ab0JQTRK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 15:17:10 -0400
Received: from www.tglx.de ([62.245.132.106]:40332 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932457Ab0JQTRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 15:17:09 -0400
Date: Sun, 17 Oct 2010 21:13:48 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: Patrizio Bassi <patrizio.bassi@gmail.com>, Len Brown <lenb@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [Bug 20032] New: 2.6.36-rc7 continuos kernel panics due to of
 cpu_idle (and cpu_intel_idle)
In-Reply-To: <bug-20032-6666@https.bugzilla.kernel.org/>
Message-ID: <alpine.LFD.2.00.1010172106340.2496@localhost6.localdomain6>
References: <bug-20032-6666@https.bugzilla.kernel.org/>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Back to mail/lkml

On Sun, 10 Oct 2010, bugzilla-daemon@bugzilla.kernel.org wrote:

> Subject    : 2.6.36-rc7 continuos kernel panics due to of cpu_idle (and
> cpu_intel_idle)
> Submitter  : Patrizio Bassi <patrizio.bassi@gmail.com>
> Date       : 2010-10-08 18:23
> Message-ID : AANLkTi=2irM5tM2rNC5wHVV=Nw4cs_CK59pvXDD+Y5Dz@mail.gmail.com
> References : http://marc.info/?l=linux-kernel&m=128656222919323&w=2
> 
> This entry is being used for tracking a regression from 2.6.35.  Please don't
> close it until the problem is fixed in the mainline.
>
>> I have strong suspects around CONFIG_CPU_IDLE setting provoking
>> several kernel panics. All panics have the cpu_idle function involved.
>> I don't know how to reproduce, it happened every 2-3 hrs using firefox browser.
>> 
>> System with 2.6.35.5 is totally stable.
>> 
>> I took a snapshot of a panic here:
>> http://www.patriziobassi.it/downloads/DSC03364.JPG

The machine crashes in __alloc_skb called from
neigh_timer_handler. Which makes no sense at all. That looks more like
memory corruption.

>> 
>> Situation is dramatically worse when CONFIG_INTEL_IDLE is set.
>> Here panic happens even during startup.

Len, Suresh ???

Thanks,

	tglx
