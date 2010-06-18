Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab0FRHMQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 03:12:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:45680 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841Ab0FRHMP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 03:12:15 -0400
Subject: Re: [RFC][PATCH 6/8] perf: Per PMU disable
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
In-Reply-To: <20100618021405.GD5345@nowhere>
References: <20100616160027.590430763@chello.nl>
	 <20100616160238.529009255@chello.nl>  <20100618021405.GD5345@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 18 Jun 2010 09:11:58 +0200
Message-ID: <1276845118.27822.1443.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-18 at 04:14 +0200, Frederic Weisbecker wrote:
> On Wed, Jun 16, 2010 at 06:00:33PM +0200, Peter Zijlstra wrote:
> > +static void armpmu_pmu_enable(struct pmu *pmu)
> >  {
> > +static void powerpc_pmu_pmu_disable(struct pmu *pmu)
> >  {
> > +static void fsl_emb_pmu_pmu_disable(struct pmu *pmu)
> >  {
> > +static void sh_pmu_pmu_enable(struct pmu *pmu)
> > +{
> > +static void sparc_pmu_pmu_enable(struct pmu *pmu)
> >  {
> > +static void x86_pmu_pmu_disable(struct pmu *pmu)
> >  {
> 
> 
> These namings are really bad. Why not just using pmu once
> in each names? x86_pmu_enable, etc...

Because some of those were already taken:

static const struct pmu pmu = {
        .enable         = x86_pmu_enable,
        .disable        = x86_pmu_disable,

