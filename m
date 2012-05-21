Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122Ab2EUNyb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 09:54:31 -0400
Received: from orion.tchmachines.com ([208.76.84.200]:53953 "EHLO
	orion.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863Ab2EUNya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 09:54:30 -0400
From: Vlad Zolotarov <vlad@scalemp.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: "Shai Fultheim (Shai@ScaleMP.com)" <Shai@scalemp.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ido Yariv <ido@wizery.com>
Subject: Re: [PATCH v3 0/2] Move x86_cpu_to_apicid to the __read_mostly section
Date: Mon, 21 May 2012 16:54:25 +0300
Message-ID: <1693911.sUneyHzERA@vlad>
Organization: ScaleMP Ltd.
User-Agent: KMail/4.8.2 (Linux/3.2.0-24-generic; KDE/4.8.2; i686; ; )
In-Reply-To: <20120521123246.GB17065@gmail.com>
References: <1337527148.6093.14.camel@vlad> <9B14D1490DDECA4E974F6B9FC9EBAB317D295F4D11@VMBX108.ihostexchange.net> <20120521123246.GB17065@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - orion.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalemp.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 21, 2012 02:32:46 PM Ingo Molnar wrote:
> * Shai Fultheim (Shai@ScaleMP.com) <Shai@ScaleMP.com> wrote:
> > Ingo,
> > 
> > The reason for this, as you pointed out, is the 'cache line'
> > size (4096 bytes).  We see significant false sharing is we do
> > not move this next to each other.
> 
> Which write-often variable caused the many cache flushes/fills?
> cpu_to_apicid is read mostly.
> 
> I.e. it might make more sense to identify the frequenty
> *modified* percpu variables, and move them to a separate
> section. I *think* most percpu variables are read mostly, so it
> would be more maintainable in the long run to figure out the
> frequently modified ones, not the frequently not modified ones.

I tend to disagree about the general claim that most per-CPU variables are 
read-mostly: consider the per-CPU data structures used in lock-less algorithms 
like softnet_data used in a NAPI. I'm not sure what is a more common - read-
only or not-read-only per-cpu data, but surely there are both...

In this specific patch we deal with something that is initialized once in the 
init time and then used as if it's a constant thus representing a clear 
"__read_mostly" case. 

Having said all that I think that the proposed solution, the one using 
__read_mostly infrastructure, is just ok both in a long run. I also doubt that 
we are currently facing a need to define an additional "frequently modified" 
section.

Pls., comment.

thanks,
vlad

> 
> Thanks,
> 
> 	Ingo
