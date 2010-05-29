Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab0E2NTh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 09:19:37 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46152 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929Ab0E2NTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 09:19:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=a+bqbNfP0meJyOcA0TepPqWLnWmKaWN2U0IvUq2WSZe9xznzx6NqDOMqNAOUFYr+tB
         o+2WVtTDEIrMyaEI1BsDiCJo6yY8SAepqBBUdeHEIrrKHWURMxYSWrvF9Mun3ajTflbX
         diWGlKsiGFXMK/cCnZD1pPPFLapsJS39wvxs8=
Date: Sat, 29 May 2010 17:19:31 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Q] perf, x86: should perf_event_x.c being compiled
	conditionally?
Message-ID: <20100529131931.GI5322@lenovo>
References: <20100528213503.GJ20839@lenovo> <1275118737.27810.12590.camel@twins> <20100529130254.GH5322@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100529130254.GH5322@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 29, 2010 at 05:02:54PM +0400, Cyrill Gorcunov wrote:
> On Sat, May 29, 2010 at 09:38:57AM +0200, Peter Zijlstra wrote:
> > On Sat, 2010-05-29 at 01:35 +0400, Cyrill Gorcunov wrote:
> > > Hi,
> > > 
> > > while was building the kernel for pretty old laptop I've noticed
> > > that perf_event_x.c depends on CONFIG_CPU_SUP_ only. So I'm somehow
> > > confused. Should not some additional condition being used?
> > > 
> > > For example if a person have Core 2 or Nehalem machine, he will
> > > definitely not need p6 and p4 events (yes, they are not _that_ big
> > > in size, but anyway).
> > > 
> > > On the other hands distro builders would prefer to have all compiled in.
> > > 
> > > Not sure about what is the best way to resolve this, but perhaps I'm just
> > > missing some key moment?
> > 
> > We had to split out on the CPU_SUP_* stuff because the AMD support
> > relies on symbols otherwise not present.
> > 
> > So fixing build dependencies is the main reason we have that.
> > 
> > If you want to extend it, feel free, but be sure to test the
> > full .config space ;-)
> > 
> 
> Thanks for explanation. I guess we may have something like below.
> Note that I didn't squeeze into *.c files, only Kconfig is touched
> so that we get "Processor type and features" -> "Supported Perfomance
> Events" menu. All entries are "Y" by default and depends on
> PERF_EVENTS && CPU_SUP_INTEL (since we have this trick for Intel
> cpus only at moment). Just an idea.
> 

I'll take a more closer look (since we will need some placeholders
for unconditionally called funtions).

	-- Cyrill
