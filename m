Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244Ab2EBNow (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 09:44:52 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:48958 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121Ab2EBNov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 09:44:51 -0400
Date: Wed, 2 May 2012 15:44:41 +0200
From: Borislav Petkov <bp@amd64.org>
To: Alex Shi <alex.shi@intel.com>
Cc: Borislav Petkov <bp@amd64.org>, andi.kleen@intel.com,
        tim.c.chen@linux.intel.com, jeremy@goop.org, chrisw@sous-sol.org,
        akataria@vmware.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, rostedt@goodmis.org, fweisbec@gmail.com,
        riel@redhat.com, luto@mit.edu, avi@redhat.com, len.brown@intel.com,
        paul.gortmaker@windriver.com, dhowells@redhat.com,
        fenghua.yu@intel.com, yinghai@kernel.org, cpw@sgi.com, steiner@sgi.com,
        linux-kernel@vger.kernel.org, yongjie.ren@intel.com
Subject: Re: [PATCH 2/3] x86/flush_tlb: try flush_tlb_single one by one in
 flush_tlb_range
Message-ID: <20120502134441.GF12914@aftab.osrc.amd.com>
References: <1335603099-2624-1-git-send-email-alex.shi@intel.com>
 <1335603099-2624-3-git-send-email-alex.shi@intel.com>
 <20120430105440.GC9303@aftab.osrc.amd.com>
 <4FA0FD39.9060908@intel.com>
 <20120502093815.GB12914@aftab.osrc.amd.com>
 <4FA11CC7.5040302@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA11CC7.5040302@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2012 at 07:38:47PM +0800, Alex Shi wrote:
> > Are you saying you want to have this setting per family?
> 
> Set it according to CPU type is more precise, but looks ugly.

By "CPU type" do you mean microarchitecture here?

> I am wondering if it worth to do. Maybe conservative selection is
> acceptable?

Well, as I said earlier, I'd run it on a couple of different machines
and make FLUSHALL_BAR configurable from userspace - this way you have
real, solid data instead of guessing the exact number.

> > Also, have you run your patches with other benchmarks beside your
> > microbenchmark, say kernbench, SPEC<something>, i.e. some other
> > multithreaded benchmark touching shared memory? Are you seeing any
> > improvement there?
> 
> I tested oltp reading and specjbb2005 with openjdk. They should not much
> flush_tlb_range calling. So, no clear improvement.
> Do you know benchmarks which cause enough flush_tlb_range?

Not really. Probably get a couple of benchmarks and count
flush_tlb_range calls with trace_printk or perf probe? :-)

[..]

> Believe we didn't need to know this, much more thread number just
> weaken and cover the improvement. When the thread number goes down,
> the performance gain appears. So, don't need care this.

Ok, this is also what the data showed, much higher gain with smaller
thread counts.

> Any more comments for this patchset?

Nope, thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
