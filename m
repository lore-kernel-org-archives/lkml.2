Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab2EUPWK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 11:22:10 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:42255 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab2EUPWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 11:22:04 -0400
Date: Mon, 21 May 2012 17:21:59 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Vlad Zolotarov <vlad@scalemp.com>
Cc: "Shai Fultheim (Shai@ScaleMP.com)" <Shai@scalemp.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ido Yariv <ido@wizery.com>
Subject: Re: [PATCH v3 0/2] Move x86_cpu_to_apicid to the __read_mostly
 section
Message-ID: <20120521152159.GB7068@gmail.com>
References: <1337527148.6093.14.camel@vlad>
 <1693911.sUneyHzERA@vlad>
 <20120521140822.GA12976@gmail.com>
 <2213388.vLKcp40cFW@vlad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2213388.vLKcp40cFW@vlad>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vlad Zolotarov <vlad@scalemp.com> wrote:

> On Monday, May 21, 2012 16:08:22 Ingo Molnar wrote:
> > * Vlad Zolotarov <vlad@scalemp.com> wrote:
> > > On Monday, May 21, 2012 02:32:46 PM Ingo Molnar wrote:
> > > > * Shai Fultheim (Shai@ScaleMP.com) <Shai@ScaleMP.com> wrote:
> > > > > Ingo,
> > > > > 
> > > > > The reason for this, as you pointed out, is the 'cache line'
> > > > > size (4096 bytes).  We see significant false sharing is we do
> > > > > not move this next to each other.
> > > > 
> > > > Which write-often variable caused the many cache flushes/fills?
> > > > cpu_to_apicid is read mostly.
> > > > 
> > > > I.e. it might make more sense to identify the frequenty
> > > > *modified* percpu variables, and move them to a separate
> > > > section. I *think* most percpu variables are read mostly, so
> > > > it would be more maintainable in the long run to figure out
> > > > the frequently modified ones, not the frequently not
> > > > modified ones.
> > > 
> > > I tend to disagree about the general claim that most per-CPU
> > > variables are read-mostly: consider the per-CPU data
> > > structures used in lock-less algorithms like softnet_data used
> > > in a NAPI. I'm not sure what is a more common - read- only or
> > > not-read-only per-cpu data, but surely there are both...
> > 
> > Well, a quick tally of percpu variables on a 'make defconfig'
> > kernel would tell us one way or another?
> > 
> > Here there's almost 200 percpu variables active in the 64-bit
> > x86 defconfig, and a quick random sample suggests that most are
> > read-mostly.
> > 
> > I have no fundamental prefer to either approach, but the
> > direction taken should be justified explicitly, with numbers,
> > arguments, etc. - also a short blurb somewhere in the headers
> > that explains when they should be used, so that others can be
> > aware of vSMP's special needs here.
> 
> There must be some misunderstanding - this patch is not a vSMP 
> Foundation specific as it defines read-mostly variables as 
> __read_mostly. The motivation for it is just the same as in a 
> non-vSMP Foundation case. It's true that the performance gain 
> this patch introduces in the vSMP Foundation is likely to be 
> more significant than in a native Linux, however even for a 
> native Linux it would still be a better code as __read_mostly 
> is not a vSMP Foundation specific paradigm and, again, the 
> variables modified are a clear read-mostly case.

(Could we please use 'vSMP' as a shortcut?)

I know that it's not vSMP specific - but the gains are largely 
concentrated on the vSMP side and in fact I suspect that they 
are important performance fixes for vSMP, while only 'nice to 
have' micro-optimizations on other systems, right?

As such it's useful to outline the justification and relevance 
of the patch.

> So, the explanation u request above would be just the same as 
> if I would explain when in general __read_mostly should be 
> used.
> 
> I grep'ed the Documentation and haven't found any readme file 
> with the explicit instructions when __read_mostly qualifier 
> should be used and u r right we'd better write one.

Furthermore, this is a read_mostly per cpu variable, which is 
even less obvious than a read_mostly global variable.

> I can create an initial version of such a doc but I think it 
> would better come as a separate patch.

Sure.

Thanks,

	Ingo
