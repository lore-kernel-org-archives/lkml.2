Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373Ab2HUObY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 10:31:24 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60338 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706Ab2HUObV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 10:31:21 -0400
Date: Tue, 21 Aug 2012 16:31:15 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: a.p.zijlstra@chello.nl, eranian@google.com, mingo@elte.hu,
        andi@firstfloor.org, avi@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf/x86: Disable uncore on virtualized CPU.
Message-ID: <20120821143115.GJ16230@one.firstfloor.org>
References: <1345540117-14164-1-git-send-email-zheng.z.yan@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345540117-14164-1-git-send-email-zheng.z.yan@intel.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 05:08:37PM +0800, Yan, Zheng wrote:
> From: "Yan, Zheng" <zheng.z.yan@intel.com>
> 
> Initializing uncore PMU on virtualized CPU may hang the kernel.
> This is because kvm does not emulate the entire hardware. Thers
> are lots of uncore related MSRs, making kvm enumerate them all
> is a non-trival task. So just disable uncore on virtualized CPU.

I'm not sure cpu_has_hypervisor is reliable enough for this.
Better find out why it hangs and fix that.

Early rdmsrls should be rdmsrl_safe()
Early writes in the driver should check if anything was written,
and if not then disable itself.

-Andi
