Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932424Ab0KLPGI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 10:06:08 -0500
Received: from mail.windriver.com ([147.11.1.11]:48958 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932100Ab0KLPGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 10:06:06 -0500
Message-ID: <4CDD579F.80009@windriver.com>
Date: Fri, 12 Nov 2010 09:05:03 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20101027)
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [V2 PATCH 0/6] x86, NMI: give NMI handler a face-lift
References: <1289573033-2889-1-git-send-email-dzickus@redhat.com>
In-Reply-To: <1289573033-2889-1-git-send-email-dzickus@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Nov 2010 15:05:04.0740 (UTC) FILETIME=[FCB2FA40:01CB827A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2010 08:43 AM, Don Zickus wrote:
> Restructuring the nmi handler to be more readable and simpler.
>
> This is just laying the ground work for future improvements in this area.
>
> I also left out one of Huang's patch until we figure out how we are going
> to proceed with a new notifier.
>
> Tested 32-bit and 64-bit on AMD and Intel machines.
>
> V2:  add a patch to kill DIE_NMI_IPI and add in priorities
>
>   

Had you tested this code with kgdb boot tests at all?

CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_KGDB=y
CONFIG_KGDB_TESTS_ON_BOOT=y
CONFIG_KGDB_TESTS_BOOT_STRING="V1F100"

There has been a regression in kgdb due to the use of perf/NMI in the
lockup detector ever since the new version has been introduced.   The
perf callbacks in the lockup detector were consuming NMI events not
related to the call back and causing the kernel debugger not to work at
all on SMP systems configured with the lockup detector.

I was curious to know if this patch series fixed the problem as well as
to know if you could run the regression test when you make changes
related to the lockup / NMI path as it affects the kernel debug API.


Thanks,
Jason.
