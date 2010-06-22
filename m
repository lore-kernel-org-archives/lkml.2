Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788Ab0FVQVf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 12:21:35 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43668 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944Ab0FVQVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 12:21:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Avcc47oTSisfd3PUEJpIdNQUkMsPMR0PuEgUIuytZby2PnAMz33BvqIP+36ximxlT6
         AUlKzkGParV55RPJnQG1n0+HAXojwKKS8jCpr7XtnCbwHMQOiBv2+1RhZG5sgZH93j53
         dYc5+Ftl0ya8rKPhoO5ycITdu54ICCagFrNc0=
Date: Tue, 22 Jun 2010 18:21:36 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 6/8] perf: Per PMU disable
Message-ID: <20100622162131.GA5458@nowhere>
References: <20100616160027.590430763@chello.nl> <20100616160238.529009255@chello.nl> <20100618021405.GD5345@nowhere> <1276845118.27822.1443.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276845118.27822.1443.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 18, 2010 at 09:11:58AM +0200, Peter Zijlstra wrote:
> On Fri, 2010-06-18 at 04:14 +0200, Frederic Weisbecker wrote:
> > On Wed, Jun 16, 2010 at 06:00:33PM +0200, Peter Zijlstra wrote:
> > > +static void armpmu_pmu_enable(struct pmu *pmu)
> > >  {
> > > +static void powerpc_pmu_pmu_disable(struct pmu *pmu)
> > >  {
> > > +static void fsl_emb_pmu_pmu_disable(struct pmu *pmu)
> > >  {
> > > +static void sh_pmu_pmu_enable(struct pmu *pmu)
> > > +{
> > > +static void sparc_pmu_pmu_enable(struct pmu *pmu)
> > >  {
> > > +static void x86_pmu_pmu_disable(struct pmu *pmu)
> > >  {
> > 
> > 
> > These namings are really bad. Why not just using pmu once
> > in each names? x86_pmu_enable, etc...
> 
> Because some of those were already taken:
> 
> static const struct pmu pmu = {
>         .enable         = x86_pmu_enable,
>         .disable        = x86_pmu_disable,


Then those should be renamed into x86_event_enable or so. 

