Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758797Ab2CNHrH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 03:47:07 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:58621 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756080Ab2CNHrD convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:2>);
	Wed, 14 Mar 2012 03:47:03 -0400
Message-Id: <4F605B030200007800078327@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 14 Mar 2012 07:46:59 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: <davej@redhat.com>, <cpufreq@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mechanism to disable built in cpu frequency
 drivers/governors. (v1)
References: <1331680720-18268-1-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1331680720-18268-1-git-send-email-konrad.wilk@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 14.03.12 at 00:18, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> The purpose of these patches is two-fold:
>  1) Remove weird performance issues encountered in the field where the
>     Linux kernel cpufreq scaling drivers would change the P-states while the
>     Xen hypervisor would do the same.
>  2) Provide a runtime knob from within the kernel to disable the cpu 
> frequency
>     API (akin to the behavior of "#CONFIG_CPU_CPUFREQ is not set").

Acked-by: Jan Beulich <jbeulich@suse.com>

(Albeit I'd recommend using 'bool' for the variable and function return
types in the first patch.)

> The patches are based on the mechanism that Len Brown came up for the 
> cpuidle
> drivers - where there is a disable_cpuidle() call. His patches also provided
> a module parameter - but I wasn't sure whether that is something you would 
> want.
> (for reference, Len's patch is d91ee5863b71e8c90eaf6035bff3078a85e2e7b5)
> 
> The other way of disabling the cpufreq scaling drivers from being invoked
> is by thwarting the cpufreq drivers from loading by influencing their 
> startup
> checks.  For powernow-k8 that is easy - disallow the RDMSR (and that is 
> currently
> happening). For acpi-cpufreq I am not sure what could be done - the calls it
> makes are to the ACPI libraries which we need for other uses.
> 
> Another solution I thought off was to provide a cpufreq governor that would
> be a nop, and hence end up not calling the cpufreq scaling drivers. But that
> just seems heavy-handed and I am not sure how the decision of when to load it
> (and set it) would be done.
> 
>  arch/x86/xen/setup.c      |    1 +
>  drivers/cpufreq/cpufreq.c |   24 ++++++++++++++++++++++++
>  include/linux/cpufreq.h   |    2 ++
>  3 files changed, 27 insertions(+), 0 deletions(-)



