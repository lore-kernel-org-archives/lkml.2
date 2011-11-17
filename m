Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322Ab1KQJa3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 04:30:29 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54832 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756281Ab1KQJaZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 04:30:25 -0500
Subject: Re: [PATCHv3 00/10] KVM in-guest performance monitoring
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Gleb Natapov <gleb@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
        mtosatti@redhat.com, mingo@elte.hu, acme@ghostprotocols.net
Date: Thu, 17 Nov 2011 10:30:00 +0100
In-Reply-To: <1320929850-10480-1-git-send-email-gleb@redhat.com>
References: <1320929850-10480-1-git-send-email-gleb@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1321522200.27735.27.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-10 at 14:57 +0200, Gleb Natapov wrote:
> This patchset exposes an emulated version 2 architectural performance
> monitoring unit to KVM guests.  The PMU is emulated using perf_events,
> so the host kernel can multiplex host-wide, host-user, and the
> guest on available resources.
> 
> The patches are against next branch on kvm.git.
> 
> If you want to try running perf in a guest you need to apply the patch
> below to qemu-kvm and use -cpu host on qemu command line. But DO NOT
> TRY those patches without applying [1][2] to the host kernel first.
> Don't tell me I didn't warn you!
> 
> [1] https://lkml.org/lkml/2011/10/18/390
> [2] https://lkml.org/lkml/2011/10/23/163
> 
> Changelog:
>  v1->v2
>   - put index into struct kvm_pmc instead of calculating it
>   - use locked version of bitops
>   - inject pmi from irq work if vcpu was not in a guest mode during NMI
>   - providing stub for perf_get_x86_pmu_capability() for !PERF_EVENTS
>  v2->v3
>   - minor style change/comment clarification
>   - add perf patch to disable arch event not supported by a CPU
>   - create perf events as pinned

On the pinned thing, do check event->state, if it hits
PERF_EVENT_STATE_ERROR you're up shit creek and the counter didn't get
scheduled. This can happen because eg. cpu-pinned events have higher
precedence than task-pinned events.

I've taken the two perf patches from this (6 and 7), the rest I gather
should go through the KVM tree. I've only cursory looked at the other
patches but didn't spot anything very curious.


