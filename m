Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758035Ab1JEPaF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 11:30:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12348 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757554Ab1JEPaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 11:30:03 -0400
Date: Wed, 5 Oct 2011 17:29:54 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, kvm@vger.kernel.org,
        joerg.roedel@amd.com, mingo@elte.hu
Subject: Re: [PATCH v2 8/9] KVM, VMX: Add support for guest/host-only
 profiling
Message-ID: <20111005152954.GL30105@redhat.com>
References: <1317816084-18026-1-git-send-email-gleb@redhat.com>
 <1317816084-18026-9-git-send-email-gleb@redhat.com>
 <1317824379.6766.30.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317824379.6766.30.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 05, 2011 at 04:19:39PM +0200, Peter Zijlstra wrote:
> On Wed, 2011-10-05 at 14:01 +0200, Gleb Natapov wrote:
> > +static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
> > +{
> > +       int i, nr_msrs;
> > +       struct perf_guest_switch_msr *msrs;
> > +
> > +       msrs = perf_guest_get_msrs(&nr_msrs);
> > +
> > +       if (!msrs)
> > +               return;
> > +
> > +       for (i = 0; i < nr_msrs; i++)
> > +               if (msrs[i].host == msrs[i].guest)
> > +                       clear_atomic_switch_msr(vmx, msrs[i].msr);
> > +               else
> > +                       add_atomic_switch_msr(vmx, msrs[i].msr, msrs[i].guest,
> > +                                       msrs[i].host);
> > +} 
> 
> I don't think this will actually compile with PERF_EVENTS=n due to
> struct perf_guest_switch_msr not being defined.
Oops you are right. Turns out it is not enough to remove PERF_EVENTS
from .config to disable it. It re-appears after "make oldconfig". Should
I send incremental patch to fix that?

--
			Gleb.
