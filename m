Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab2EUPmY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 11:42:24 -0400
Received: from orion.tchmachines.com ([208.76.84.200]:60294 "EHLO
	orion.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690Ab2EUPmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 11:42:22 -0400
From: Vlad Zolotarov <vlad@scalemp.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>, Shai@scalemp.com,
        ido@wizery.com
Subject: Re: [PATCH v4 0/2] Move x86_cpu_to_apicid to the __read_mostly section
Date: Mon, 21 May 2012 18:42:18 +0300
Message-ID: <1918812.66k1TLBkOr@vlad>
Organization: ScaleMP Ltd.
User-Agent: KMail/4.8.2 (Linux/3.2.0-24-generic; KDE/4.8.2; i686; ; )
In-Reply-To: <20120521152345.GC7068@gmail.com>
References: <1744141.b5asW8k6jC@vlad> <20120521152345.GC7068@gmail.com>
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

On Monday, May 21, 2012 17:23:48 Ingo Molnar wrote:
> * Vlad Zolotarov <vlad@scalemp.com> wrote:
> > Pls., consider applying this patch series.
> > 
> > It contains the following changes:
> >  - Adds two new macros DEFINE_EARLY_PER_CPU_READ_MOSTLY() and
> >  
> >    DECLARE_EARLY_PER_CPU_READ_MOSTLY().
> >  
> >  - Adds "read-mostly" qualifier to the following variables in smp.h:
> >   - cpu_sibling_map
> >   - cpu_core_map
> >   - cpu_llc_shared_map
> >   - cpu_llc_id
> >   - cpu_number
> >   - x86_cpu_to_apicid
> >   - x86_bios_cpu_apicid
> >   - x86_cpu_to_logical_apicid
> > 
> > As long as all the variables above are only written during the
> > initialization, this change is meant to prevent the false
> > sharing and improve the performance on large multiprocessor
> > systems.
> 
> Why have you resent this? The feedback I gave has not been
> 
> addressed:

Hmmm... I'm a bit confused. There were two feedbacks/threads: one on "Signed-
off-by" format and the other where u asked for a justification on a vSMP side. 

The signed-off format sounded to me as a clear blocker for a series so I fixed 
it and respined. I also mentioned it in patch0.

The second thread seams like getting to submitting a separate patch with a doc 
under Documents and vSMP testing results explaining and justifying when and 
were per-CPU and/or __read_mostly variables should be used. 

Pls., correct me if I misunderstood u and let me know what should I do next in 
order to make this patch series accepted.

thanks,
vlad


> > Well, a quick tally of percpu variables on a 'make defconfig'
> > kernel would tell us one way or another?
> > 
> > Here there's almost 200 percpu variables active in the 64-bit
> > x86 defconfig, and a quick random sample suggests that most
> > are read-mostly.
> > 
> > I have no fundamental prefer to either approach, but the
> > direction taken should be justified explicitly, with numbers,
> > arguments, etc. - also a short blurb somewhere in the headers
> > that explains when they should be used, so that others can be
> > aware of vSMP's special needs here.
> 
> Thanks,
> 
> 	Ingo
