Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770Ab1FVKTJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 06:19:09 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50091 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756646Ab1FVKTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 06:19:07 -0400
Date: Wed, 22 Jun 2011 13:19:02 +0300
From: Amit Kucheria <amit.kucheria@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: [RFC] Add Arm cpu topology definition
Message-ID: <20110622101902.GC2402@matterhorn1>
Mail-Followup-To: Catalin Marinas <catalin.marinas@arm.com>,
	Stephen Boyd <sboyd@codeaurora.org>, linaro-dev@lists.linaro.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Vincent Guittot <vincent.guittot@linaro.org>
References: <BANLkTinRGRUxKB=C_2Y2F93czWScEUo+Jw@mail.gmail.com>
 <4DFA5C2E.40507@codeaurora.org>
 <BANLkTi=ik=iRtDb3K__CPxSH_8GusoBHKA@mail.gmail.com>
 <4E0100BF.6080500@codeaurora.org>
 <20110622091727.GA1195@1n450.cable.virginmedia.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110622091727.GA1195@1n450.cable.virginmedia.net>
X-URL: http://www.verdurent.com/
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 Jun 22, Catalin Marinas wrote:
> On Tue, Jun 21, 2011 at 01:36:15PM -0700, Stephen Boyd wrote:
> > On 06/16/2011 11:54 PM, Vincent Guittot wrote:
> > > On 16 June 2011 21:40, Stephen Boyd <sboyd@codeaurora.org> wrote:
> > >> The ARM ARM says these fields are IMPLEMENTATION DEFINED meaning that
> > >> different vendors may attribute different meaning to these fields if
> > >> they wish. Does that mean this should be a platform_*() function?
> > >>
> > > The ARM ARM also provides a recommended use of the fields of this
> > > register and the TRM of each Cortex adds some details. On the cortex
> > > A9, each platform can only set the value of the Cluster ID with the
> > > CLUSTERID pins. I have tried to consolidate the value of MPIDR  across
> > > several platforms and they all match with the description.
> > >
> > > Have you got an example of a MPIDR register which doesn't match with
> > > the implementation ?
> > 
> > Not that I know of. I'm more concerned with how the ARM ARM has two
> > recommended usages for these fields depending on virtualization or not.
> > I suppose we can handle that issue when it arises (or does your
> > implementation already handle that?)
> 
> According to the ARM ARM:
> 
> 	MPIDR provides a mechanism with up to three levels of affinity
> 	information, but the meaning of those levels of affinity is
> 	entirely IMPLEMENTATION DEFINED.
> 
> So we can't really tell the meaning of the affinity bits. There are two
> recommended ways indeed (with or without virtualisation) which are not
> that different with regards to the topology (just introducing another
> level for virtual CPUs).
> 
> But I think a more general solution would be for the CPU topology to be
> provided via the FDT.

Agreed. That will be the next step.

We decided on doing it this way to allow non-DT-enabled platforms to be able
to use the feature and to allow DT-enabled platforms to settle down in the
mean time.

