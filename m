Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab2D3KpT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 06:45:19 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:39618 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab2D3KpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 06:45:18 -0400
Date: Mon, 30 Apr 2012 12:45:09 +0200
From: Borislav Petkov <bp@amd64.org>
To: Alex Shi <alex.shi@intel.com>
Cc: andi.kleen@intel.com, tim.c.chen@linux.intel.com, jeremy@goop.org,
        chrisw@sous-sol.org, akataria@vmware.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, rostedt@goodmis.org,
        fweisbec@gmail.com, riel@redhat.com, luto@mit.edu, avi@redhat.com,
        len.brown@intel.com, paul.gortmaker@windriver.com, dhowells@redhat.com,
        fenghua.yu@intel.com, yinghai@kernel.org, cpw@sgi.com, steiner@sgi.com,
        linux-kernel@vger.kernel.org, yongjie.ren@intel.com
Subject: Re: [PATCH 1/3] x86/tlb_info: get last level TLB entry number of CPU
Message-ID: <20120430104509.GB9303@aftab.osrc.amd.com>
References: <1335603099-2624-1-git-send-email-alex.shi@intel.com>
 <1335603099-2624-2-git-send-email-alex.shi@intel.com>
 <20120429135529.GA2713@aftab.osrc.amd.com>
 <4F9E144A.8070901@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F9E144A.8070901@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2012 at 12:25:46PM +0800, Alex Shi wrote:
> >> +enum tlb_infos {
> >> +	ENTRIES,
> >> +	/* ASS_WAYS, */
> > 
> > We don't need associativity?
> 
> Detailed associative ways type(set,skewed etc) should effect the cache
> behavior, but I don't know the detailed associate type for each kind of
> CPU, and also don't know the detailed CPU hardware optimization for
> associative ways. (Some one said there is hardware hash to map memory
> into cache). But I don't know details, and can not do optimizing
> accordingly.
> and another reason is: according to this chart:
> http://en.wikipedia.org/wiki/File:Cache,missrate.png that from
> http://en.wikipedia.org/wiki/CPU_cache
> , seems we needn't care too much about the associative ways.

Yeah, we have the associativity in CPUID too but factoring in the exact
replacement policy here could probably be not worth it.

So the commented out ASS_WAYS above can be removed.

[..]

> > Also, there's cpuinfo_x86.x86_tlbsize which is L1 iTLB + L1 dTLB 4K
> > entries. The tlb sizes below could probably be integrated/cached there
> > too if this proves to bring some speedup.
>
> I have tried to fill the info into cpuinfo_x86 first, but got the info
> from there instead of 'read_mostly' area is hart performance.
> 
> BTW, I didn't see x86_tlbsize was printed under Intel's CPUs.

It should be in /proc/cpuinfo as "TLB size". But you're probably right,
having it in a __read_mostly section is probably better because a lot
less cross-CPU probes for that data would be needed.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
