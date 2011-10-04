Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160Ab1JDMNG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 08:13:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932078Ab1JDMNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 08:13:05 -0400
Date: Tue, 4 Oct 2011 14:12:47 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, joerg.roedel@amd.com,
        mingo@elte.hu, a.p.zijlstra@chello.nl
Subject: Re: [PATCH 8/9] KVM, VMX: Add support for guest/host-only profiling
Message-ID: <20111004121247.GH30105@redhat.com>
References: <1317649795-18259-1-git-send-email-gleb@redhat.com>
 <1317649795-18259-9-git-send-email-gleb@redhat.com>
 <4E89CE09.1080808@redhat.com>
 <20111003153619.GA3225@redhat.com>
 <4E8AD1D3.9040402@redhat.com>
 <20111004095654.GE30105@redhat.com>
 <4E8AE9A0.2060706@redhat.com>
 <20111004111714.GG30105@redhat.com>
 <4E8AECE2.7090206@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E8AECE2.7090206@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 04, 2011 at 01:24:18PM +0200, Avi Kivity wrote:
> On 10/04/2011 01:17 PM, Gleb Natapov wrote:
> >>
> >>  I mean, CONFIG_KVM&&  !CONFIG_PERF_EVENTS is an unlikely
> >>  combination.  If you're using kvm, you usually want PERF_EVENTS.
> >>
> >Who knows. Think about someone building appliance with embedded KVM and
> >trying to achieve minimal code footprint.
> 
> Saving a few dozen bytes, then launching a 1GB guest?
> 
> >It is much easier to add ifdefs
> >at the development stage then trying to figure out later what can be
> >ifdeffed. If we will do:
> >  if (!(cnt = perf_guest_get_msrs_count())
> >	return;
> >
> >at the beginning of atomic_switch_perf_msrs() then compiler can
> >eliminate dead code in case of !CONFIG_PERF_EVENTS since
> >perf_guest_get_msrs_count() will become 0, but this will add two
> >function calls on vmentry in CONFIG_PERF_EVENTS case.
> >
> 
> Then move it to the beginning:
> 
>    nr_msrs = perf_get_guest_msrs(&msr_buffer);
>    for (i = 0; i < nr_msrs; ++i)
>           add_atomic_switch_msr((*msr_buffer)[i], nr);
> 
> the compiler will kill the loop if nr_msrs is statically 0.
> 
Good idea. Just get rid of perf_guest_get_msrs_count().

--
			Gleb.
