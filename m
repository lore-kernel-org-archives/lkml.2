Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168Ab0LIV4m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 16:56:42 -0500
Received: from www.tglx.de ([62.245.132.106]:56606 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932071Ab0LIV4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 16:56:34 -0500
Date: Thu, 9 Dec 2010 22:56:13 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, eric.dumazet@gmail.com, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, penberg@kernel.org
Subject: Re: [PATCH UPDATED#3 04/16] x86: setup_local_APIC() must always be
 called with preemption disabled
In-Reply-To: <4D00B3B9.7060702@kernel.org>
Message-ID: <alpine.LFD.2.00.1012092253530.2653@localhost6.localdomain6>
References: <1290871325-3055-1-git-send-email-tj@kernel.org> <1290871325-3055-5-git-send-email-tj@kernel.org> <4D00B3B9.7060702@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Dec 2010, Tejun Heo wrote:

> setup_local_APIC() is used to setup local APIC early during CPU
> initialization and already assumes that preemption is disabled on
> entry.  However, The function unnecessarily disables and enables
> preemption and uses smp_processor_id() multiple times in and out of
> the nested preemption disabled section.  This gives the wrong
> impression that the function might be able to handle being called with
> preemption enabled and/or migrated to another processor in the middle.
> 
> Make it clear that the function is always called with preemption
> disabled, drop the confusing preemption disable block and call
> smp_processor_id() once at the beginning of the function.

AFAICT, this one is completely unrelated to that NUMA cleanup, right ?

So this can be applied independent and should never have been part of
that NUMA series in the first place.

Thanks,

	tglx
