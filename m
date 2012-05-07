Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680Ab2EGIcp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 04:32:45 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:56364 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755544Ab2EGIcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 04:32:43 -0400
Date: Mon, 7 May 2012 10:32:38 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 1/5] x86: Move per cpu cpu_llc_shared_map to a field
 in struct cpuinfo_x86
Message-ID: <20120507083238.GJ16608@gmail.com>
References: <1a0aaa16-df06-40bf-88c7-28180455e6b9@email.android.com>
 <1335742410-11569-1-git-send-email-kjwinchester@gmail.com>
 <1335742410-11569-2-git-send-email-kjwinchester@gmail.com>
 <4F9DD0A2.7010104@zytor.com>
 <CAELBVzCzqZMbmGzE-dNgXogh95SNdvYWE5tHAxy1OYa+kknsCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAELBVzCzqZMbmGzE-dNgXogh95SNdvYWE5tHAxy1OYa+kknsCw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kevin Winchester <kjwinchester@gmail.com> wrote:

> On 29 April 2012 20:37, H. Peter Anvin <hpa@zytor.com> wrote:
> > On 04/29/2012 04:33 PM, Kevin Winchester wrote:
> >> Commit 141168c36cde ("x86: Simplify code by removing a !SMP #ifdefs from
> >> 'struct cpuinfo_x86'") caused the compilation error:
> >>
> >> mce_amd.c:(.cpuinit.text+0x4723): undefined reference to 'cpu_llc_shared_map'
> >>
> >> by removing an #ifdef CONFIG_SMP around a block containing a reference
> >> to cpu_llc_shared_map.  Rather than replace the #ifdef, move
> >> cpu_llc_shared_map to be a new cpumask_t field llc_shared_map in
> >> struct cpuinfo_x86 and adjust all references to cpu_llc_shared_map.
> >>
> >
> > Okay...  I must not get this.
> >
> > Why is this better than just moving the DEFINE_PER_CPU to a place which
> > isn't dependent on SMP?
> >
> 
> To be honest, the idea was suggested by Ingo a while back, and 
> I just volunteered to implement it.  I believe the idea was to 
> work towards gathering all CPU-specific data for SMP and !SMP 
> into one place.  That said, moving the DEFINE_PER_CPU 
> elsewhere would likely still give the same benefits as my 
> patch in terms of ifdef reduction.  I cannot really see a 
> benefit/downside either way, really.
> 
> Perhaps Ingo will chime in, and you and he (and anyone else 
> with an opinion) can figure out the best way of accomplishing 
> this simplification, and then I can adjust my series 
> accordingly.

Well, cpu_llc_shared_map is really a CPU attribute and as such I 
think the logical place for it is "struct cpuinfo_x86". Peter, 
any objections to that?

Thanks,

	Ingo
