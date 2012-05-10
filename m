Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758868Ab2EJKm1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 06:42:27 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:54874 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501Ab2EJKm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 06:42:26 -0400
Date: Thu, 10 May 2012 12:42:12 +0200
From: Borislav Petkov <bp@amd64.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Alex Shi <alex.shi@intel.com>, rob@landley.net, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, arnd@arndb.de, rostedt@goodmis.org,
        fweisbec@gmail.com, jeremy@goop.org, gregkh@linuxfoundation.org,
        borislav.petkov@amd.com, riel@redhat.com, luto@mit.edu, avi@redhat.com,
        len.brown@intel.com, dhowells@redhat.com, fenghua.yu@intel.com,
        ak@linux.intel.com, cpw@sgi.com, steiner@sgi.com,
        akpm@linux-foundation.org, penberg@kernel.org, hughd@google.com,
        rientjes@google.com, kosaki.motohiro@jp.fujitsu.com,
        n-horiguchi@ah.jp.nec.com, paul.gortmaker@windriver.com, trenn@suse.de,
        tj@kernel.org, oleg@redhat.com, axboe@kernel.dk,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 5/7] x86/tlb: add tlb flush all factor for specific CPU
Message-ID: <20120510104212.GB31257@aftab.osrc.amd.com>
References: <1336626013-28413-1-git-send-email-alex.shi@intel.com>
 <1336626013-28413-6-git-send-email-alex.shi@intel.com>
 <1336642715.2527.84.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336642715.2527.84.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 11:38:35AM +0200, Peter Zijlstra wrote:
> On Thu, 2012-05-10 at 13:00 +0800, Alex Shi wrote:
> 
> 
> > +void intel_tlb_flushall_factor_set(struct cpuinfo_x86 *c)
> > +{
> > +       if (!cpu_has_invlpg) {
> > +               tlb_flushall_factor = -1;
> > +               return;
> > +       }
> 
> ...
> 
> > +       if (!cpu_has_invlpg || vma->vm_flags & VM_HUGETLB
> > +                       || tlb_flushall_factor == (u16)TLB_FLUSH_ALL)
> > {
> >  flush_all: 
> 
> Since you set tlb_flushall_factor (I'd have called it _shift)

Seconded, tlb_flushall_shift makes more sense, considering how it is
being used.

> to -1 when !invlpg there's a redundant check in there.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
