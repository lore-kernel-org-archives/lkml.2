Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758843Ab2FUIia (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 04:38:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52974 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758813Ab2FUIi1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 04:38:27 -0400
Date: Thu, 21 Jun 2012 10:31:47 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, yinghai@kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, gorcunov@openvz.org
Subject: Re: [PATCH 1/2] x86, apic: optimize cpu traversal in
 __assign_irq_vector() using domain membership
Message-ID: <20120621083146.GC2223@dhcp-26-207.brq.redhat.com>
References: <1340067097.3696.6.camel@sbsiddha-desk.sc.intel.com>
 <1340149411-2972-1-git-send-email-suresh.b.siddha@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340149411-2972-1-git-send-email-suresh.b.siddha@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 04:43:30PM -0700, Suresh Siddha wrote:
> Use the irq_cfg's old_domain to track the visited domains and optimize
> the cpu traversal while finding a free vector in the given cpumask.
> 
> NOTE: We can also optimize the search by using for_each_cpu and skip the
> current cpu, if it is not the first cpu in the mask returned by the
> vector_allocation_domain(). But re-using the cfg->old_domain to track
> the visited domains will be slightly faster.

Sorry for the dealy, Suresh.

You also need to kick out vector_allocation_domain's return value in all other
apic drivers.

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
