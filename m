Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758889Ab2FULCf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 07:02:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51320 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758399Ab2FULCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 07:02:32 -0400
Date: Thu, 21 Jun 2012 13:00:55 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: yinghai@kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        gorcunov@openvz.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/2] x86, irq: update irq_cfg domain unless the new
 affinity is a subset of the current domain
Message-ID: <20120621110055.GE2223@dhcp-26-207.brq.redhat.com>
References: <1337643880.1997.166.camel@sbsiddha-desk.sc.intel.com>
 <1337644682-19854-1-git-send-email-suresh.b.siddha@intel.com>
 <20120606172017.GA4777@dhcp-26-207.brq.redhat.com>
 <1339806320.3475.68.camel@sbsiddha-desk.sc.intel.com>
 <20120618091740.GK3383@dhcp-26-207.brq.redhat.com>
 <1340151523.3696.27.camel@sbsiddha-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340151523.3696.27.camel@sbsiddha-desk.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 05:18:42PM -0700, Suresh Siddha wrote:
> On Mon, 2012-06-18 at 17:51 -0700, Suresh Siddha wrote:
> BTW, there is still one open that I would like to address. How to handle
> the vector pressure during boot etc (as the default vector assignment
> specifies all online cpus) when there are lot interrupt sources but
> fewer x2apic clusters (like one or two socket server case).
> 
> We should be able to do something like the appended. Any better
> suggestions? I don't want to add boot parameters to limit the x2apic
> cluster membership etc (to fewer than 16 logical cpu's) if possible.

This cpu_online_mask approach should work IMO. Although it looks little bit
hacky for me. May be we could start with default_vector_allocation_domain()
and explicitly switch to cluster_vector_allocation_domain() once booted?

As of boot parameters, I can think of multi-pass walk thru a cpumask to find a
free cluster => core => sibling. In worst case I can imagine a vector space
defragmentator. But nothing really small to avoid current code reshake.

Also, how heavy the vector pressure actually is?

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
