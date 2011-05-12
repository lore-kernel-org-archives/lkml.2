Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757740Ab1ELOYw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 10:24:52 -0400
Received: from 8bytes.org ([88.198.83.132]:47817 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757683Ab1ELOYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 10:24:50 -0400
Date: Thu, 12 May 2011 16:24:49 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Avi Kivity <avi@redhat.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH v1 0/5] KVM in-guest performance monitoring
Message-ID: <20110512142449.GI8707@8bytes.org>
References: <1305129333-7456-1-git-send-email-avi@redhat.com> <20110512093309.GD8707@8bytes.org> <4DCBACC7.8080000@siemens.com> <20110512131130.GG8707@8bytes.org> <4DCBE13A.2050204@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DCBE13A.2050204@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 04:31:38PM +0300, Avi Kivity wrote:
> - when the cpu gains support for virtualizing the architectural feature,  
> we transparently speed the guest up, including support for live  
> migrating from a deployment that emulates the feature to a deployment  
> that properly virtualizes the feature, and back.  Usually the  
> virtualized support will beat the pants off any paravirtualization we can 
> do
> - following an existing spec is a lot easier to get right than doing  
> something from scratch
> - no need to meticulously document the feature

Need to be done, but not problematic I think.

> - easier testing

Testing shouldn't be different on both variants I think.

> - existing guest support - only need to write the host side (sometimes  
> the only one available to us)

Otherwise I agree.

> Paravirtualizing does have its advantages.  For the PMU, for example, we  
> can have a single hypercall read and reprogram all counters, saving  
> *many* exits.  But I think we need to start from the architectural PMU  
> and see exactly what the problems are, before we optimize it to death.

The problem certainly is that with arch-pmu we add a lot of msr-exits to
the guest-context-switch path if it uses per-task profiling. Depending
on the workload this can very much distort the results.

	Joerg

