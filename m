Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024Ab0DBUAz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 16:00:55 -0400
Received: from mail.windriver.com ([147.11.1.11]:36968 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab0DBUAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 16:00:51 -0400
Message-ID: <4BB64CDA.4000405@windriver.com>
Date: Fri, 02 Apr 2010 15:00:26 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: kgdb-bugreport@lists.sourceforge.net, Will Deacon <will.deacon@arm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       linux-arm@vger.kernel.org
Subject: Re: [Kgdb-bugreport] [PATCH 4/5] kgdb: Use atomic operators whichuse
 barriers
References: <1270233145-29335-1-git-send-email-jason.wessel@windriver.com><1270233145-29335-2-git-send-email-jason.wessel@windriver.com><1270233145-29335-3-git-send-email-jason.wessel@windriver.com><1270233145-29335-4-git-send-email-jason.wessel@windriver.com><1270233145-29335-5-git-send-email-jason.wessel@windriver.com><alpine.LFD.2.00.1004021205080.3634@i5.linux-foundation.org> <4BB64762.6040806@windriver.com> <4BB649E3.5060606@windriver.com> <alpine.LFD.2.00.1004021246470.3634@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1004021246470.3634@i5.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Apr 2010 20:00:26.0641 (UTC) FILETIME=[233E7810:01CAD29F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2010 02:47 PM, Linus Torvalds wrote:
>
>> From: Jason Wessel <jason.wessel@windriver.com>
>> Subject: [PATCH] kgdb: Use atomic operators which use barriers
>>
>> The cpu_relax() does not mandate that there is an smp memory barrier.
>> As a result on the arm smp architecture the kernel debugger can hang
>> on entry from time to time, as shown by the kgdb regression tests.
>>     
>
> Now your changelog makes no sense any more.
>   

It is revised now and pushed.  Regression testing on the HW I have has
passed as well now.

For the series the pull looks like:

 drivers/misc/kgdbts.c |    6 ++
 kernel/kgdb.c         |  205
+++++++++++++++++++++++++------------------------
 2 files changed, 109 insertions(+), 102 deletions(-)


Thanks,
Jason.


---
From: Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH] kgdb: use atomic_inc and atomic_dec instead of atomic_set

Memory barriers should be used for the kgdb cpu synchronization.  The
atomic_set() does not imply a memory barrier.

Reported-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
