Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388Ab0LIVnc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 16:43:32 -0500
Received: from www.tglx.de ([62.245.132.106]:48748 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757311Ab0LIVnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 16:43:31 -0500
Date: Thu, 9 Dec 2010 22:43:10 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, eric.dumazet@gmail.com, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, penberg@kernel.org
Subject: Re: [PATCH 13/16] x86: Unify cpu/apicid <-> NUMA node mapping between
 32 and 64bit
In-Reply-To: <1290871325-3055-14-git-send-email-tj@kernel.org>
Message-ID: <alpine.LFD.2.00.1012092230010.2653@localhost6.localdomain6>
References: <1290871325-3055-1-git-send-email-tj@kernel.org> <1290871325-3055-14-git-send-email-tj@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Nov 2010, Tejun Heo wrote:

> The mapping between cpu/apicid and node is done via apicid_to_node[]
> on 64bit and apicid_2_node[] + apic->numa_cpu_node() on 32bit.  This
> difference makes it difficult to further unify 32 and 64bit NUMA
> hanlding.
> 
> This patch unifies it by replacing both apicid_to_node[] and
> apicid_2_node[] with __apicid_to_node[] array, which is accessed by
> two accessors - set_apicid_to_node() and numa_cpu_node().  On 64bit,
> numa_cpu_node() always consults __apicid_to_node[] directly while
> 32bit goes through apic->numa_cpu_node() method to allow apic
> implementation to override it.
> 
> There are several places where using numa_cpu_node() is awkward and
> the override doesn't matter.  In those places, __apicid_to_node[] are
> used directly.

Why is it awkward? Anything outside the accessor functions or
specialized setup code using it is awkward, inconsistent and sloppy.

Thanks,

	tglx
