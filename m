Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793Ab1ELJdM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 05:33:12 -0400
Received: from 8bytes.org ([88.198.83.132]:39225 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703Ab1ELJdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 05:33:10 -0400
Date: Thu, 12 May 2011 11:33:09 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH v1 0/5] KVM in-guest performance monitoring
Message-ID: <20110512093309.GD8707@8bytes.org>
References: <1305129333-7456-1-git-send-email-avi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305129333-7456-1-git-send-email-avi@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 11:55:28AM -0400, Avi Kivity wrote:
> This not-for-merging patchset exposes an emulated version 1 architectural
> performance monitoring unit to KVM guests.  The PMU is emulated using
> perf_events, so the host kernel can multiplex host-wide, host-user, and the
> guest on available resources.
> 
> Caveats:
> - counters that have PMI (interrupt) enabled stop counting after the
>   interrupt is signalled.  This is because we need one-shot samples
>   that keep counting, which perf doesn't support yet
> - some combinations of INV and CMASK are not supported
> - counters keep on counting in the host as well as the guest
> - the RDPMC instruction and CR4.PCE bit are not yet emulated
> - there is likely a bug in the implementation; running 'perf top' in
>   a guest that spends 80% of its time in userspace shows perf itself
>   as consuming almost all cpu
> 
> perf maintainers: please consider the first three patches for merging (the
> first two make sense even without the rest).  If you're familiar with the Intel
> PMU, please review patch 5 as well - it effectively undoes all your work
> of abstracting the PMU into perf_events by unabstracting perf_events into what
> is hoped is a very similar PMU.

Gaah, I was just about to submit a talk about PMU virtualization for KVM
Forum :)

Anyway, I thought about a paravirt-approach instead of implementing a
real PMU... But there are certainly good reasons for both.

	Joerg

