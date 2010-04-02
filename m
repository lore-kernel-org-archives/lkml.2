Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402Ab0DBTuf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 15:50:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46489 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753800Ab0DBTu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 15:50:28 -0400
Date: Fri, 2 Apr 2010 12:46:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jason Wessel <jason.wessel@windriver.com>
cc: Will Deacon <will.deacon@arm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kgdb-bugreport@lists.sourceforge.net, linux-arm@vger.kernel.org,
       Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH 4/5] kgdb: Use atomic operators which use barriers
In-Reply-To: <alpine.LFD.2.00.1004021238270.3634@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1004021244140.3634@i5.linux-foundation.org>
References: <1270233145-29335-1-git-send-email-jason.wessel@windriver.com> <1270233145-29335-2-git-send-email-jason.wessel@windriver.com> <1270233145-29335-3-git-send-email-jason.wessel@windriver.com> <1270233145-29335-4-git-send-email-jason.wessel@windriver.com>
 <1270233145-29335-5-git-send-email-jason.wessel@windriver.com> <alpine.LFD.2.00.1004021205080.3634@i5.linux-foundation.org> <4BB64762.6040806@windriver.com> <alpine.LFD.2.00.1004021238270.3634@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 2 Apr 2010, Linus Torvalds wrote:
> 
> All that matters is that the above kind of while loop must work. The 
> architecture needs to do whatever it needs to do to make it work. End of 
> discussion. If on ARM6 that means "smp_mb()", then that's an ARM6 
> implementation issue.

Put another way: from a kernel standpoint, cpu_relax() in _no_ way implies 
a memory barrier. That has always been true, and that continues to be 
true.

But Linux does expect that if some other CPU modifies a memory location, 
then we _will_ see that modification eventually. If the CPU needs help to 
do so, then cpu_relax() needs to do that. Again - this has nothing to do 
with memory barriers. It's just a basic requirement.

				Linus
