Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934594Ab1JEOTt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 10:19:49 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58326 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934342Ab1JEOTs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 10:19:48 -0400
Subject: Re: [PATCH v2 8/9] KVM, VMX: Add support for guest/host-only
 profiling
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Gleb Natapov <gleb@redhat.com>
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, kvm@vger.kernel.org,
        joerg.roedel@amd.com, mingo@elte.hu
Date: Wed, 05 Oct 2011 16:19:39 +0200
In-Reply-To: <1317816084-18026-9-git-send-email-gleb@redhat.com>
References: <1317816084-18026-1-git-send-email-gleb@redhat.com>
	 <1317816084-18026-9-git-send-email-gleb@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317824379.6766.30.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-10-05 at 14:01 +0200, Gleb Natapov wrote:
> +static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
> +{
> +       int i, nr_msrs;
> +       struct perf_guest_switch_msr *msrs;
> +
> +       msrs = perf_guest_get_msrs(&nr_msrs);
> +
> +       if (!msrs)
> +               return;
> +
> +       for (i = 0; i < nr_msrs; i++)
> +               if (msrs[i].host == msrs[i].guest)
> +                       clear_atomic_switch_msr(vmx, msrs[i].msr);
> +               else
> +                       add_atomic_switch_msr(vmx, msrs[i].msr, msrs[i].guest,
> +                                       msrs[i].host);
> +} 

I don't think this will actually compile with PERF_EVENTS=n due to
struct perf_guest_switch_msr not being defined.
