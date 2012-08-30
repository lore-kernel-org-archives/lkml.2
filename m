Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598Ab2H3TAQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 15:00:16 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:62583 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab2H3TAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 15:00:15 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6820"; a="229008722"
Message-ID: <503FB836.2060000@codeaurora.org>
Date: Thu, 30 Aug 2012 12:00:06 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] ARM: smp: Fix cpu_up() racing with sys_reboot
References: <1345608229-5707-1-git-send-email-sboyd@codeaurora.org> <20120829235353.GW18957@n2100.arm.linux.org.uk>
In-Reply-To: <20120829235353.GW18957@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/29/2012 4:53 PM, Russell King - ARM Linux wrote:
> On Tue, Aug 21, 2012 at 09:03:49PM -0700, Stephen Boyd wrote:
>> Nothing stops a process from hotplugging in a CPU concurrently
>> with a sys_reboot() call. In such a situation we could have
>> ipi_cpu_stop() mark a cpu as 'offline' and _cpu_up() ignore the
>> fact that the CPU is not really offline and call the
>> CPU_UP_PREPARE notifier. When this happens stop_machine code will
>> complain that the cpu thread already exists and BUG_ON().
> This puts us at odds with x86, which is a bad thing without first
> investigating whether a generic solution which fixes all arches would
> be more appropriate.

I went this way because it seems that we stop CPUs in architecture
specific code instead of doing it generically (although we have
smp_send_stop()?). It would be nice if we could generalize the cpu
stopping code so that reboot at the architectual level doesn't have to
do this.

>
> A better solution may be to mark those CPUs as being not-present,
> which will prevent them being hot-plugged back.

That sounds fine to me. I can s/active/present/ for v2 if we can get
some kind of consensus. I was also thinking we could stop using these
functions entirely and have some private stopped CPUs map that we check
instead.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

